Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbYEKSQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbYEKSQY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYEKSQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:16:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYEKSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:16:15 -0400
Message-ID: <482737A8.4040602@zytor.com>
Date: Sun, 11 May 2008 11:15:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Mikael Pettersson <mikpe@it.uu.se>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc1 on x86: ld: warning: dot moved backwards before	`.text'
References: <18470.787.498329.144701@harpo.it.uu.se> <482604D1.7020804@zytor.com> <20080510211602.GA32339@uranus.ravnborg.org> <20080511154411.GB6942@cvg>
In-Reply-To: <20080511154411.GB6942@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Should not it be something like
> ---
> 
> diff --git a/arch/x86/kernel/acpi/realmode/wakeup.lds.S b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> index 22fab6c..cccf62d 100644
> --- a/arch/x86/kernel/acpi/realmode/wakeup.lds.S
> +++ b/arch/x86/kernel/acpi/realmode/wakeup.lds.S
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
> @@ -53,6 +48,11 @@ SECTIONS
>  	. = ALIGN(16);
>  	_end = .;
>  
> +	. = HEADER_OFFSET;
> +	.header : {
> +		 *(.header)
> +	}
> +
>  	/DISCARD/ : {
>  		*(.note*)
>  	}
> ---
> 		- Cyrill -

Yes.  This was the way I originally had it, then Pavel decided to move 
the header to the end.

	-hpa
