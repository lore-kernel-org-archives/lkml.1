Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbYEEOP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbYEEOP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYEEOPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:15:48 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:61289 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752629AbYEEOPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:15:47 -0400
Message-ID: <481F16CD.1040503@seznam.cz>
Date: Mon, 05 May 2008 16:16:45 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: John Williams <john.williams@petalogix.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 01/56] microblaze_v2: Kconfig patches
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>	 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <1209951761.5798.27.camel@localhost>
In-Reply-To: <1209951761.5798.27.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John

>> +config EARLY_PRINTK_UARTLITE_ADDRESS
>> +	hex "Physical address where UART Lite for early printk is mapped"
>> +	depends on EARLY_PRINTK
>> +	default "0x40100000"
>> +	help
>> +	  Please enter physical address where your uart lite is mapped.
> 
> I think this should default to 0x00000000, then in the early_printk code
> we can test for zero baseaddress and attempt some sensible fallback in
> that case (even to disable).  

FIXED and use EARLY_PRINTK to default set to no.

>> +
>> +config HEART_BEAT
>> +	bool "Heart beat function for kernel"
>> +	help
>> +	  This option turns on/off heart beat kernel functionality on selected
>> +	  GPIO address.
>> +
>> +config HEART_BEAT_ADDRESS
>> +	hex "Physical address for heart beat LED"
>> +	depends on HEART_BEAT
>> +	default "0x40600000"
>> +	help
>> +	  Please enter physical address GPIO LED.
> 
> Again, default address should be zero which is checked in the code (zero
> can disable).  Prevent accesses to random memory locations in case of
> poorly configured kernel.

the same

>> +config HACK
>> +	bool "Increase performance"
>> +	default y
> 
> As suggested by Grant, this sohuld be
> 
> 1. renamed and described as something sensible
> 
> SELF_MODIFYING_CODE_HACK
> 
> 2. Made condition on CONFIG_EXPERIMENTAL at very least.


  21 config SELFMOD
  22         bool "Use self modified code for intc/timer"
  23         depends on EXPERIMENTAL
  24         default n
  25         help
  26           This choice enables self-modified code for interrupt controller
  27           and timer.
  28
  29 config SELFMOD_INTC
  30         bool "Use self modified code for intc"
  31         depends on SELFMOD
  32         default y
  33         help
  34           This choice enables self-modified code for interrupt controller.
  35
  36 config SELFMOD_TIMER
  37         bool "Use self modified code for timer"
  38         depends on SELFMOD
  39         default y
  40         help
  41           This choice enables self-modified code for timer.

FIXED.

>> +config OPT_LIB_FUNCTION
> +	bool "Optimalized lib function"
>> +	default y
>> +	help
>> +	  Allows turn on optimalized library function (memcpy and memmove).
>> +	  They are optimized by using unsigned alignment. This will work
> 
> "Unsigned alignment"??
> 
> Do you mean word-aligned?

FIXED

>> +	  fine if both source and destination are aligned on the same
>> +	  boundary. However, if they are aligned on different boundaries
>> +	  shifts will be necessary. This might result in bad performance
>> +	  on MicroBlaze systems without a barrel shifter.
>> +
>> +# This is still a bit broken - disabling for now JW 20070504
>> +config ALLOW_EDIT_AUTO
>> +	bool "Permit Display/edit of Kconfig.auto platform settings"
>> +	default n
>> +	help
>> +	  Allows the editing of auto-generated platform settings from
>> +	  the Kconfig.auto file. Obviously this does not change the
>> +	  underlying hardware, so be very careful if you go editing
>> +	  these settings.
>> +
>> +	  Also, if you enable this, and edit various Kconfig.auto
>> +	  settings, YOUR CHANGES WILL BE LOST if you then disable it
>> +	  again. You have been warned!
>> +
>> +	  If unsure, say no.
>> +
>> +# Ok, the platform is chosen. Source the kconfig.auto to get all of the
>> +# system settings.
> 
> Should be just "get all of the CPU settings", since we use OF to get the
> device tree.

I keep this for now. I hope we will talked about later with Xilinx guys what
happen with platforms.

>> diff --git a/arch/microblaze/platform/generic/Kconfig.auto b/arch/microblaze/platform/generic/Kconfig.auto
>> new file mode 100644
>> index 0000000..5dc8c15
>> --- /dev/null
>> +++ b/arch/microblaze/platform/generic/Kconfig.auto
> 
>> +config XILINX_ERAM_SIZE
>> +	hex "Memory size of XILINX_RAM"
>> +	depends on XILINX_UNCACHED_SHADOW
>> +	default 0x02000000
> 
> Why does this depend on UNCACHED_SHADOW?

Because consistent.c needs to know where was the end of memory. This issue
hasn't never tested. Currently consistent.c is removed.

M
