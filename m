Return-Path: <linux-kernel-owner+w=401wt.eu-S1764552AbYJJVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764552AbYJJVnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbYJJVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:43:10 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:37906 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759878AbYJJVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:43:09 -0400
Date: Fri, 10 Oct 2008 23:42:34 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: jamagallon@ono.com, greg@kroah.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bonbons@linux-vserver.org, ivecera@redhat.com,
       Ben Hutchings <bhutchings@solarflare.com>,
       ishikawa <chiaki.ishikawa@ubin.jp>, Mark Lord <lkml@rtr.ca>,
       edward_hsu@realtek.com.tw
Subject: [PATCH 06/14] r8169: 8168b Tx performance tweak
Message-ID: <20081010214234.GF27195@electric-eye.fr.zoreil.com>
References: <20081006071229.GA23039@electric-eye.fr.zoreil.com> <20081007222202.GA9393@electric-eye.fr.zoreil.com> <20081009190015.GB19721@electric-eye.fr.zoreil.com> <20081009.122026.239988133.davem@davemloft.net> <20081010213638.GA25005@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010213638.GA25005@electric-eye.fr.zoreil.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
---
 drivers/net/r8169.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 60d2ded..f929dba 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -2386,7 +2386,8 @@ static void rtl_ephy_init(void __iomem *ioaddr, struct ephy_info *e, int len)
 
 static void rtl_hw_start_8168bb(void __iomem *ioaddr, struct pci_dev *pdev)
 {
-	rtl_tx_performance_tweak(pdev, 0x5 << MAX_READ_REQUEST_SHIFT);
+	rtl_tx_performance_tweak(pdev,
+		(0x5 << MAX_READ_REQUEST_SHIFT) | PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 static void rtl_hw_start_8168bef(void __iomem *ioaddr, struct pci_dev *pdev)
-- 
1.5.3.3

