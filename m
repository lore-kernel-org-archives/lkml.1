Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZC3AOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZC3AOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 20:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZC3AOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 20:14:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53082
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753701AbZC3AOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 20:14:01 -0400
Date: Sun, 29 Mar 2009 17:13:50 -0700 (PDT)
Message-Id: <20090329.171350.201684885.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) net_device_ops conversion and some fixups from Alexander
   Beregalov

2) netfilter build failure fix from Pedro Neira Ayuso

3) Missing kernel-doc fix from Randy Dunlap

4) Use-after-release bug fixes in gianfar and ucc_geth

5) Endianness cures and cleanups from Harvey Harrison

6) Add GRO support to two drivers.

Please pull, thanks a lot!

The following changes since commit 07d43ba98621f08e252a48c96b258b4d572b0257:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Alexander Beregalov (3):
      ni5010: convert to net_device_ops
      dmascc: fix incomplete conversion to network_device_ops
      wireless: remove duplicated .ndo_set_mac_address

David S. Miller (5):
      gianfar: Fix use-after-of_node_put() in gfar_of_init().
      ucc_geth: Fix use-after-of_node_put() in ucc_geth_probe().
      niu: Add GRO support.
      tg3: Add GRO support.
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/

Harvey Harrison (3):
      netfilter: fix endian bug in conntrack printks
      netpoll: store local and remote ip in net-endian
      kernel: remove HIPQUAD()

Herbert Xu (1):
      gso: Fix support for linear packets

Pablo Neira Ayuso (1):
      netfilter: xtables: fix IPv6 dependency in the cluster match

Randy Dunlap (1):
      skbuff.h: fix missing kernel-doc

 drivers/net/gianfar.c                     |    2 +-
 drivers/net/hamradio/dmascc.c             |    2 +-
 drivers/net/netconsole.c                  |   10 +++-----
 drivers/net/ni5010.c                      |   18 +++++++++++-----
 drivers/net/niu.c                         |   12 ++++++----
 drivers/net/tg3.c                         |    4 +-
 drivers/net/ucc_geth.c                    |   11 +++++----
 drivers/net/wireless/airo.c               |    2 -
 drivers/net/wireless/ipw2x00/ipw2200.c    |    1 -
 drivers/net/wireless/prism54/islpci_dev.c |    1 -
 drivers/net/wireless/zd1201.c             |    1 -
 include/linux/kernel.h                    |   12 -----------
 include/linux/netpoll.h                   |    2 +-
 include/linux/skbuff.h                    |    1 +
 net/core/netpoll.c                        |   31 ++++++++++++++---------------
 net/core/skbuff.c                         |    2 +-
 net/netfilter/nf_conntrack_irc.c          |   15 +++++++------
 net/netfilter/xt_cluster.c                |   11 ++++++++-
 18 files changed, 68 insertions(+), 70 deletions(-)
