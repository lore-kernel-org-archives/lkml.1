Return-Path: <linux-kernel-owner+w=401wt.eu-S1761645AbYFDMQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761645AbYFDMQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760915AbYFDMLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:11:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50566 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760909AbYFDMLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:11:03 -0400
Date: Wed, 4 Jun 2008 12:55:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tim Bird <tim.bird@am.sony.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console - Add configurable support for console charset
 translation
Message-ID: <20080604125500.0fce2ea4@core>
In-Reply-To: <4845DB46.3020308@am.sony.com>
References: <48447615.5050806@am.sony.com>
	<1212500751.16924.322.camel@pmac.infradead.org>
	<4845DB46.3020308@am.sony.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is clearly an improvement. But it is missing this part of the
> original patch:
> 
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -2198,7 +2198,11 @@ rescan_last_byte:
>  			c = 0xfffd;
>  		    tc = c;
>  		} else {	/* no utf or alternate charset mode */
> +#ifdef CONFIG_CONSOLE_TRANSLATIONS
>  		    tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
> +#else
> +		    tc = c;
> +#endif

Can we please get the ifdefs tided up before this goes in.

For the moment this has a NAK from the tty maintainer but if the ifdefs
turned went into headers where they belong and the code looked like say

		tc = vc_translate(vc, c);

with two versions of vc_translate (one being vc_translate(x) (x)) it
might be more reasonable.

We can't stick random ifdefs in bits of code for arbitary 6K savings or
the entire kernel would be ifdefs.


Sor for the moment

Nacked-by: Alan Cox <alan@redhat.com>

but scope for change
