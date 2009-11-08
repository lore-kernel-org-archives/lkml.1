Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKHSqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKHSqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZKHSqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:46:31 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:44242 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZKHSqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:46:30 -0500
Date: Sun, 8 Nov 2009 13:46:25 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Matteo Croce <technoboy85@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091108134625.74ff5235@mycelium.queued.net>
In-Reply-To: <40101cc30911081004j47f55878h1590140da8369674@mail.gmail.com>
References: <20091106154911.29400@gmx.net>
	<20091106155937.11d95279@lxorguk.ukuu.org.uk>
	<20091106165731.26800@gmx.net>
	<20091106182218.43940287@lxorguk.ukuu.org.uk>
	<20091106200620.179910@gmx.net>
	<m3r5sbcl07.fsf@intrepid.localdomain>
	<20091107000559.166710@gmx.net>
	<40101cc30911070311u56035911l5eb50ac4abb73acc@mail.gmail.com>
	<20091108110512.3cfad100@mycelium.queued.net>
	<40101cc30911081004j47f55878h1590140da8369674@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 19:04:35 +0100
Matteo Croce <technoboy85@gmail.com> wrote:

[...]
> 
> True, but also remove the duplicate function is_geode in the NAND
> driver and use the identical one defined in geode.h:
> 
> --- a/drivers/mtd/nand/cs553x_nand.c	2009-11-08
> 18:58:14.835043214 +0100 +++ b/drivers/mtd/nand/cs553x_nand.c
> 2009-11-08 19:00:07.914117831 +0100 @@ -30,6 +30,7 @@
> 
>  #include <asm/msr.h>
>  #include <asm/io.h>
> +#include <asm/geode.h>
> 
>  #define NR_CS553X_CONTROLLERS	4
> 
> @@ -260,23 +261,6 @@
>  	return err;
>  }
> 
> -static int is_geode(void)
> -{
> -	/* These are the CPUs which will have a CS553[56] companion
> chip */
> -	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> -	    boot_cpu_data.x86 == 5 &&
> -	    boot_cpu_data.x86_model == 10)
> -		return 1; /* Geode LX */
> -
> -	if ((boot_cpu_data.x86_vendor == X86_VENDOR_NSC ||
> -	     boot_cpu_data.x86_vendor == X86_VENDOR_CYRIX) &&
> -	    boot_cpu_data.x86 == 5 &&
> -	    boot_cpu_data.x86_model == 5)
> -		return 1; /* Geode GX (née GX2) */
> -
> -	return 0;
> -}
> -
> 
>  #ifdef CONFIG_MTD_PARTITIONS
>  static const char *part_probes[] = { "cmdlinepart", NULL };


I think the nand driver needs a bit more love than this.  The cs553x is
available for non-geode platforms, so a cs553x driver should not be
checking for the existence of a specific CPU.
