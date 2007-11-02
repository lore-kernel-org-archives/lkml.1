Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXKBQDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXKBQDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 12:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbXKBQDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 12:03:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40670 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbXKBQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 12:03:38 -0400
Date: Fri, 2 Nov 2007 09:02:50 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.11
Message-ID: <20071102160250.GA19551@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.11 kernel.
It fixes a number of reported bugs, and any user of the 2.6.22 series is
encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.22.10 and 2.6.22.11

Based on the responses of the last patch review cycle, we've received a
number of other patches that should be added to the 2.6.22.y tree, so
there will be one more release in this series.

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                |    2 
 arch/powerpc/math-emu/math.c            |   13 +++--
 arch/sparc64/kernel/sys_sparc.c         |   15 +-----
 drivers/acpi/processor_core.c           |    2 
 drivers/acpi/processor_idle.c           |   19 +++++++
 drivers/char/drm/i915_irq.c             |    2 
 drivers/char/random.c                   |   10 ++--
 drivers/firewire/fw-card.c              |    6 +-
 drivers/hwmon/lm87.c                    |    4 -
 drivers/hwmon/w83627hf.c                |   78 ++++++++++++++++++--------------
 drivers/media/video/ivtv/ivtv-fileops.c |    2 
 drivers/net/natsemi.c                   |    2 
 drivers/net/usb/dm9601.c                |    2 
 drivers/net/wireless/libertas/11d.c     |    2 
 drivers/net/wireless/libertas/cmd.c     |    6 --
 drivers/net/wireless/libertas/wext.c    |    8 +--
 drivers/scsi/esp_scsi.c                 |    3 -
 include/acpi/processor.h                |    2 
 include/net/rose.h                      |    2 
 include/net/tcp.h                       |    6 --
 kernel/lockdep.c                        |    2 
 net/ieee80211/ieee80211_rx.c            |    6 ++
 net/ipv4/tcp_input.c                    |    3 +
 net/ipv4/tcp_ipv4.c                     |   19 +++----
 net/ipv6/addrconf.c                     |   13 ++++-
 net/ipv6/ndisc.c                        |    9 ++-
 net/ipv6/tcp_ipv6.c                     |   18 +++----
 net/mac80211/ieee80211.c                |    8 ++-
 net/rose/rose_loopback.c                |    4 -
 net/rose/rose_route.c                   |   15 ++++--
 net/sched/cls_u32.c                     |    2 
 net/socket.c                            |    3 -
 32 files changed, 170 insertions(+), 118 deletions(-)

Summary of changes from v2.6.22.10 to v2.6.22.11
================================================

Al Viro (2):
      libertas: fix endianness breakage
      libertas: more endianness breakage

Alexey Dobriyan (1):
      Fix ROSE module unload oops.

Andy Green (1):
      Add get_unaligned to ieee80211_get_radiotap_len

Brian Haley (1):
      Fix ipv6 redirect processing, leads to TAHI failures.

Dave Airlie (1):
      i915: fix vbl swap allocation size.

David Miller (2):
      Fix ESP host instance numbering.
      Fix TCP MD5 on big-endian.

David S. Miller (2):
      Fix zero length socket write() semantics.
      Fix sys_ipc() SEMCTL on sparc64.

Eric Dumazet (1):
      Fix TCP initial sequence number selection.

Greg Kroah-Hartman (1):
      Linux 2.6.22.11

Gregory Haskins (1):
      lockdep: fix mismatched lockdep_depth/curr_chain_hash

Ian Armstrong (1):
      V4L: ivtv: fix udma yuv bug

Ilpo Järvinen (1):
      Fix TCP's ->fastpath_cnt_hit handling.

Jean Delvare (4):
      hwmon/lm87: Fix a division by zero
      hwmon/lm87: Disable VID when it should be
      hwmon/w83627hf: Fix setting fan min right after driver load
      hwmon/w83627hf: Don't assume bank 0

Jeff Garzik (1):
      netdrvr: natsemi: Fix device removal bug

John W. Linville (2):
      Fix ieee80211 handling of bogus hdrlength field
      mac80211: filter locally-originated multicast frames

Kumar Gala (1):
      POWERPC: Fix handling of stfiwx math emulation

Mitsuru Chinen (1):
      Fix some cases of missed IPV6 DAD

Peter Korsgaard (1):
      dm9601: Fix receive MTU

Stefan Richter (1):
      firewire: fix unloading of fw-ohci while devices are attached

Stephen Hemminger (1):
      Fix cls_u32 error return handling.

Thomas Gleixner (1):
      ACPI: disable lower idle C-states across suspend/resume

