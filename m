Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYBFVGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYBFVGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 16:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbYBFVFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 16:05:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353AbYBFVFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 16:05:53 -0500
Date: Wed, 6 Feb 2008 13:03:42 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.17
Message-ID: <20080206210342.GA4742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.17
kernel.

It contains a number of bugfixes, and all users of the 2.6.22 series are
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.16 and 2.6.22.17

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                           |    2 
 arch/powerpc/mm/hash_utils_64.c    |    2 
 arch/sparc64/kernel/chmc.c         |   16 +++--
 arch/sparc64/kernel/entry.S        |   12 +++
 arch/sparc64/kernel/smp.c          |   19 ++++--
 arch/sparc64/mm/init.c             |   29 ++++++---
 drivers/acpi/dispatcher/dsobject.c |   91 ++++++++++++++++++++++++++++--
 drivers/atm/nicstar.c              |   19 ++----
 drivers/char/drm/drm_vm.c          |    2 
 drivers/char/mspec.c               |    3 
 drivers/connector/cn_queue.c       |    2 
 drivers/net/cassini.c              |   45 +++-----------
 drivers/net/cassini.h              |   18 ++---
 drivers/net/chelsio/cxgb2.c        |   66 ++++++++++++++++-----
 drivers/net/chelsio/pm3393.c       |  112 ++++++++++++++-----------------------
 drivers/net/chelsio/sge.c          |   40 +++++--------
 drivers/net/chelsio/sge.h          |    3 
 drivers/net/usb/kaweth.c           |    2 
 drivers/net/usb/mcs7830.c          |    4 -
 drivers/pci/quirks.c               |    6 +
 fs/exec.c                          |    6 +
 fs/ncpfs/mmap.c                    |    3 
 include/asm-sparc64/hypervisor.h   |    4 +
 include/linux/pci_ids.h            |    2 
 kernel/relay.c                     |    1 
 mm/mmap.c                          |    2 
 net/atm/mpc.c                      |    7 ++
 net/ax25/ax25_in.c                 |    2 
 net/ipv4/devinet.c                 |    2 
 net/ipv4/ip_gre.c                  |    2 
 net/ipv4/route.c                   |    8 +-
 net/irda/af_irda.c                 |    2 
 net/key/af_key.c                   |   14 +++-
 net/netrom/nr_dev.c                |    2 
 net/x25/x25_forward.c              |    5 -
 net/xfrm/xfrm_policy.c             |    9 +-
 sound/oss/via82cxxx_audio.c        |   14 +---
 sound/usb/usx2y/usX2Yhwdep.c       |    2 
 sound/usb/usx2y/usx2yhwdeppcm.c    |    2 
 39 files changed, 355 insertions(+), 227 deletions(-)

Summary of changes from v2.6.22.16 to v2.6.22.17
================================================

Al Viro (1):
      CASSINI: Fix endianness bug.

Bob Moore (1):
      ACPICA: fix acpi-cpufreq boot crash due to _PSD return-by-reference

Chas Williams (1):
      ATM: [nicstar] delay irq setup until card is configured

David Miller (6):
      SPARC64: Fix two kernel linear mapping setup bugs.
      SPARC64: Fix memory controller register access when non-SMP.
      NET: Correct two mistaken skb_reset_mac_header() conversions.
      Fix sparc64 cpu cross call hangs.
      CASSINI: Revert 'dont touch page_count'.
      CASSINI: Set skb->truesize properly on receive packets.

Divy Le Ray (3):
      cxgb: fix T2 GSO
      cxgb: fix stats
      chelsio: Fix skb->dev setting

Eric Dumazet (1):
      IPV4 ROUTE: ip_rt_dump() is unecessary slow

Greg Kroah-Hartman (1):
      Linux 2.6.22.17

Herbert Xu (3):
      IPSEC: Fix potential dst leak in xfrm_lookup
      IPSEC: Avoid undefined shift operation when testing algorithm ID
      ATM: Check IP header validity in mpc_send_packet

Ilpo JÃ¤rvinen (1):
      POWERPC: Fix invalid semicolon after if statement

Ingo Molnar (1):
      vfs: coredumping fix (CVE-2007-6206)

Julia Lawall (1):
      X25: Add missing x25_neigh_put

Li Zefan (1):
      CONNECTOR: Don't touch queue dev after decrement of ref count.

Mark McLoughlin (1):
      INET: Fix netdev renaming and inet address labels

Nick Piggin (1):
      vm audit: add VM_DONTEXPAND to mmap for drivers that need it (CVE-2008-0007)

Russ Dill (2):
      NET: mcs7830 passes msecs instead of jiffies to usb_control_msg
      NET: kaweth was forgotten in msec switchover of usb_start_wait_urb

Timo Teras (1):
      IPV4: ip_gre: set mac_header correctly in receive path

Zhao Yakui (1):
      ACPI: apply quirk_ich6_lpc_acpi to more ICH8 and ICH9

maximilian attems (1):
      IRDA: irda_create() nuke user triggable printk

