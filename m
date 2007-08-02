Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbXHBJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbXHBJ4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXHBJ4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:56:09 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:36241 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbXHBJ4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:56:07 -0400
Message-ID: <46B1A9DE.4090907@free.fr>
Date: Thu, 02 Aug 2007 11:54:38 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-rt-users@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Section mismatch: reference to .init.text: (between 'kthreadd' and
 'init_waitqueue_head')
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to build a 2.6.22.1-rt9 kernel for a P3.

I used 'make xconfig' to create .config
http://linux.kernel.free.fr/latency/config-2.6.22.1-rt9-adlink

I get the following warning:

   LD      vmlinux
   SYSMAP  System.map
   SYSMAP  .tmp_System.map
   MODPOST vmlinux
WARNING: kernel/built-in.o(.text+0x19152): Section mismatch: reference 
to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
   AS      arch/i386/boot/bootsect.o
   LD      arch/i386/boot/bootsect
   AS      arch/i386/boot/setup.o
   LD      arch/i386/boot/setup
   AS      arch/i386/boot/compressed/head.o
   CC      arch/i386/boot/compressed/misc.o
   OBJCOPY arch/i386/boot/compressed/vmlinux.bin
   GZIP    arch/i386/boot/compressed/vmlinux.bin.gz
   LD      arch/i386/boot/compressed/piggy.o
   LD      arch/i386/boot/compressed/vmlinux
   OBJCOPY arch/i386/boot/vmlinux.bin
   HOSTCC  arch/i386/boot/tools/build
   BUILD   arch/i386/boot/bzImage
Root device is (3, 1)
Boot sector 512 bytes.
Setup is 7082 bytes.
System is 1142 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)
   Building modules, stage 2.
   MODPOST 0 modules


I also get the following warnings (which seem less severe)

   CC      drivers/pci/pci.o
   CC      drivers/pci/quirks.o
   CC      drivers/pci/pci-driver.o
   CC      drivers/pci/search.o
drivers/pci/search.c: In function `pci_find_slot':
drivers/pci/search.c:99: warning: `pci_find_device' is deprecated 
(declared at include/linux/pci.h:477)
drivers/pci/search.c: At top level:
drivers/pci/search.c:434: warning: `pci_find_device' is deprecated 
(declared at drivers/pci/search.c:241)
drivers/pci/search.c:434: warning: `pci_find_device' is deprecated 
(declared at drivers/pci/search.c:241)
   CC      drivers/pci/pci-sysfs.o
   CC      drivers/pci/rom.o


Finally, I note that X86_CMPXCHG64 is no longer defined since its 
specification was changed between 2.6.20 and 2.6.22.

  config X86_CMPXCHG64
     bool
-   depends on !M386 && !M486
+   depends on X86_PAE
     default y

Will this have an impact on spinlocks? RCU? something else?

Regards.
