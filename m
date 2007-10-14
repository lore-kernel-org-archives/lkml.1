Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbXJNRvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbXJNRvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 13:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760139AbXJNRug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 13:50:36 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35247 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760075AbXJNRue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 13:50:34 -0400
Date: Sun, 14 Oct 2007 19:51:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Auke Kok <auke-jan.h.kok@intel.com>, Jeff Garzik <jeff@garzik.org>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] e1000e/ethtool.c: fix error checks
Message-ID: <20071014175104.GK4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

You want to check for the value, not for the address.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -1451,11 +1451,11 @@ static int e1000_loopback_test(struct e1000_adapter *adapter, u64 *data)
 	}
 
 	*data = e1000_setup_desc_rings(adapter);
-	if (data)
+	if (*data)
 		goto out;
 
 	*data = e1000_setup_loopback_test(adapter);
-	if (data)
+	if (*data)
 		goto err_loopback;
 
 	*data = e1000_run_loopback_test(adapter);

