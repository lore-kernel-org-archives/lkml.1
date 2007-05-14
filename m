Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXENFu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXENFu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 01:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757737AbXENFuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 01:50:22 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:36274 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638AbXENFuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 01:50:21 -0400
Date: Mon, 14 May 2007 07:49:31 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mattia Dongili <malattia@linux.it>
cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: Re: Linux 2.6.22-rc1
In-Reply-To: <20070514015541.GB4800@inferi.kami.home>
Message-ID: <Pine.LNX.4.61.0705140742350.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705131123280.9570@yvahk01.tjqt.qr>
 <20070514015541.GB4800@inferi.kami.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14 2007 10:55, Mattia Dongili wrote:
>On Sun, May 13, 2007 at 11:27:31AM +0200, Jan Engelhardt wrote:
>> On May 12 2007 20:20, Linus Torvalds wrote:
>> >
>> >Ok, the merge window has closed, and 2.6.22-rc1 is out there.
>> 
>> I have hit a randconfig compile failure. .config attached.
>> 
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `acpi_bus_generate_event':
>> (.text+0x233f7): undefined reference to `event_is_open'
>> drivers/built-in.o: In function `acpi_bus_get_power':
>> (.text+0x236ad): undefined reference to `acpi_power_get_inferred_state'
>> drivers/built-in.o: In function `acpi_bus_set_power':
>> (.text+0x237c3): undefined reference to `acpi_power_transition'
>> drivers/built-in.o: In function `acpi_bus_set_power':
>> (.text+0x23835): undefined reference to `acpi_power_transition'
>> drivers/built-in.o: In function `sony_pic_fanspeed_store':
>> sony-laptop.c:(.text+0x91930): undefined reference to `ec_write'
>> drivers/built-in.o: In function `sony_pic_fanspeed_show':
>> sony-laptop.c:(.text+0x9195d): undefined reference to `ec_read'
>> make: *** [.tmp_vmlinux1] Error 1
>
>I actually can't reproduce it with your .config.

But I can. Did you try it on x86_64? From 2.6.22-rc1 [
commit 39403865d2e4590802553370a56c9ab93131e4ee in /linux-2.6.git] ?

	bzip2 -cd randconfig-1.bz2 >.config
	make -j8

  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -s arch/x86_64/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol '
drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_G
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config sym
drivers/input/mouse/Kconfig:181:warning: 'select' used by config symbol
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86_64


>>From a clean tree, running make fires up the oldconfig which fixes the
>many missing/garbled dependencies. In any case SONY_LAPTOP depends on
>ACPI which always build EC statically if selected.

I really presume it is something on x86_64, because doing

	gzip -cd /proc/config.gz
	make

on i386 seemed to compile fine - including the sony modules.




	Jan
-- 
