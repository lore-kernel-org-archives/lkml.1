Return-Path: <linux-kernel-owner+w=401wt.eu-S1755452AbYEEBnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452AbYEEBnm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 21:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYEEBna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 21:43:30 -0400
Received: from uki.us.mooball.net ([66.98.178.13]:48622 "EHLO
	uki.us.mooball.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYEEBn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 21:43:29 -0400
X-ClientAddr: 220.233.82.121
Subject: Re: [PATCH 01/56] microblaze_v2: Kconfig patches
From: John Williams <john.williams@petalogix.com>
To: monstr@seznam.cz
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Content-Type: text/plain
Organization: PetaLogix
Date: Mon, 05 May 2008 11:42:41 +1000
Message-Id: <1209951761.5798.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
X-Mooball.com-MailScanner-Information: Please contact the ISP for more information
X-Mooball.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: john.williams@petalogix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Sun, 2008-05-04 at 13:40 +0200, monstr@seznam.cz wrote:

> +config EARLY_PRINTK_UARTLITE_ADDRESS
> +	hex "Physical address where UART Lite for early printk is mapped"
> +	depends on EARLY_PRINTK
> +	default "0x40100000"
> +	help
> +	  Please enter physical address where your uart lite is mapped.

I think this should default to 0x00000000, then in the early_printk code
we can test for zero baseaddress and attempt some sensible fallback in
that case (even to disable).  
> +
> +config HEART_BEAT
> +	bool "Heart beat function for kernel"
> +	help
> +	  This option turns on/off heart beat kernel functionality on selected
> +	  GPIO address.
> +
> +config HEART_BEAT_ADDRESS
> +	hex "Physical address for heart beat LED"
> +	depends on HEART_BEAT
> +	default "0x40600000"
> +	help
> +	  Please enter physical address GPIO LED.

Again, default address should be zero which is checked in the code (zero
can disable).  Prevent accesses to random memory locations in case of
poorly configured kernel.


> +config HACK
> +	bool "Increase performance"
> +	default y

As suggested by Grant, this sohuld be

1. renamed and described as something sensible

SELF_MODIFYING_CODE_HACK

2. Made condition on CONFIG_EXPERIMENTAL at very least.

> +config OPT_LIB_FUNCTION
> +	bool "Optimalized lib function"
> +	default y
> +	help
> +	  Allows turn on optimalized library function (memcpy and memmove).
> +	  They are optimized by using unsigned alignment. This will work

"Unsigned alignment"??

Do you mean word-aligned?

> +	  fine if both source and destination are aligned on the same
> +	  boundary. However, if they are aligned on different boundaries
> +	  shifts will be necessary. This might result in bad performance
> +	  on MicroBlaze systems without a barrel shifter.
> +
> +# This is still a bit broken - disabling for now JW 20070504
> +config ALLOW_EDIT_AUTO
> +	bool "Permit Display/edit of Kconfig.auto platform settings"
> +	default n
> +	help
> +	  Allows the editing of auto-generated platform settings from
> +	  the Kconfig.auto file. Obviously this does not change the
> +	  underlying hardware, so be very careful if you go editing
> +	  these settings.
> +
> +	  Also, if you enable this, and edit various Kconfig.auto
> +	  settings, YOUR CHANGES WILL BE LOST if you then disable it
> +	  again. You have been warned!
> +
> +	  If unsure, say no.
> +
> +# Ok, the platform is chosen. Source the kconfig.auto to get all of the
> +# system settings.

Should be just "get all of the CPU settings", since we use OF to get the
device tree.

> diff --git a/arch/microblaze/platform/generic/Kconfig.auto b/arch/microblaze/platform/generic/Kconfig.auto
> new file mode 100644
> index 0000000..5dc8c15
> --- /dev/null
> +++ b/arch/microblaze/platform/generic/Kconfig.auto

> +config XILINX_ERAM_SIZE
> +	hex "Memory size of XILINX_RAM"
> +	depends on XILINX_UNCACHED_SHADOW
> +	default 0x02000000

Why does this depend on UNCACHED_SHADOW?

Regards,

John



