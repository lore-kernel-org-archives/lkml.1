Return-Path: <linux-kernel-owner+w=401wt.eu-S1758514AbYAFWT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514AbYAFWT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYAFWTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:19:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748AbYAFWTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:19:48 -0500
Date: Sun, 6 Jan 2008 14:19:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc7
Message-ID: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's been two weeks since rc6, but let's face it, with xmas and new years 
(and birthdays) in between, there hasn't actually been a lot of working 
days, and the incremental patch from -rc6 is about half the size of the 
one from rc5->rc6.

And I'll be charitable and claim it's because it's all stabilizing, and 
not because we've all been in a drunken stupor over the holidays.

The shortlog (appended below) is short and fairly informative. It's all 
really just a lot of rather small changes. The diffstat shows a lot of 
one- and two-liners, with just a few drivers (and the Cell platform) 
getting a bit more attention, and the SLUB support of /proc/slabinfo 
showing up as a blip.

Both git trees and tar-balls/patches pushed out, should be mirroring out 
within minutes. So there are no excuses to not try it out, and see if your 
favorite regression has been fixed.

		Linus

---
Akos Maroy (1):
      fix: using joysticks in 32 bit applications on 64 bit systems

Al Viro (20):
      [TG3]: Endianness annotations.
      [TG3]: Endianness bugfix.
      typhoon: endianness bug in tx/rx byte counters
      typhoon: missing le32_to_cpu() in get_drvinfo
      typhoon: set_settings broken on big-endian
      typhoon: missed rx overruns on big-endian
      typhoon: memory corruptor on big-endian if TSO is enabled
      typhoon: trivial endianness annotations
      cycx: annotations and fixes (.24 fodder?)
      asix fixes
      yellowfin: annotations and fixes (.24 fodder?)
      dl2k endianness fixes (.24 fodder?)
      r8169 endianness
      rrunner: use offsetof() instead of homegrown insanity
      3c574 and 3c589 endianness fixes (.24?)
      fec_mpc52xx: write in C...
      3c359 endianness annotations and fixes
      uml: user of helper_wait() got missed when it got extra arguments
      restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid
      [CASSINI]: Fix endianness bug.

Bartlomiej Zolnierkiewicz (10):
      ide-cd: fix SAMSUNG CD-ROM SCR-3231 quirk
      ide-cd: fix ACER/AOpen 24X CDROM speed reporting on big-endian machines
      ide-cd: use ide_cd_release() in ide_cd_probe()
      ide-cd: fix error messages in cdrom_{read,write}_check_ireason()
      ide-cd: add missing 'ireason' masking to cdrom_write_intr()
      ide-cd: fix error messages in cdrom_write_intr()
      ide-cd: add error message for DMA error to cdrom_read_intr()
      ide-cd: fix error message in cdrom_pc_intr()
      ide-cd: fix 'ireason' reporting in cdrom_pc_intr()
      cmd64x: fix hwif->chipset setup

Bob Nelson (1):
      [POWERPC] Oprofile: Remove dependency on spufs module

Borislav Petkov (1):
      MAINTAINERS: update ide-cd entry

Christoph Lameter (3):
      SLUB: Improve hackbench speed
      quicklists: do not release off node pages early
      Revert quicklist need->flush fix

Cory T. Tusar (1):
      tty: fix logic change introduced by wait_event_interruptible_timeout()

Cyrill Gorcunov (1):
      NET: mac80211: fix inappropriate memory freeing

Daniel Walker (1):
      ps3: vuart: fix error path locking

Dave Dillow (1):
      [SCSI] SRP transport: only remove our own entries

Dave Young (1):
      [BLUETOOTH]: put_device before device_del fix

David Brownell (1):
      pcmcia: remove pxa2xx_lubbock build warning

David Dillow (1):
      IB/srp: Fix list corruption/oops on module reload

David S. Miller (9):
      [NET]: Correct two mistaken skb_reset_mac_header() conversions.
      [SPARC64]: Fix OOPS in dma_sync_*_for_device()
      [SPARC64]: Implement pci_resource_to_user()
      [SERIAL]: Fix section mismatches in Sun serial console drivers.
      [CASSINI]: Revert 'dont touch page_count'.
      [CASSINI]: Program parent Intel31154 bridge when necessary.
      [CASSINI]: Set skb->truesize properly on receive packets.
      [CASSINI]: Fix two obvious NAPI bugs.
      [CASSINI]: Bump driver version and release date.

Denis V. Lunev (1):
      [IPV4]: OOPS with NETLINK_FIB_LOOKUP netlink socket

Eric Dumazet (1):
      [XFRM]: Do not define km_migrate() if !CONFIG_XFRM_MIGRATE

Eric Sandeen (3):
      ecryptfs: fix string overflow on long cipher names
      ecryptfs: fix unlocking in error paths
      ecryptfs: redo dget,mntget on dentry_open failure

Gavin McCullagh (1):
      [TCP]: use non-delayed ACK for congestion control RTT

Geoff Levand (1):
      [POWERPC] PS3: Fix printing of os-area magic numbers

Greg Kroah-Hartman (1):
      Modules: fix memory leak of module names

Gregory CLEMENT (1):
      MACB: clear transmit buffers properly on transmit underrun

Hans Verkuil (1):
      V4L/DVB (6876): ivtv: mspx4xx needs a longer i2c udelay

Hans-Jürgen Koch (1):
      UIO: Add a MAINTAINERS entry for Userspace I/O

Herbert Xu (2):
      [IPSEC]: Avoid undefined shift operation when testing algorithm ID
      [CRYPTO] padlock: Fix spurious ECB page fault

Ingo Molnar (4):
      sched: fix gcc warnings
      scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
      hda_intel suspend latency: shorten codec read
      CPU hotplug: fix cpu_is_offline() on !CONFIG_HOTPLUG_CPU

James Bottomley (1):
      [SCSI] scsi_sysfs: restore prep_fn when ULD is removed

James Morris (1):
      NFS: add newline to kernel warning message in auth_gss code

Jan Kara (2):
      Fix computation of SKB size for quota messages
      Don't send quota messages repeatedly when hardlimit reached

Jean Delvare (1):
      hwmon: (w83627ehf) Be more careful when changing VID input level

Joe Perches (15):
      [SPARC64]: Spelling fixes
      [SPARC32]: Spelling fixes
      [NET] include/net/: Spelling fixes
      [DCCP]: Spelling fixes
      [IRDA]: Spelling fixes
      [IPV6]: Spelling fixes
      [NET] net/core/: Spelling fixes
      [PKT_SCHED]: Spelling fixes
      [NETLABEL]: Spelling fixes
      [SCTP]: Spelling fixes
      [NETFILTER]: Spelling fixes
      [NETFILTER] ipv4: Spelling fixes
      [ATM]: Spelling fixes
      MAINTAINERS: mailing list archives are web links
      drivers/ide/: Spelling fixes

Johannes Berg (3):
      mac80211: fix header ops
      mac80211: round station cleanup timer
      mac80211: warn when receiving frames with unaligned data

Julia Lawall (1):
      [X25]: Add missing x25_neigh_put

Kevin R Page (1):
      USB: VID/PID update for sierra

Li Zefan (1):
      [CONNECTOR]: Return proper error code in cn_call_callback()

Linus Torvalds (6):
      Revert "x86: fix show cpuinfo cpu number always zero"
      [PCI] Do not enable CRS Software Visibility by default
      Unify /proc/slabinfo configuration
      Fix kernel/ptrace.c compile problem (missing "may_attach()")
      Revert "scsi: revert "[SCSI] Get rid of scsi_cmnd->done""
      Linux 2.6.24-rc7

Mark McLoughlin (1):
      [INET]: Fix netdev renaming and inet address labels

Mark Ryden (1):
      [IPV4] ARP: Remove not used code

Martin Kusserow (1):
      USB: New device ID for the CP2101 driver

Matthias Goebl (2):
      [ISDN] i4l: 'NO CARRIER' message lost after ldisc flush
      [ISDN]: i4l: Fix DLE handling for i4l-audio

Matthias Mueller (1):
      rtl8187: Add USB ID for Sitecom WL-168 v1 001

Michael Krufky (1):
      V4L/DVB (6871): Kconfig: VIDEO_CX23885 must select DVB_LGDT330X

Michael Wu (2):
      mac80211: Drop out of associated state if link is lost
      p54: add Kconfig description

Mike Frysinger (2):
      x86: fix asm-x86/byteorder.h for userspace export
      x86: fix asm-x86/msr.h for user-space export

Patrick McHardy (1):
      [NETFILTER]: nf_conntrack_ipv4: fix module parameter compatibility

Paul Mackerras (1):
      [POWERPC] Fix build failure on Cell when CONFIG_SPU_FS=y

Paul Moore (1):
      [XFRM]: Audit function arguments misordered

Paul Mundt (1):
      kconfig: obey KCONFIG_ALLCONFIG choices with randconfig.

Pekka Enberg (1):
      slub: register slabinfo to procfs

Pekka J Enberg (1):
      slub: provide /proc/slabinfo

Peter Korsgaard (1):
      USB: Unbreak fsl_usb2_udc

Peter Zijlstra (1):
      lib: proportion: fix underflow in prop_norm_percpu()

Reinette Chatre (1):
      ipw2200: prevent alloc of unspecified size on stack

Richard Purdie (2):
      leds: Fix leds_list_lock locking issues
      leds: Fix locomo LED driver oops

Russ Anderson (2):
      [IA64] Update Altix BTE error return status patch
      [IA64] Update Altix nofault code

Rusty Russell (1):
      fix lguest rmmod "bad pgd"

Samuel Thibault (1):
      Console is utf-8 by default

Simon Horman (2):
      [IPV4]: Fix ip command line processing.
      [IPV4] Fix ip=dhcp regression

Stephen Hemminger (2):
      [NET] tc_nat: header install
      [VETH]: move veth.h to include/linux

Timo Teras (1):
      [IPV4] ip_gre: set mac_header correctly in receive path

Toyo Abe (1):
      [TUNTAP]: Fix wrong debug message.

Trond Myklebust (4):
      NFS: Fix a possible Oops in fs/nfs/super.c
      NFSv4: Fix circular locking dependency in nfs4_kill_renewd
      NFSv4: nfs4_open_confirm must not set the open_owner as confirmed on error
      NFSv4: Fix open_to_lock_owner sequenceid allocation...

Wei Yongjun (1):
      [NET]: Fix function put_cmsg() which may cause usr application memory overflow

Zhu Yi (1):
      iwlwifi: fix possible priv->mutex deadlock during suspend
