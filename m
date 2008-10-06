Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYJFXxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYJFXxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbYJFXwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:52:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389AbYJFXwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:52:53 -0400
Date: Mon, 6 Oct 2008 16:52:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-rc9
Message-ID: <alpine.LFD.2.00.0810061641070.3208@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I know, I know, I said that -rc8 was supposed to be the last -rc, and that 
I'd release 2.6.27 this weekend. 

I lied. Sue me. I merged two subtle regression fixes today, and while both 
looked perfectly fine and had been tested by the people involved in the 
regressions, I just couldn't bring myself to then just slap a "v2.6.27" on 
it without some more testing.

So I'd like to get at least a couple of days of feedback on those fixes. 
It also felt like a good idea to have an -rc with the patches that should 
fix the (much-publicized) e1000e firmware corruption bugs. I know people 
inside Intel are still looking at it, so there may be more changes in that 
area, but I think we're set for 2.6.27 - but again, let's just do an -rc 
here.

If things go well, I might do a final release mid-week, otherwise it's 
"next weekend" again.

The dirstat looks like the normal one: half arch code (mainly due to some 
mips updates), and 30% drivers, with a smattering of other things (eg 
sctp). But the things people would likely _care_ about are the e1000e 
patches and the HP Turion-based laptop performance regression thing and 
an GART mapping issue.

But here's the dirstat for an "overview" anyway:

  35.3% arch/mips/kernel/
   4.5% arch/mips/sibyte/swarm/
  42.5% arch/mips/
   3.7% arch/powerpc/boot/dts/
   4.4% arch/powerpc/
  52.9% arch/
  11.3% drivers/ide/mips/
  11.8% drivers/ide/
   4.9% drivers/media/video/
   6.6% drivers/media/
   3.8% drivers/net/e1000e/
  29.2% drivers/
   5.0% include/asm-mips/
   5.4% include/
   3.5% net/sctp/
   4.4% net/

and the shortlog is appended.

			Linus

PS. I already bugged people on the git lists with this, but since I'm 
totally shameless and can't help but hope that some random kernel person 
also does tcl/tk or just wants to help improve my kids-time-tracker, I can 
just point to

	http://torvalds-family.blogspot.com/2008/10/tracking-time-kids-spend-online.html

and hope that somebody would like to make that GUI better and/or feel like 
they really want to do a "management interface" too ;)

---
Andreas Oberritter (1):
      V4L/DVB (9029): Fix deadlock in demux code

Andrew Morton (2):
      include/linux/stacktrace.h: declare struct task_struct
      V4L/DVB (8960): drivers/media/video/cafe_ccic.c needs mm.h

Andy Whitcroft (1):
      mm: handle initialising compound pages at orders greater than MAX_ORDER

Arnaud Ebalard (1):
      XFRM,IPv6: initialize ip6_dst_blackhole_ops.kmem_cachep

Bartlomiej Zolnierkiewicz (1):
      ide: workaround for bogus gcc warning in ide_sysfs_register_port()

Bodo Eggert (1):
      ide-cd: Optiarc DVD RW AD-7200A does play audio

Borislav Petkov (1):
      ide-cd: temporary tray close fix

Bruce Allan (1):
      e1000e: write protect ICHx NVM to prevent malicious write/erase

Chandra Seetharaman (1):
      dm mpath: add missing path switching locking

Costantino Leandro (1):
      V4L/DVB (8933): gspca: Disable light frquency for zc3xx cs2102 Kokom.

Dan Carpenter (1):
      fix error-path NULL deref in alloc_posix_timer()

Darron Broad (1):
      V4L/DVB (9099): em28xx: Add detection for K-WORLD DVB-T 310U

David Gibson (1):
      powerpc: Fix PCI in Holly device tree

David Howells (1):
      MN10300: Fix IRQ handling

David Winn (1):
      fbcon: fix monochrome color value calculation

Dean Anderson (1):
      V4L/DVB (8963): s2255drv field count fix

Denis V. Lunev (1):
      ipv6: NULL pointer dereferrence in tcp_v6_send_ack

Devin Heitmueller (1):
      V4L/DVB (8967): Use correct XC3028L firmware for AMD ATI TV Wonder 600

Douglas Schilling Landgraf (6):
      V4L/DVB (8883): w9968cf: Fix order of usb_alloc_urb validation
      V4L/DVB (8884): em28xx-audio: fix memory leak
      V4L/DVB (8885): cpia2_usb: fix memory leak
      V4L/DVB (8886): ov511: fix memory leak
      V4L/DVB (8887): gspca: fix memory leak
      V4L/DVB (8935): em28xx-cards: Remove duplicate entry (EM2800_BOARD_KWORLD_USB2800)

Gerald Schaefer (1):
      memory hotplug: missing zone->lock in test_pages_isolated()

H. Peter Anvin (1):
      x86 setup: correct segfault in generation of 32-bit reloc kernel

Haavard Skinnemoen (2):
      dw_dmac: fix copy/paste bug in tasklet
      atmel-mci: Initialize BLKR before sending data transfer command

Hans Verkuil (4):
      V4L/DVB (8789): wm8739: remove wrong kfree
      V4L/DVB (8904): cx88: add missing unlock_kernel
      V4L/DVB (8905): ov511: fix exposure sysfs attribute bug
      V4L/DVB (8919): cx18: Fix tuner audio input for Compro H900 cards

Hans de Goede (1):
      V4L/DVB (8909): gspca: PAC 7302 webcam 093a:262a added.

Heiko Carstens (2):
      iucv: Fix mismerge again.
      [S390] nohz: Fix __udelay.

Herbert Xu (1):
      ipsec: Fix pskb_expand_head corruption in xfrm_state_check_space

J.A. Magallón (1):
      x86: fix typo in enable_mtrr_cleanup early parameter

Jan Glauber (1):
      [S390] qdio: prevent stack clobber

Jan Kiszka (1):
      kgdb, x86: Avoid invoking kgdb_nmicallback twice per NMI

Jason Wessel (1):
      kgdb: call touch_softlockup_watchdog on resume

Jean Delvare (5):
      ALSA: ASoC: Fix cs4270 error path
      V4L/DVB (8955): bttv: Prevent NULL pointer dereference in radio_open
      V4L/DVB (8957): zr36067: Restore the default pixel format
      V4L/DVB (8958): zr36067: Return proper bytes-per-line value
      V4L/DVB (8961): zr36067: Fix RGBR pixel format

Jean-Francois Moine (3):
      V4L/DVB (8926): gspca: Bad fix of leak memory (changeset 43d2ead315b1).
      V4L/DVB (9080): gspca: Add a delay after writing to the sonixj sensors.
      V4L/DVB (9092): gspca: Bad init values for sonixj ov7660.

Jesse Brandeburg (5):
      e1000e: reset swflag after resetting hardware
      e1000e: do not ever sleep in interrupt context
      e1000e: remove phy read from inside spinlock
      e1000e: drop stats lock
      e1000e: update version from k4 to k6

Johannes Berg (1):
      powerpc: Fix failure to shutdown with CPU hotplug

Kevin D. Kissell (3):
      [MIPS] SMTC: Fix holes in SMTC and FPU affinity support.
      [MIPS] SMTC: Close tiny holes in the SMTC IPI replay system.
      [MIPS] SMTC: Fix SMTC dyntick support.

Krzysztof Helt (1):
      fbdev: fix recursive notifier and locking when fbdev console is blanked

Kumar Gala (1):
      powerpc: Fix boot hang regression on MPC8544DS

Lennert Buytenhek (1):
      orion_spi: fix handling of default transfer speed

Linus Torvalds (4):
      Check mapped ranges on sysfs resource files
      e1000e: Fix incorrect debug warning
      Fix init/main.c to use regular printk with '%pF' for initcall fn
      Linux 2.6.27-rc9

Marcin Slusarz (1):
      rtc: fix kernel panic on second use of SIGIO nofitication

Mathieu Desnoyers (1):
      Marker depmod fix core kernel list

Mauro Carvalho Chehab (1):
      V4L/DVB (8559a): Fix a merge conflict at gspca/sonixb

Michael Kerrisk (3):
      MAINTAINERS: add mailing list for man-pages
      SubmitChecklist: interfaces changes should CC linux-api@
      Documentation/HOWTO: info about interface changes should CC linux-api@vger

Michael Krufky (2):
      V4L/DVB (8978): sms1xxx: fix product name for Hauppauge WinTV MiniStick
      V4L/DVB (8979): sms1xxx: Add new USB product ID for Hauppauge WinTV MiniStick

Mike Isely (1):
      V4L/DVB (8892): pvrusb2: Handle USB ID 2040:2950 same as 2040:2900

Mike Rapoport (1):
      pxa2xx_spi: fix build breakage

Mikulas Patocka (2):
      dm: always allow one page in dm_merge_bvec
      dm: cope with access beyond end of device in dm_merge_bvec

Nick Piggin (2):
      inotify: fix lock ordering wrt do_page_fault's mmap_sem
      mm: tiny-shmem nommu fix

Pascal Terjan (1):
      braille_console: only register notifiers when the braille console is used

Patrick Boettcher (2):
      V4L/DVB (9037): Fix support for Hauppauge Nova-S SE
      V4L/DVB (9043): S5H1420: Fix size of shadow-array to avoid overflow

Paul Jackson (1):
      cpusets: remove pj from cpuset maintainers

Paul Moore (1):
      selinux: Fix an uninitialized variable BUG/panic in selinux_secattr_to_sid()

Rafael J. Wysocki (2):
      ACPI: Make /proc/acpi/wakeup interface handle PCI devices (again)
      x86 ACPI: Blacklist two HP machines with buggy BIOSes

Ralf Baechle (5):
      [MIPS] Build fix: Fix irq flags type
      [MIPS] SMTC: Build fix: Fix filename in Makefile
      IDE: Fix platform device registration in Swarm IDE driver (v2)
      [MIPS] Fix CMP Kconfig configuration and mark as broken.
      [MIPS] IP27: Fix build errors if CONFIG_MAPPED_KERNEL=y

Ralph Loader (1):
      V4L/DVB (9053): fix buffer overflow in uvc-video

Risto Suominen (2):
      ALSA: snd-powermac: mixers for PowerMac G4 AGP
      ALSA: snd-powermac: HP detection for 1st iMac G3 SL

Rob Sims (1):
      ASoC: Set correct name for WM8753 rec mixer output

Samuel Ortiz (2):
      mfd: Fix Kconfig accroding to the new gpiolib symbols
      mfd: Fix asic3 compilation

Sergei Shtylylov (1):
      ide-dma: fix ide_build_dmatable() for TRM290

Shane (1):
      V4L/DVB (9075): gspca: Bad check of returned status in i2c_read() spca561.

Sven Wegener (2):
      leds-fsg: change order of initialization and deinitialization
      leds-pca955x: add proper error handling and fix bogus memory handling

Takashi Iwai (1):
      ALSA: hda - Fix model for Dell Inspiron 1525

Thomas Gleixner (6):
      hrtimer: migrate pending list on cpu offline
      hrtimer: fix migration of CB_IRQSAFE_NO_SOFTIRQ hrtimers
      hrtimer: mark migration state
      hrtimer: prevent migration of per CPU hrtimers
      e1000e: debug contention on NVM SWFLAG
      clockevents: check broadcast tick device not the clock events device

Timo Teras (1):
      af_key: Free dumping state on socket close

Tony Luck (1):
      [IA64] Put the space for cpu0 per-cpu area into .data section

Vitaliy Gusev (1):
      tcp: Fix NULL dereference in tcp_4_send_ack()

Wei Yongjun (1):
      sctp: Fix kernel panic while process protocol violation parameter

Wiktor Grebla (1):
      V4L/DVB (9103): em28xx: HVR-900 B3C0 - fix audio clicking issue

Yinghai Lu (1):
      x86: gart iommu have direct mapping when agp is present too

Zachary Amsden (2):
      x86: Fix broken LDT access in VMI
      x86, vmi: fix broken LDT access
