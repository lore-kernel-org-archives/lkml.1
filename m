Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXK1Klx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXK1Klx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbXK1Kl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:41:27 -0500
Received: from ro-out-1112.google.com ([72.14.202.183]:1665 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760686AbXK1KlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=tRV4zpnCmJ8X/4KtS3TyPIoHUOepnialB+bbONyaAOD4lCQob35TXI0nv1Z2RkY+uhunRJnFjamLs+PxynUc9cdYinahy9flpNp7jPE5R49mISomY7yVdGlqWel0ea2xxDmFrHl/D1JbRb2k9uzDQIBgfHw+6JvBgSJCWCXYh6M=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <yi.zhu@intel.com>, <ipw3945-devel@lists.sourceforge.net>,
       <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH 2/2] [net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.
Date: Wed, 28 Nov 2007 19:41:08 +0900
Message-ID: <00e601c831ab$30475910$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: Acgxqy3b0Wax4D2cS2K2KiJh0hzjUQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think 4965 may suffer it too, but I could not test.

Thanks
Joonwoo

[net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..a71a572 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9165,6 +9165,7 @@ static void iwl_pci_remove(struct pci_dev *pdev)
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	mutex_lock(&priv->mutex);
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 	__iwl_down(priv);
 	mutex_unlock(&priv->mutex);
---

