Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbXFKTA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbXFKTA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXFKTAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:00:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52401 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbXFKTAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:00:47 -0400
Date: Mon, 11 Jun 2007 12:00:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christian Leber <christian@leber.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: beeping patch for debugging acpi sleep
Message-Id: <20070611120034.f6d972de.akpm@linux-foundation.org>
In-Reply-To: <20070609130817.GI27793@elf.ucw.cz>
References: <20070518213701.GA810@core>
	<20070520200142.GB5235@ucw.cz>
	<20070602182014.GB29546@core>
	<20070609130817.GI27793@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 15:08:17 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Starting beeper as soon as ACPI sleep returns is very useful in
> debugging "apparently dead" machines. If it beeps at all, it makes
> sense to start playing with CMOS tracer.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/arch/i386/kernel/acpi/wakeup.S b/arch/i386/kernel/acpi/wakeup.S
> index b781b38..cbf136e 100644
> --- a/arch/i386/kernel/acpi/wakeup.S
> +++ b/arch/i386/kernel/acpi/wakeup.S
> @@ -11,7 +11,22 @@ # Do we need to deal with A20? It is oka
>  #
>  # If physical address of wakeup_code is 0x12345, BIOS should call us with
>  # cs = 0x1234, eip = 0x05
> -# 
> +#
> +
> +#define BEEP \
> +	inb	$97, %al; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$3, %al; 	\
> +	outb	%al, $97; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-74, %al; 	\
> +	outb	%al, $67; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$-119, %al; 	\
> +	outb	%al, $66; 	\
> +	outb	%al, $0x80; 	\
> +	movb	$15, %al; 	\
> +	outb	%al, $66;
>  
>  ALIGN
>  	.align	4096
> @@ -20,6 +35,9 @@ wakeup_code:
>  	wakeup_code_start = .
>  	.code16
>  
> +# Uncomment this to make your computer start producing ugly noise as soon
> +# as BIOS returns to this real-mode entry point.
> +#	BEEP
>   	movw	$0xb800, %ax
>  	movw	%ax,%fs
>  	movw	$0x0e00 + 'L', %fs:(0x10)
> 

How does the beep get turned off again?

Should the BEEP line be uncommented (in -mm at least)?

