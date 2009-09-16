Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZIPJGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZIPJGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZIPJGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:06:51 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:37642 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbZIPJGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:06:50 -0400
Date: Wed, 16 Sep 2009 11:06:52 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Russell King <linux@arm.linux.org.uk>, Eric Miao <eric.y.miao@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] arch/arm: adjust duplicate structure field initialization
Message-ID: <Pine.LNX.4.64.0909161105580.8590@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Currently the irq_type field of the csb726_lan_config structure is
initialized twice.  The value in the first case,
SMSC911X_IRQ_POLARITY_ACTIVE_LOW, is normally stored in the irq_polarity
field, so I have renamed the field in the first initialization to that.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-pxa/csb726.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/csb726.c b/arch/arm/mach-pxa/csb726.c
index 79141f8..965480e 100644
--- a/arch/arm/mach-pxa/csb726.c
+++ b/arch/arm/mach-pxa/csb726.c
@@ -238,7 +238,7 @@ static struct resource csb726_lan_resources[] = {
 };
 
 struct smsc911x_platform_config csb726_lan_config = {
-	.irq_type	= SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
+	.irq_polarity	= SMSC911X_IRQ_POLARITY_ACTIVE_LOW,
 	.irq_type	= SMSC911X_IRQ_TYPE_PUSH_PULL,
 	.flags		= SMSC911X_USE_32BIT,
 	.phy_interface	= PHY_INTERFACE_MODE_MII,
