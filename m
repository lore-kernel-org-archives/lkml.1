Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZIXJBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZIXJBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 05:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbZIXJBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 05:01:00 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:6648 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZIXJA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 05:00:59 -0400
Message-ID: <4ABB3521.9060308@monstr.eu>
Date: Thu, 24 Sep 2009 11:00:17 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, John Williams <john.williams@petalogix.com>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.32
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes for arch/microblaze.

I added there four Kconfig changes in driver folder to enable Microblaze +
I correct one typo fault gcov.txt.

I hope that is no problem to add these changes through my tree.

Thanks,
Michal


The following changes since commit ebc79c4f8da0f92efa968e0328f32334a2ce80cf:
   Linus Torvalds (1):
         Merge git://git.kernel.org/.../jaswinder/linux-2.6

are available in the git repository at:

   git://git.monstr.eu/linux-2.6-microblaze.git for-linus

John Williams (7):
       mtd: Enable Open Firmware initialisation of MTD devices and maps 
for MicroBlaze
       microblaze: Use correct kbuild variable KBUILD_CFLAGS
       microblaze: Ensure CPU usermode is set on new userspace processes
       microblaze: Clear sticky FSR register after generating exception 
signals
       microblaze: Updated CPU version and FPGA family codes in PVR
       microblaze: Copy ppc asm-compat.h for clean handling of constants 
in asm and C
       microblaze: Create the LOAD_OFFSET macro used to compute VMA vs 
LMA offsets

Julie Zhu (1):
       microblaze: Add architectural support for USB EHCI host controllers

Lennart Sorensen (1):
       microblaze: Actually show KiB rather than pages in "Freeing 
initrd memory:"

Michal Simek (14):
       gcov: Fix DEBUG_FS symbol
       microblaze: Enable GCOV_PROFILE_ALL
       microblaze: Add checking mechanism for MSR instruction
       microblaze: Improve checking mechanism for MSR instruction
       microblaze: Implement include/asm/syscall.h.
       microblaze: Save and restore msr in hw exception
       microblaze: Remove ipc.h file which points to non-existing 
asm-generic file
       microblaze: Don't be noisy when userspace causes hardware exceptions
       microblaze: Generate correct signal and siginfo for integer 
div-by-zero
       microblaze: Support ptrace syscall tracing.
       microblaze: Use LOAD_OFFSET macro to get correct LMA for all sections
       microblaze: Fix _start symbol to physical address
       microblaze: Support simpleImage.dts make target
       microblaze: Disable heartbeat/enable emaclite in defconfigs

Tim Abbott (1):
       microblaze: Cleanup linker script using new linker script macros.

  Documentation/gcov.txt                        |    2 +-
  arch/microblaze/Kconfig                       |    1 +
  arch/microblaze/Makefile                      |   31 ++++++--
  arch/microblaze/boot/Makefile                 |   41 ++++++++++-
  arch/microblaze/boot/dts/system.dts           |    1 +
  arch/microblaze/boot/linked_dtb.S             |    3 +
  arch/microblaze/configs/mmu_defconfig         |   30 ++++---
  arch/microblaze/configs/nommu_defconfig       |   35 +++++----
  arch/microblaze/include/asm/asm-compat.h      |   17 ++++
  arch/microblaze/include/asm/io.h              |    3 +
  arch/microblaze/include/asm/ipc.h             |    1 -
  arch/microblaze/include/asm/page.h            |    3 +
  arch/microblaze/include/asm/setup.h           |    2 +-
  arch/microblaze/include/asm/syscall.h         |   99 
+++++++++++++++++++++++++
  arch/microblaze/kernel/cpu/cpuinfo.c          |    3 +
  arch/microblaze/kernel/entry.S                |   72 +++++++++++++++---
  arch/microblaze/kernel/exceptions.c           |   33 +++++---
  arch/microblaze/kernel/head.S                 |   14 +++-
  arch/microblaze/kernel/hw_exception_handler.S |   10 ++-
  arch/microblaze/kernel/process.c              |    1 +
  arch/microblaze/kernel/ptrace.c               |   62 +++++++++++++++
  arch/microblaze/kernel/setup.c                |   12 +++-
  arch/microblaze/kernel/vmlinux.lds.S          |   72 +++++++-----------
  arch/microblaze/mm/init.c                     |    3 +-
  drivers/mtd/Kconfig                           |    2 +-
  drivers/mtd/maps/Kconfig                      |    2 +-
  drivers/usb/Kconfig                           |    1 -
  kernel/gcov/Kconfig                           |    2 +-
  28 files changed, 440 insertions(+), 118 deletions(-)
  create mode 120000 arch/microblaze/boot/dts/system.dts
  create mode 100644 arch/microblaze/boot/linked_dtb.S
  create mode 100644 arch/microblaze/include/asm/asm-compat.h
  delete mode 100644 arch/microblaze/include/asm/ipc.h
  create mode 100644 arch/microblaze/include/asm/syscall.h
