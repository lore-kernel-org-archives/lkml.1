Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbYFUFrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbYFUFrC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 01:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbYFUFqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 01:46:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48712
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbYFUFqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 01:46:50 -0400
Date: Fri, 20 Jun 2008 22:46:49 -0700 (PDT)
Message-Id: <20080620.224649.260163965.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several small fixes:

1) SCTP length overflow fix.

2) Dying network namespaces can be processed erroneously by
   input packets, fix from Eric W. Biederman.

3) Prevent and warn about dead loops in mac80211 layer, from
   Johannes Berg.

4) IPV6 socket option handling fix from Shan Wei.

5) pppoe build warning fix from Stephen Hemminger

6) Conformance tests show that ipv6 erroneously accepts external
   packets with a source loopback address.  Reported by Karsten
   Keil and final fix by YOSHIFUJI Hideaki.

Please pull, thanks a lot!

The following changes since commit 6d1a3fb567a728d31474636e167c324702a0c38b:
  Patrick McHardy (1):
        netlink: genl: fix circular locking

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David S. Miller (1):
      sctp: Make sure N * sizeof(union sctp_addr) does not overflow.

Eric W. Biederman (1):
      netns: Don't receive new packets in a dead network namespace.

Johannes Berg (1):
      mac80211: detect driver tx bugs

Shan Wei (1):
      ipv6: Remove options header when setsockopt's optlen is 0

Stephen Hemminger (1):
      pppoe: warning fix

YOSHIFUJI Hideaki (1):
      ipv6: Drop packets for loopback address from outside of the box.

 drivers/net/pppoe.c         |    2 +-
 include/net/ipv6.h          |    6 ++++++
 include/net/net_namespace.h |   11 +++++++++++
 net/core/dev.c              |    4 ++++
 net/core/net_namespace.c    |    3 +++
 net/ipv6/ip6_input.c        |    9 +++++++++
 net/ipv6/ipv6_sockglue.c    |   11 +++++++----
 net/mac80211/tx.c           |    9 ++++++++-
 net/sctp/socket.c           |    4 +++-
 9 files changed, 52 insertions(+), 7 deletions(-)
