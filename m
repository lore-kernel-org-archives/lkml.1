Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXLNHto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXLNHto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXLNHtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:49:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:33321 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbXLNHtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iaeHKPOE+QBN0CUmVIJlmlMwlLGWqa274w7FZW0OiHolu1hQf3BpOprNTCdJF9+eiyrysGpCdtSMJj+jzSCfaKvSJdVWk1IeOyAmFuKHkTnakKfl/x/gFxmDdrUAQhX8PE/u0nuoN3fQNiPSqrv+/+H6KVm5JNXEqZMW4i4ZJxY=
Message-ID: <86802c440712132349h2e87442akf1b166bb2dbfbf05@mail.gmail.com>
Date: Thu, 13 Dec 2007 23:49:27 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David P. Reed" <dpreed@reed.com>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some AMD64x2 laptops, etc.
Cc: "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>, "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <4761F193.7090400@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>
	 <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos>
	 <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com>
	 <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com>
	 <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 6:59 PM, David P. Reed <dpreed@reed.com> wrote:
> Replace use of outb to "unused" diagnostic port 0x80 for time delay
> with udelay based time delay on x86_64 architecture machines.  Fix for
> bugs 9511 and 6307 in bugzilla, plus bugs reported in
> bugzilla.redhat.com.
>
> Derived from suggestion (that didn't compile) by Pavel Machek, and
> tested, also based on measurements of typical timings of out's
> collated by Rene Herman from many in the community.
>
> This patch fixes a number of bugs known to cause problems on HP
> Pavilion dv9000z and dv6000z laptops - in the form of solid freezes
> when hwclock is used to show or set the time.  Also, it potentially
> improves bus utilization on SMP machines, by using a waiting process
> that doesn't tie up the ISA/LPC bus for 1 or 2 microseconds.
>
> i386 family fixes (completely parallel) were not included, considering
> that such machines might involve more risk of problems on legacy machines.
>
> Signed-off-by: David P. Reed <dpreed@reed.com>
>
> Index: linux-2.6/arch/x86/boot/compressed/misc_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/compressed/misc_64.c
> +++ linux-2.6/arch/x86/boot/compressed/misc_64.c
> @@ -269,10 +269,10 @@ static void putstr(const char *s)
>          RM_SCREEN_INFO.orig_y = y;
>
>          pos = (x + cols * y) * 2;       /* Update cursor position */
> -       outb_p(14, vidport);
> -       outb_p(0xff & (pos >> 9), vidport+1);
> -       outb_p(15, vidport);
> -       outb_p(0xff & (pos >> 1), vidport+1);
> +       outb(14, vidport);
> +       outb(0xff & (pos >> 9), vidport+1);
> +       outb(15, vidport);
> +       outb(0xff & (pos >> 1), vidport+1);
>   }
>
>   static void* memset(void* s, int c, unsigned n)
> Index: linux-2.6/include/asm/io_64.h
> ===================================================================
> --- linux-2.6.orig/include/asm/io_64.h
> +++ linux-2.6/include/asm/io_64.h

include/asm-x64/io_64.h ?

YH
