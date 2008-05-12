Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbYELNxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbYELNxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbYELNxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:53:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbYELNxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:53:11 -0400
Date: Mon, 12 May 2008 15:53:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: wakeup.lds.S - section ordering fix
Message-ID: <20080512135343.GA1725@elf.ucw.cz>
References: <20080511184638.GE6942@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511184638.GE6942@cvg>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-05-11 22:46:38, Cyrill Gorcunov wrote:
> To allow linker to catch sections overlapping we have to declare
> them in appropriate order.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Please test and review

Looks okay to me, but I can't easily test it right now.

But I think Rafael tested identical patch, you can add my ACK in such
case.

								Pavel

> Index: linux-2.6.git/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/acpi/realmode/wakeup.lds.S	2008-05-11 20:21:58.000000000 +0400
> +++ linux-2.6.git/arch/x86/kernel/acpi/realmode/wakeup.lds.S	2008-05-11 22:34:42.000000000 +0400
> @@ -12,11 +12,6 @@ ENTRY(_start)
>  
>  SECTIONS
>  {
> -	. = HEADER_OFFSET;
> -	.header : {
> -		 *(.header)
> -	}
> -
>  	. = 0;
>  	.text : {
>  		 *(.text*)
> @@ -50,6 +45,11 @@ SECTIONS
>  		__bss_end = .;
>  	}
>  
> +	. = HEADER_OFFSET;
> +	.header : {
> +		*(.header)
> +	}
> +
>  	. = ALIGN(16);
>  	_end = .;
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
