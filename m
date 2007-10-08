Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbXJHXxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbXJHXxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 19:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXJHXxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 19:53:43 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:39320 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbXJHXxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 19:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XpA8W14uevF6Z807db12ER/KdHjhFq80+MEHy6hQ4/AblNyj3+y2klQjMmXDI5U/3m+PLmStJrNorJv5UOh9szznFuQtfXkalgGwJw3oBhpJqzjgPXkHCDabW841ImO4x4GYKi8YDMR+kbDH4Ob51gZZgcokie3f8P7704fvt08=
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0710090118040.14524@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
	 <1191885157.5508.27.camel@daplas>
	 <Pine.LNX.4.64.0710090118040.14524@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 07:53:34 +0800
Message-Id: <1191887614.5508.47.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 01:31 +0200, Jan Engelhardt wrote:
> On Oct 9 2007 07:12, Antonino A. Daplas wrote:
> >> 
> >> References: http://lkml.org/lkml/2007/4/1/162
> >> 	http://lkml.org/lkml/2007/10/5/199
> >
> >This is quite a long thread :-)
> 
> It was a patch series after all. But as Greg puts it, be persistent.
> 
> >> +config VT_PRINTK_COLOR
> >> +	hex "Colored kernel message output"
> >> +	range 0x00 0xFF
> >> +	depends on VT_CKO
> >> +	default 0x07
> >> +	---help---
> >> +	This option defines with which color kernel messages will be
> >> +	printed to the console.
> >> +
> >> +	The value you need to enter here is the value is composed
> >
> >The more correct term for "The value" is probably "The attribute".
> 
> "The value for this kconfig entry" it should read in the minds.
> 
> >> +	(Foreground colors 0x08 to 0x0F do not work when a VGA
> >> +	console font with 512 glyphs is used.)
> >
> >You might have to include a warning that those values or attributes are 
> >interpreted differently depending on the driver used, and the above is
> >mostly true for 16-color console drivers only.
> 
> Are there any other drivers besides vgacon and fbcon that use vt.c?

All drivers under drivers/video/console. That would be:

vgacon
dummycon
fbcon
newport_con
sticon
promcon
mdacon

There are perhaps a few more drivers outside this directory, such as
sisusbcon or something.

<snip>

> >You may want to leave out the blink attribute (0x80) from this part.
> >Otherwise setterm -blink on|off will produce the opposite effect. 
> 
> But 0x80 might be interpreted in a different fashion for some othercon, 
> yielding for example superbold rather than blinking.

That's right. But setting the blink attribute is done with an XOR (^).
So 'setterm -blink' on will unset the blink attribute (0x80 ^ 0x80).

> I'll have to try this, because usually, setterm operates on TTYs
> rather than VCs.

Yes, but if the tty driver type is a virtual console, then vt.c is still
affected. 

Well the blink attribute is ignored by most drivers, if I'm not
mistaken. So you generally won't see the effect :-). But with fbcon, the
blink attribute is interpreted as "change background color from black to
light gray".

Tony

