Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbYG0GPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbYG0GPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYG0GPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:15:06 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:34498 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbYG0GPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:15:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=DE1cnnGGn+4zRdBAWYYpqKdBTojYvmlTFAS5AoeDk0vN8YmI8Pu8zTjVrTT+kUJWuo
         U6CqiN1gTnxlcaditLdcQMNmhoB5+d5ptnFA+hBGhiS2jhq+0SEy7GpzcEqZvjdxjGfT
         JS2m0UYEtB06+otmXK0MqwEeK3yANg62CNgVU=
From: Bryan Wu <cooloney@kernel.org>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] Blackfin EMAC Driver: Functional power management support
Date: Sun, 27 Jul 2008 14:13:55 +0800
Message-Id: <1217139235-19018-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1217139235-19018-1-git-send-email-cooloney@kernel.org>
References: <1217139235-19018-1-git-send-email-cooloney@kernel.org>
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

