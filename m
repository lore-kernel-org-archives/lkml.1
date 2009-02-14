Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZBNBBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZBNBBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZBNBBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:01:23 -0500
Received: from kroah.org ([198.145.64.141]:39338 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753010AbZBNBBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:01:22 -0500
Date: Fri, 13 Feb 2009 16:57:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/47] 2.6.27.18-stable review
Message-ID: <20090214005726.GA11282@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.18 release.
There are 47 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Tuesday Feb 17, 00:00:00@ UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.18-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h


 Makefile                                       |    2 +-
 arch/powerpc/kernel/signal_32.c                |   36 +++++-------
 arch/powerpc/kernel/signal_64.c                |   33 +++++------
 arch/powerpc/mm/fsl_booke_mmu.c                |    4 +-
 arch/powerpc/mm/pgtable_32.c                   |    4 +-
 arch/sparc64/Kconfig                           |    1 +
 arch/sparc64/kernel/sys_sparc.c                |   48 ++++++++---------
 arch/sparc64/kernel/syscalls.S                 |    2 +-
 arch/sparc64/kernel/systbls.S                  |   16 +++---
 arch/sparc64/kernel/systbls.h                  |    3 -
 arch/x86/kernel/vmi_32.c                       |   11 ++++
 arch/x86/pci/fixup.c                           |   25 +++++----
 drivers/ata/libata-eh.c                        |    5 +-
 drivers/block/nbd.c                            |    9 +++
 drivers/hid/usbhid/hid-quirks.c                |   16 ++----
 drivers/net/skfp/skfddi.c                      |    4 +-
 drivers/net/sky2.c                             |    6 +-
 drivers/net/sungem.c                           |    8 ++--
 drivers/net/tun.c                              |   10 +++-
 drivers/net/virtio_net.c                       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c        |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf.c          |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c         |    1 +
 drivers/parport/parport_serial.c               |    5 ++
 drivers/w1/slaves/w1_therm.c                   |    2 +-
 fs/compat_ioctl.c                              |    7 +++
 fs/lockd/svclock.c                             |    6 ++-
 include/linux/ata.h                            |   15 ++++--
 include/linux/syscalls.h                       |   28 +++++-----
 include/net/sctp/checksum.h                    |    2 +-
 mm/page-writeback.c                            |   18 +++++-
 net/bluetooth/hidp/core.c                      |    4 ++
 net/core/skbuff.c                              |   15 +++---
 net/core/sock.c                                |    2 +
 net/ipv4/ipconfig.c                            |    6 +-
 net/ipv4/tcp.c                                 |   12 ++++-
 net/ipv4/udp.c                                 |    7 ++-
 net/ipv6/ip6_flowlabel.c                       |    8 ++-
 net/ipv6/ip6_output.c                          |   67 ++++++++++++++++++-----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 +-
 net/mac80211/debugfs_sta.c                     |    2 +-
 net/netfilter/xt_sctp.c                        |    2 +-
 net/packet/af_packet.c                         |   17 ++++--
 net/sctp/output.c                              |    7 ++-
 net/sctp/outqueue.c                            |    3 +-
 scripts/kernel-doc                             |   39 +++++++++++++-
 sound/drivers/mtpav.c                          |    3 +-
 47 files changed, 339 insertions(+), 192 deletions(-)
