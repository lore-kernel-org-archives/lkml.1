Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbZJLXTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbZJLXTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933216AbZJLXTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:19:35 -0400
Received: from kroah.org ([198.145.64.141]:35902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbZJLXTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:19:34 -0400
Date: Mon, 12 Oct 2009 16:15:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.4
Message-ID: <20091012231506.GA23794@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.4 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.31.3 and 2.6.31.4

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/networking/timestamping/timestamping.c |    2 
 Makefile                                             |    2 
 arch/x86/ia32/ia32entry.S                            |   36 ++++++---
 arch/x86/include/asm/checksum_32.h                   |    3 
 arch/x86/kernel/acpi/cstate.c                        |    2 
 arch/x86/kernel/i8253.c                              |   27 +++++--
 arch/x86/kvm/lapic.c                                 |    2 
 arch/x86/kvm/svm.c                                   |   25 +++++-
 arch/x86/kvm/vmx.c                                   |    2 
 arch/x86/kvm/x86.c                                   |    2 
 drivers/acpi/osl.c                                   |    8 +-
 drivers/ata/libata-eh.c                              |   50 ++++++++-----
 drivers/char/tty_ldisc.c                             |    7 -
 drivers/ide/sis5513.c                                |   10 +-
 drivers/net/appletalk/ipddp.c                        |    3 
 drivers/net/iseries_veth.c                           |    2 
 drivers/net/sky2.c                                   |    4 -
 drivers/net/tun.c                                    |    4 -
 drivers/net/usb/smsc95xx.c                           |    2 
 drivers/net/usb/usbnet.c                             |    2 
 fs/ecryptfs/main.c                                   |    7 +
 fs/namei.c                                           |    6 +
 include/linux/ftrace.h                               |    2 
 include/linux/usb/usbnet.h                           |    1 
 kernel/exit.c                                        |    2 
 kernel/fork.c                                        |   10 ++
 kernel/futex.c                                       |    3 
 kernel/time/tick-sched.c                             |    9 +-
 kernel/trace/ftrace.c                                |   23 +-----
 mm/swap_state.c                                      |   70 ++++++++++++-------
 net/appletalk/aarp.c                                 |   16 ++--
 net/appletalk/ddp.c                                  |   58 ++++++++-------
 net/ax25/af_ax25.c                                   |    6 -
 net/core/dev.c                                       |    6 -
 net/core/sock.c                                      |   19 +++--
 net/ipv4/tcp_minisocks.c                             |    2 
 net/ipv6/sit.c                                       |    2 
 net/unix/af_unix.c                                   |    5 +
 sound/pci/hda/patch_realtek.c                        |    1 
 sound/pci/via82xx.c                                  |   27 ++++---
 sound/soc/codecs/wm8350.c                            |    4 -
 41 files changed, 294 insertions(+), 180 deletions(-)

Arnaldo Carvalho de Melo (1):
      appletalk: Fix skb leak when ipddp interface is not loaded

Aurelien Jarno (1):
      KVM: fix LAPIC timer period overflow

Avi Kivity (1):
      KVM: Prevent overflow in KVM_GET_SUPPORTED_CPUID

Bartlomiej Zolnierkiewicz (1):
      sis5513: fix PIO setup for ATAPI devices

Clemens Ladisch (1):
      sound: via82xx: move DXS volume controls to PCM interface

Daisuke Nishimura (1):
      mm: add_to_swap_cache() must not sleep

Darren Hart (1):
      futex: fix requeue_pi key imbalance

Eero Nurkkala (1):
      NOHZ: update idle state also when NOHZ is inactive

Eric Dumazet (3):
      net: restore tx timestamping for accelerated vlans
      net: Fix sock_wfree() race
      ax25: Fix SIOCAX25GETINFO ioctl

Greg Kroah-Hartman (1):
      Linux 2.6.31.4

Jan Beulich (1):
      x86: Don't leak 64-bit kernel register values to 32-bit processes

Jarek Poplawski (1):
      ax25: Fix possible oops in ax25_make_new

Jean Delvare (2):
      net: Fix wrong sizeof
      ACPI: Clarify resource conflict message

Joerg Roedel (2):
      KVM: SVM: Fix tsc offset adjustment when running nested
      KVM: SVM: Handle tsc in svm_get_msr/svm_set_msr correctly

John Stultz (1):
      PIT fixes to unbreak suspend/resume (bug #14222)

Kusanagi Kouichi (1):
      tun: Return -EINVAL if neither IFF_TUN nor IFF_TAP is set.

Linus Torvalds (1):
      tty: Avoid dropping ldisc_mutex over hangup tty re-initialization

Manoj Iyer (1):
      ALSA: hda - Added quirk to enable sound on Toshiba NB200

Marcelo Tosatti (1):
      KVM: VMX: flush TLB with INVEPT on cpu migration

Mark Brown (1):
      ASoC: WM8350 capture PGA mutes are inverted

Mike McCormack (1):
      sky2: Set SKY2_HW_RAM_BUFFER in sky2_init

Miklos Szeredi (1):
      net: unix: fix sending fds in multiple buffers

Mimi Zohar (2):
      ima: ecryptfs fix imbalance message
      IMA: open new file for read

Peter Zijlstra (1):
      futex: Nullify robust lists after cleanup

Robert Varga (1):
      tcp: fix CONFIG_TCP_MD5SIG + CONFIG_PREEMPT timer BUG()

Samuel Thibault (1):
      x86: fix csum_ipv6_magic asm memory clobber

Sascha Hlusiak (1):
      sit: fix off-by-one in ipip6_tunnel_get_prl

Steve Glendinning (1):
      smsc95xx: fix transmission where ZLP is expected

Steven Rostedt (1):
      ftrace: check for failure for all conversions

Tejun Heo (1):
      libata: fix incorrect link online check during probe

Thomas Gleixner (2):
      futex: Move exit_pi_state() call to release_mm()
      futex: Fix locking imbalance

Zhao Yakui (1):
      ACPI: fix Compaq Evo N800c (Pentium 4m) boot hang regression

jolsa@redhat.com (1):
      tracing: correct module boundaries for ftrace_release

