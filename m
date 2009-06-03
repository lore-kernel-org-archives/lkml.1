Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZFCC4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZFCC4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZFCCzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:55:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48671 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZFCCzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:55:46 -0400
Date: Wed, 3 Jun 2009 12:20:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ed Swierk <eswierk@aristanetworks.com>,
       Ayaz Abdulla <aabdulla@nvidia.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20090603122048.f2b7fef2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the net tree got a conflict in
drivers/net/forcedeth.c between commit
5a9a8e32ebe269c71d8d3e78f9435fe7729f38e9 ("forcedeth: add phy_power_down
parameter, leave phy powered up by default (v2)") from Linus' tree and
commit 88d7d8b00cdc3117150faab4c4ace6d464b71c22 ("forcedeth: add clock
gating feature <resend>") from the net tree.

Just context changing.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/forcedeth.c
index 9f6a68f,d0b1d9f..0000000
--- a/drivers/net/forcedeth.c
+++ b/drivers/net/forcedeth.c
@@@ -5522,7 -5534,8 +5543,8 @@@ static int nv_close(struct net_device *
  
  	nv_drain_rxtx(dev);
  
 -	if (np->wolenabled) {
 +	if (np->wolenabled || !phy_power_down) {
+ 		nv_txrx_gate(dev, false);
  		writel(NVREG_PFF_ALWAYS|NVREG_PFF_MYADDR, base + NvRegPacketFilterFlags);
  		nv_start_rx(dev);
  	} else {
