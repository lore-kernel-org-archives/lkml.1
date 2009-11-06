Return-Path: <linux-kernel-owner+w=401wt.eu-S1756832AbZKFKF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbZKFKF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 05:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZKFKF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 05:05:58 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:58008 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbZKFKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 05:05:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xfV/sDxlZ/ReG1Hk98JXSFPYSKZFU/USVXPgSV3zt0HvAKz9kFUBiud/vwcFduGsy5
         SIhwr2AuwkO1nPV812qalHyhxfqkxsvdEETY+YIzeie4C2n0OZiOG96DY0nbPz7TmHjk
         lc51S9qa/dCdmoGWr8lWFoNdmSAATTE8ClahA=
Subject: Re: [PATCH -queue v0 4/6] [loongson] add basic fuloong2f support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
       huhb@lemote.com, yanh@lemote.com, Zhang Le <r0bertz@gentoo.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
In-Reply-To: <20091106083042.GA17723@linux-mips.org>
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	 <0f805f7d12c5a7cbcc125ba4a1b70113ec2047a6.1257325319.git.wuzhangjin@gmail.com>
	 <20091105131603.GA18232@linux-mips.org>
	 <1257485984.2299.21.camel@falcon.domain.org>
	 <20091106083042.GA17723@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 06 Nov 2009 18:05:59 +0800
Message-ID: <1257501959.2299.52.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ralf

I will split the coming patchset as three parts?

1. fixes of old support
2. loongson2f support
3. lemote 2f family machines support

is this okay?

Regards,
	Wu Zhangjin

On Fri, 2009-11-06 at 09:30 +0100, Ralf Baechle wrote:
> On Fri, Nov 06, 2009 at 01:39:44PM +0800, Wu Zhangjin wrote:
> 
> > > > +	if ((LOONGSON_INTISR & LOONGSON_INTEN) & LOONGSON_INT_BIT_INT0) {
> > > > +		imr = inb(0x21) | (inb(0xa1) << 8);
> > > > +		isr = inb(0x20) | (inb(0xa0) << 8);
> > > > +		isr &= ~0x4;	/* irq2 for cascade */
> > > > +		isr &= ~imr;
> > > > +		irq = ffs(isr) - 1;
> > > > +	}
> > > 
> > > Any reason why you're not using i8259_irq() from <asm/i8259.h> here?
> > > That function not only gets the locking right, it also minimizes the number
> > > of accesses to the i8259 - which even on modern silicon can be stuningly
> > > slow.
> 
> > Just asked Yanhua, He told me there is a bug in cs5536, if using the
> > i8259_irq() directly, we can not get the irq. and just tried it, the
> > kernel hang on booting.
> 
> Wonderful.  Even 30 years after it was built there are still new i8259
> bugs :-)
> 
> This is probably worth a comment in the code.
> 
>   Ralf


