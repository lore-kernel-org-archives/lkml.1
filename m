Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXLRP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXLRP0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbXLRP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:26:01 -0500
Received: from mail0.scram.de ([78.47.204.202]:55753 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbXLRPZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:25:59 -0500
X-Spam-Score: -4.162
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4767E677.7010200@scram.de>
Date: Tue, 18 Dec 2007 16:25:43 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, "Garzik, Jeff" <jgarzik@pobox.com>,
       Scott Wood <scottwood@freescale.com>
Subject: [PATCH] [POWERPC] Add fixed-phy support for fs_enet
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to use the fixed-link property
of an ethernet node to fs_enet for the
CONFIG_PPC_CPM_NEW_BINDING case.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
Acked-by: Jeff Garzik <jeff@garzik.org>
Acked-by: Vitali Bordug <vitb@kernel.crashing.org>
---
 drivers/net/fs_enet/fs_enet-main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index f2a4d39..8220c70 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -1174,8 +1174,15 @@ static int __devinit find_phy(struct device_node *np,
 	struct device_node *phynode, *mdionode;
 	struct resource res;
 	int ret = 0, len;
+	const u32 *data;
+
+	data  = of_get_property(np, "fixed-link", NULL);
+	if (data) {
+		snprintf(fpi->bus_id, 16, PHY_ID_FMT, 0, *data);
+		return 0;
+	}

-	const u32 *data = of_get_property(np, "phy-handle", &len);
+	data = of_get_property(np, "phy-handle", &len);
 	if (!data || len != 4)
 		return -EINVAL;

-- 
1.5.3.7

