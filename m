Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbXKCTQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbXKCTQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbXKCTQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:16:47 -0400
Received: from mail0.scram.de ([78.47.204.202]:46016 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbXKCTQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:16:46 -0400
X-Spam-Score: -3.873
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.5 AWL AWL: From: address is in the auto white-list
Message-ID: <472CC914.3030709@scram.de>
Date: Sat, 03 Nov 2007 20:16:36 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
CC: linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Scott Wood <scottwood@freescale.com>, Jeff Garzik <jeff@garzik.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] [POWERPC] Fix typo #ifdef -> #ifndef
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fpi->cp_command should be overwritten only if CONFIG_PPC_CPM_NEW_BINDING
is NOT set. Otherwise it is already set from the device tree.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---

This can be pulled from git://git.bocc.de/dbox2.git for-2.6.24

 drivers/net/fs_enet/mac-scc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/fs_enet/mac-scc.c b/drivers/net/fs_enet/mac-scc.c
index 03134f4..48f2f30 100644
--- a/drivers/net/fs_enet/mac-scc.c
+++ b/drivers/net/fs_enet/mac-scc.c
@@ -158,7 +158,7 @@ static int setup_data(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 
-#ifdef CONFIG_PPC_CPM_NEW_BINDING
+#ifndef CONFIG_PPC_CPM_NEW_BINDING
 	struct fs_platform_info *fpi = fep->fpi;
 
 	fep->scc.idx = fs_get_scc_index(fpi->fs_no);
-- 
1.5.3.4

