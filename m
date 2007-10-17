Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbXJQUHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbXJQUHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758402AbXJQUHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:07:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:36583 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbXJQUHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:07:34 -0400
Date: Wed, 17 Oct 2007 20:07:25 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Linux 2.6.20.21
Message-ID: <20071017200725.GA1681@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just released Linux 2.6.20.21.

The following security issues are solved :
  CVE-2007-3104: store sysfs inode nrs in s_ino to avoid readdir oopses
  CVE-2007-4571: Convert snd-page-alloc proc file to use seq_file

A bunch of other fixes have been applied. No known vulnerability fix is
pending anymore.

I'll also be replying to this message with a copy of the patch between
2.6.20.20 and 2.6.20.21.

I'd like to repeat what I've already said several times: 2.6.20.21 is
the last 2.6.20.x release and there are no plans for any other one.
Upgrade to this one only as a quick temporary step towards a newer
major version.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/patch-2.6.20.21.bz2
  ftp://ftp.all.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.21

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git

Willy

-------

 Makefile                             |    2 -
 arch/i386/kernel/sysenter.c          |    4 +-
 arch/powerpc/kernel/process.c        |    6 +--
 arch/sparc64/kernel/traps.c          |   18 +++++----
 arch/sparc64/mm/fault.c              |    5 --
 block/ll_rw_blk.c                    |   13 +++---
 crypto/blkcipher.c                   |   11 +++--
 drivers/acpi/events/evgpeblk.c       |    4 ++
 drivers/ieee1394/ieee1394_core.c     |    2 -
 drivers/ieee1394/ohci1394.c          |    4 --
 drivers/media/video/cx88/cx88-mpeg.c |    2 -
 drivers/media/video/pwc/pwc-if.c     |   52 ++++++++++++++++++--------
 drivers/media/video/pwc/pwc.h        |    1 
 drivers/net/forcedeth.c              |    1 
 drivers/net/r8169.c                  |   18 +++++----
 drivers/scsi/3w-9xxx.c               |   18 +++++----
 drivers/usb/core/driver.c            |    2 -
 drivers/usb/core/message.c           |    4 +-
 fs/ext3/namei.c                      |   34 +++++++++++++++--
 fs/ext4/namei.c                      |   34 +++++++++++++++--
 fs/locks.c                           |    2 -
 fs/nfs/super.c                       |    2 -
 fs/sysfs/dir.c                       |   16 +++++---
 fs/sysfs/inode.c                     |    1 
 fs/sysfs/mount.c                     |    1 
 include/asm-avr32/atomic.h           |    4 +-
 include/linux/netfilter/Kbuild       |    1 
 include/linux/sysfs.h                |    1 
 include/net/tcp.h                    |    2 -
 kernel/futex_compat.c                |    4 +-
 kernel/signal.c                      |   19 ++++-----
 kernel/sys.c                         |    3 -
 net/802/psnap.c                      |   17 ++++++--
 net/core/datagram.c                  |    3 +
 net/dccp/ccids/ccid2.c               |    2 -
 net/ipv4/af_inet.c                   |    2 -
 net/ipv4/ah4.c                       |    2 -
 net/ipv4/tcp.c                       |    3 +
 net/ipv4/tcp_ipv4.c                  |    1 
 net/ipv6/af_inet6.c                  |    2 -
 net/ipv6/ip6_output.c                |    5 +-
 net/ipv6/raw.c                       |    3 -
 net/ipv6/tcp_ipv6.c                  |    1 
 net/socket.c                         |    2 -
 sound/core/memalloc.c                |   68 ++++++++++++++++++++---------------
 45 files changed, 258 insertions(+), 144 deletions(-)

Summary of changes from 2.6.20.20 to 2.6.20.21
============================================

Adam Radford (1):
      3w-9xxx: Fix dma mask setting

Alan Stern (1):
      USB: allow retry on descriptor fetch errors

Alexey Dobriyan (1):
      nfs: fix oops re sysctls and V4 support

Arnd Bergmann (1):
      futex_compat: fix list traversal bugs

Bob Moore (1):
      ACPICA: Fixed possible corruption of global GPE list

Chuck Ebbert (1):
      Netfilter: Missing Kbuild entry for netfilter

David Miller (2):
      SPARC64: Fix sparc64 task stack traces.
      TCP: Do not autobind ports for TCP sockets

Eric Sandeen (2):
      dir_index: error out instead of BUG on corrupt dx dirs
      sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses

Francois Romieu (1):
      r8169: avoid needless NAPI poll scheduling

Gerrit Renker (1):
      DCCP: Fix DCCP GFP_KERNEL allocation in atomic context

Haavard Skinnemoen (1):
      AVR32: Fix atomic_add_unless() and atomic_sub_unless()

Herbert Xu (4):
      SNAP: Fix SNAP protocol header accesses.
      NET: Fix missing rcu unlock in __sock_create()
      crypto: blkcipher_get_spot() handling of buffer at end of page
      Fix datagram recvmsg NULL iov handling regression.

Jan Beulich (1):
      i386: allow debuggers to access the vsyscall page with compat vDSO

Jens Axboe (1):
      Fix race with shared tag queue maps

Kumar Gala (1):
      POWERPC: Flush registers to proper task context

Nathael Pajani (1):
      USB: fix linked list insertion bugfix for usb core

Nick Bowler (1):
      Fix IPSEC AH4 options handling

Oleg Nesterov (2):
      setpgid(child) fails if the child was forked by sub-thread
      sigqueue_free: fix the race with collect_signal()

Oliver Neukum (1):
      USB: fix DoS in pwc USB video driver

Pavel Emelyanov (1):
      Leases can be hidden by flocks

Stefan Richter (1):
      ieee1394: ohci1394: fix initialization if built non-modular

Steven Toth (1):
      V4L: cx88: Avoid a NULL pointer dereference during mpeg_open()

Takashi Iwai (1):
      Convert snd-page-alloc proc file to use seq_file

Willy Tarreau (2):
      fix realtek phy id in forcedeth
      Linux 2.6.20.21

YOSHIFUJI Hideaki (2):
      Fix IPV6 append OOPS.
      Fix ipv6 double-sock-release with MSG_CONFIRM

