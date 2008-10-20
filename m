Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbYJTKv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbYJTKv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 06:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYJTKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 06:51:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46695
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbYJTKvV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 06:51:21 -0400
Date: Mon, 20 Oct 2008 03:45:17 -0700 (PDT)
Message-Id: <20081020.034517.125315138.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes all over, highlights:

1) Netfilter build fix for the problem reported by Ben H. and Ingo.

2) sch_teql OOPS fix, will be sent to -stable as well, from Jarek Poplawski

3) Fallout from the TPROXY changes in TCP/ipv6 and DCCP, fixed by
   KOVACS Krisztian and Gerrit Renker.

4) Net device name change rollback returns the wrong error code, from
   Stephen Hemminger.

Please pull thanks a lot!

The following changes since commit 95a5afca4a8d2e1cb77e1d4bc6ff9f718dc32f7a:
  Johannes Berg (1):
        net: Remove CONFIG_KMOD from net/ (towards removing CONFIG_KMOD entirely)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexey Dobriyan (2):
      netfilter: xt_iprange: fix range inversion match
      netfilter: xt_recent: use proc_create_data()

Gerrit Renker (1):
      dccp: Port redirection support for DCCP

Ilpo Järvinen (1):
      netfilter: snmp nat leaks memory in case of failure

Jan Engelhardt (1):
      netfilter: replace old NF_ARP calls with NFPROTO_ARP

Jarek Poplawski (1):
      pkt_sched: sch_generic: Fix oops in sch_teql

Julius Volz (1):
      ipvs: Update CONFIG_IP_VS_IPV6 description and help text

KOVACS Krisztian (1):
      tcp: Fix IPv6 fallout from 'Port redirection support for TCP'

Pablo Neira Ayuso (1):
      netfilter: fix compilation error with NAT=n

Patrick McHardy (2):
      netfilter: ctnetlink: remove obsolete NAT dependency from Kconfig
      netfilter: netns: use NFPROTO_NUMPROTO instead of NUMPROTO for tables array

Stephen Hemminger (1):
      netdev: change name dropping error codes

 include/net/netns/x_tables.h           |    4 ++--
 net/bridge/br_netfilter.c              |    2 +-
 net/core/dev.c                         |    6 +++---
 net/dccp/ipv6.c                        |    4 ++--
 net/dccp/minisocks.c                   |    1 +
 net/dccp/output.c                      |    2 +-
 net/ipv4/arp.c                         |    4 ++--
 net/ipv4/netfilter/nf_nat_snmp_basic.c |    1 +
 net/ipv6/syncookies.c                  |    1 +
 net/ipv6/tcp_ipv6.c                    |    6 +++---
 net/netfilter/Kconfig                  |    1 -
 net/netfilter/ipvs/Kconfig             |    4 +++-
 net/netfilter/nf_conntrack_netlink.c   |    2 ++
 net/netfilter/xt_NFQUEUE.c             |    2 +-
 net/netfilter/xt_iprange.c             |    8 ++++----
 net/netfilter/xt_recent.c              |   10 ++++------
 net/sched/sch_generic.c                |    2 ++
 17 files changed, 33 insertions(+), 27 deletions(-)
