Return-Path: <linux-kernel-owner+w=401wt.eu-S932188AbXFEJ3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbXFEJ3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbXFEJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:29:47 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:40399 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759042AbXFEJ3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:29:46 -0400
Message-ID: <46652D07.1040103@dgreaves.com>
Date: Tue, 05 Jun 2007 10:29:43 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc4
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So -rc4 is out there now, hopefully shrinking the regression list further. 
> 
> The diffstat (for those that look at those kinds of things) tells the 
> story: lots of small stuff to random files. I think the single biggest 
> file change was the patch-checking script, along with some sparc64 fixes. 
> But the bulk of it all is just a lot of small random things.
> 
> Shortlog appended to give kind of an overview, nothing really stands out 
> there. Mostly driver fixes, with some architecture updates.
> 
> I'd ask that people involved with the known regressions please test 
> whether they got fixed, and if you wrote a patch and it's still pending, 
> please make sure to push it upstream..
> 
> 		Linus

Compile warnings and a new regression: hang on boot during sata_promise
detection... :(

I have to go out now, I'll get more details on my return.

make mrproper
cp ../linux-2.6.21.1/.config .
make oldconfig (accept defaults)
make

scripts/kconfig/conf -s arch/i386/Kconfig
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol
'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol
'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
  CHK     include/linux/version.h

[And I gave my Amiga away a year ago :) ]

  CC      kernel/power/pm.o
kernel/power/pm.c:205: warning: `pm_register' is deprecated (declared at
kernel/power/pm.c:64)
kernel/power/pm.c:205: warning: `pm_register' is deprecated (declared at
kernel/power/pm.c:64)
kernel/power/pm.c:206: warning: `pm_send_all' is deprecated (declared at
kernel/power/pm.c:180)
kernel/power/pm.c:206: warning: `pm_send_all' is deprecated (declared at
kernel/power/pm.c:180)

  CC      fs/xfs/linux-2.6/xfs_lrw.o
fs/xfs/linux-2.6/xfs_lrw.c: In function `xfs_iozero':
fs/xfs/linux-2.6/xfs_lrw.c:162: warning: `memclear_highpage_flush' is deprecated
(declared at include/linux/highmem.h:115)

  CC      drivers/base/dd.o
drivers/base/dd.c:211: warning: `device_probe_drivers' defined but not used

  CC      drivers/pci/search.o
drivers/pci/search.c: In function `pci_find_slot':
drivers/pci/search.c:99: warning: `pci_find_device' is deprecated (declared at
include/linux/pci.h:477)
drivers/pci/search.c: At top level:
drivers/pci/search.c:434: warning: `pci_find_device' is deprecated (declared at
drivers/pci/search.c:241)
drivers/pci/search.c:434: warning: `pci_find_device' is deprecated (declared at
drivers/pci/search.c:241)

  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map
  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0x968f): Section mismatch: reference
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9781): Section mismatch: reference
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0x9786): Section mismatch: reference
to .init.text: (between 'mtrr_bp_init' and 'mtrr_ap_init')
WARNING: arch/i386/kernel/built-in.o(.text+0xa25c): Section mismatch: reference
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa303): Section mismatch: reference
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa31b): Section mismatch: reference
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.text+0xa344): Section mismatch: reference
to .init.text: (between 'get_mtrr_state' and 'mtrr_wrmsr')
WARNING: arch/i386/kernel/built-in.o(.exit.text+0x19): Section mismatch:
reference to .init.text: (between 'cache_remove_dev' and 'powernow_k6_exit')
WARNING: arch/i386/kernel/built-in.o(.data+0x2160): Section mismatch: reference
to .init.text: (between 'thermal_throttle_cpu_notifier' and 'mce_work')
WARNING: kernel/built-in.o(.text+0x14482): Section mismatch: reference to
.init.text: (between 'kthreadd' and 'init_waitqueue_head')


David

