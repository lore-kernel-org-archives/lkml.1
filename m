Return-Path: <linux-kernel-owner+w=401wt.eu-S1757645AbYG0Oqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbYG0Oqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 10:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYG0Opm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 10:45:42 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:28101 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbYG0Opc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 10:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=jCfJKjBh9BmTMPgrvhq2QkUCN+o0zChWS7sWEOBVkpAA35A4VORle1gvnDcRJw0gd3
         YlhF3iqS/GJwUpQE5OxPR9fH0tH1QIzAFzO2Sbi2vSk7b+iBbnB/pmNA+AdwHKdWPpQZ
         yD1Hqf1CdoeJxfuw9o+abC3/NLL4zm59IPhVs=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] Blackfin EMAC Driver: Functional power management support
Date: Sun, 27 Jul 2008 22:45:05 +0800
Message-Id: <1217169905-7055-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217169905-7055-1-git-send-email-cooloney@kernel.org>
References: <1217169905-7055-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Reprogram MAC address after resume from Suspend Mem
(Blackfin Hibernate looses all CORE and SYSTEM register content)

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/net/bfin_mac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 57ebe6d..69a6b9d 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -972,6 +972,7 @@ static int bfin_mac_open(struct net_device *dev)
 	phy_start(lp->phydev);
 	phy_write(lp->phydev, MII_BMCR, BMCR_RESET);
 	setup_system_regs(dev);
+	setup_mac_addr(dev->dev_addr);
 	bfin_mac_disable();
 	bfin_mac_enable();
 	pr_debug("hardware init finished\n");
-- 
1.5.6

