Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbXGWHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbXGWHOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXGWHO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:14:26 -0400
Received: from rzcomm12.rz.tu-bs.de ([134.169.9.59]:56533 "EHLO
	rzcomm12.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbXGWHOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:14:25 -0400
Message-ID: <46A45544.8090303@l4x.org>
Date: Mon, 23 Jul 2007 09:14:12 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Thunderbird 2.0.0.5pre (Windows/20070717)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: alpha, i386,mips,powerpc,ppc,xtensa compile brakage (was Re: Linus
 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.

Compared to 2.6.22>

# alpha/defconfig: broke

   LD      .tmp_vmlinux1
arch/alpha/kernel/built-in.o(.text+0xcdf8): In function `module_frob_arch_sections':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0xcdfc):include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0x190d8): In function `srmcons_get_private_struct':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.text+0x190dc):include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.init.text+0x948): In function `register_cpus':
include/linux/slub_def.h:154: undefined reference to `__kmalloc_size_too_large'
arch/alpha/kernel/built-in.o(.init.text+0x94c):include/linux/slub_def.h:154: more undefined references to `__kmalloc_size_too_large' follow
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

# i386/allmodconfig: broke

   CC [M]  drivers/misc/asus-laptop.o
drivers/misc/asus-laptop.c: In function `asus_led_exit':
drivers/misc/asus-laptop.c:1076: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1076: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1077: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1077: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1078: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1078: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1079: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1079: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1080: error: structure has no member named `class_dev'
drivers/misc/asus-laptop.c:1080: error: structure has no member named `class_dev'
make[3]: *** [drivers/misc/asus-laptop.o] Error 1
make[2]: *** [drivers/misc] Error 2
make[1]: *** [drivers] Error 2
make: *** [_all] Error 2

# mips/defconfig: broke

   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
drivers/built-in.o(.text+0x1ce30): In function `store_uevent':
drivers/base/core.c: undefined reference to `kobject_actions'
drivers/built-in.o(.text+0x1ce34):drivers/base/core.c: undefined reference to `kobject_actions'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

# powerpc/iseries_defconfig: broke

   CC [M]  drivers/scsi/scsi_transport_sas.o
   CC [M]  drivers/scsi/scsi_wait_scan.o
   LD      drivers/scsi/ibmvscsi/built-in.o
   CC [M]  drivers/scsi/ibmvscsi/ibmvscsi.o
drivers/scsi/ibmvscsi/ibmvscsi.c: In function 'ibmvscsi_reset_host':
drivers/scsi/ibmvscsi/ibmvscsi.c:517: error: implicit declaration of function 'vio_enable_interrupts'
make[4]: *** [drivers/scsi/ibmvscsi/ibmvscsi.o] Error 1
make[3]: *** [drivers/scsi/ibmvscsi] Error 2
make[2]: *** [drivers/scsi] Error 2
make[1]: *** [drivers] Error 2
make: *** [_all] Error 2

# ppc/bamboo_defconfig: broke

   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
drivers/built-in.o(.text+0x1ebda): In function `store_uevent':
drivers/base/core.c:312: undefined reference to `kobject_actions'
drivers/built-in.o(.text+0x1ebe6):drivers/base/core.c:312: undefined reference to `kobject_actions'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [_all] Error 2

# xtensa/defconfig: broke
   CC      kernel/time/clocksource.o
In file included from include/linux/clocksource.h:18,
                  from kernel/time/clocksource.c:27:
include2/asm/io.h: In function `virt_to_phys':
include2/asm/io.h:46: error: implicit declaration of function `__pa'
include2/asm/io.h: In function `phys_to_virt':
include2/asm/io.h:51: error: implicit declaration of function `__va'
include2/asm/io.h:51: warning: return makes pointer from integer without a cast
make[3]: *** [kernel/time/clocksource.o] Error 1
make[2]: *** [kernel/time] Error 2
make[1]: *** [kernel] Error 2
make: *** [_all] Error 2

Jan
