Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbZBNB1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbZBNB1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763337AbZBNBP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:15:59 -0500
Received: from kroah.org ([198.145.64.141]:50096 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764088AbZBNBP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:15:58 -0500
Date: Fri, 13 Feb 2009 17:12:08 -0800
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
Subject: [patch 00/48] 2.6.28.6-stable review
Message-ID: <20090214011208.GA17706@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.28.6 release.
There are 48 patches in this series, all will be posted as a response to
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
        kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.28.6-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

 Makefile                                       |    2 +-
 arch/powerpc/mm/fsl_booke_mmu.c                |    4 +-
 arch/powerpc/mm/pgtable_32.c                   |    4 +-
 arch/sparc64/Kconfig                           |    1 +
 arch/sparc64/kernel/sys_sparc.c                |   48 ++++++++---------
 arch/sparc64/kernel/syscalls.S                 |    2 +-
 arch/sparc64/kernel/systbls.S                  |   16 +++---
 arch/sparc64/kernel/systbls.h                  |    3 -
 arch/x86/kernel/microcode_amd.c                |   23 ++------
 arch/x86/kernel/vmi_32.c                       |   11 ++++
 drivers/ata/libata-eh.c                        |    5 +-
 drivers/block/nbd.c                            |    9 +++
 drivers/hid/hid-microsoft.c                    |   13 ++---
 drivers/ide/ide-cd.c                           |    3 +
 drivers/ide/ide-io.c                           |    9 ++-
 drivers/net/skfp/skfddi.c                      |    4 +-
 drivers/net/sky2.c                             |    6 +-
 drivers/net/sungem.c                           |    8 ++--
 drivers/net/tun.c                              |   10 +++-
 drivers/net/virtio_net.c                       |    3 +-
 drivers/net/wireless/zd1211rw/zd_rf.c          |    1 +
 drivers/net/wireless/zd1211rw/zd_usb.c         |    1 +
 drivers/parport/parport_serial.c               |    5 ++
 drivers/w1/slaves/w1_therm.c                   |    2 +-
 fs/compat_ioctl.c                              |    7 +++
 fs/lockd/svclock.c                             |    6 ++-
 include/linux/Kbuild                           |    2 +-
 include/linux/ata.h                            |   15 ++++--
 include/linux/if_tunnel.h                      |    3 +
 include/linux/syscalls.h                       |   28 +++++-----
 include/net/sctp/checksum.h                    |    2 +-
 mm/mmap.c                                      |    7 ++-
 mm/page-writeback.c                            |   20 ++++++--
 net/core/skbuff.c                              |   15 +++---
 net/core/sock.c                                |    2 +
 net/ipv4/ipconfig.c                            |    6 +-
 net/ipv4/tcp.c                                 |   12 ++++-
 net/ipv4/udp.c                                 |    7 ++-
 net/ipv6/ip6_flowlabel.c                       |    8 ++-
 net/ipv6/ip6_output.c                          |   67 ++++++++++++++++++-----
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 +-
 net/mac80211/tx.c                              |    2 +
 net/netfilter/xt_sctp.c                        |    2 +-
 net/packet/af_packet.c                         |   17 ++++--
 net/sctp/output.c                              |    7 ++-
 net/sctp/outqueue.c                            |    3 +-
 scripts/kernel-doc                             |   40 ++++++++++++++-
 sound/drivers/mtpav.c                          |    3 +-
 sound/pci/hda/patch_analog.c                   |    4 +-
 49 files changed, 320 insertions(+), 162 deletions(-)
