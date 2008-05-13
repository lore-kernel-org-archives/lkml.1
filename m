Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbYEMUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbYEMUMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYEMUMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:12:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:37098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584AbYEMUMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:12:08 -0400
Date: Tue, 13 May 2008 13:10:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 00/37] 2.6.25.4 -stable review
Message-ID: <20080513201053.GA31167@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.25.4 release.
There are 37 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by May 15, 20:00:00 UTC.  Anything received
after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.25.4-rc1.gz
and the diffstat can be found below.


thanks,

the -stable release team


 Makefile                                       |    2 
 arch/sparc/kernel/entry.S                      |    2 
 arch/sparc/kernel/process.c                    |   25 +-
 arch/sparc/kernel/ptrace.c                     |    6 
 arch/sparc/kernel/rtrap.S                      |   11 -
 arch/sparc/kernel/signal.c                     |   84 ++++----
 arch/sparc/kernel/sys_sparc.c                  |   48 ----
 arch/sparc64/kernel/etrap.S                    |    7 
 arch/sparc64/kernel/irq.c                      |    3 
 arch/sparc64/kernel/pci.c                      |  130 +++---------
 arch/sparc64/kernel/pci_common.c               |    6 
 arch/sparc64/kernel/pci_impl.h                 |    9 
 arch/sparc64/kernel/process.c                  |   18 +
 arch/sparc64/kernel/ptrace.c                   |   16 +
 arch/sparc64/kernel/rtrap.S                    |    1 
 arch/sparc64/kernel/signal.c                   |   88 ++++----
 arch/sparc64/kernel/signal32.c                 |   48 +++-
 arch/sparc64/kernel/sys_sparc.c                |   40 ---
 arch/sparc64/kernel/sys_sparc32.c              |   33 ---
 arch/x86/Kconfig                               |   12 +
 drivers/ata/ata_piix.c                         |   25 ++
 drivers/char/vt.c                              |    6 
 drivers/i2c/busses/i2c-piix4.c                 |   32 ++-
 drivers/md/raid5.c                             |   25 +-
 drivers/media/dvb/dvb-usb/dib0700_devices.c    |  259 ++++++++++++++++++++++---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h        |    9 
 drivers/net/macvlan.c                          |    2 
 drivers/net/r8169.c                            |    8 
 drivers/rtc/rtc-lib.c                          |    2 
 drivers/scsi/aha152x.c                         |    8 
 drivers/scsi/libiscsi.c                        |   29 +-
 drivers/scsi/qla1280.c                         |    4 
 drivers/serial/serial_core.c                   |    3 
 drivers/serial/sunhv.c                         |    2 
 drivers/serial/sunsab.c                        |    2 
 drivers/serial/sunsu.c                         |    2 
 drivers/serial/sunzilog.c                      |   32 +--
 drivers/usb/host/ohci-at91.c                   |    1 
 drivers/usb/host/ohci-ep93xx.c                 |    2 
 drivers/usb/host/ohci-hub.c                    |   43 ++++
 drivers/usb/host/ohci-omap.c                   |    2 
 drivers/usb/host/ohci-pci.c                    |   43 ----
 drivers/usb/host/ohci-pxa27x.c                 |    3 
 drivers/usb/host/ohci-sm501.c                  |    2 
 drivers/usb/host/ohci-ssb.c                    |    1 
 drivers/usb/serial/airprime.c                  |    2 
 include/asm-sparc/mman.h                       |    5 
 include/asm-sparc/psr.h                        |    1 
 include/asm-sparc/ptrace.h                     |   13 +
 include/asm-sparc/signal.h                     |    8 
 include/asm-sparc64/mman.h                     |    5 
 include/asm-sparc64/psrcompat.h                |    2 
 include/asm-sparc64/pstate.h                   |    1 
 include/asm-sparc64/ptrace.h                   |   13 +
 include/asm-sparc64/signal.h                   |    8 
 include/asm-sparc64/ttable.h                   |    7 
 include/asm-x86/topology.h                     |   18 -
 include/net/ip_vs.h                            |    3 
 include/net/netfilter/nf_conntrack_tuple.h     |   10 
 net/can/af_can.c                               |   16 +
 net/dccp/feat.c                                |    2 
 net/ipv4/ipvs/ip_vs_proto.c                    |    2 
 net/ipv4/ipvs/ip_vs_proto_ah.c                 |    1 
 net/ipv4/ipvs/ip_vs_proto_esp.c                |    1 
 net/ipv4/ipvs/ip_vs_proto_tcp.c                |    1 
 net/ipv4/ipvs/ip_vs_proto_udp.c                |    1 
 net/ipv4/ipvs/ip_vs_sync.c                     |   80 +++++--
 net/ipv4/netfilter/ip_queue.c                  |    5 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv6/netfilter/ip6_queue.c                 |    5 
 net/netfilter/nf_conntrack_core.c              |    4 
 net/netfilter/nfnetlink_queue.c                |    5 
 net/sched/sch_htb.c                            |    8 
 net/xfrm/xfrm_state.c                          |    2 
 74 files changed, 808 insertions(+), 559 deletions(-)
