Return-Path: <linux-kernel-owner+w=401wt.eu-S1762646AbXK2BoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762646AbXK2BoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762467AbXK2Bnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:43:42 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:25949 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762063AbXK2Bnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:43:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:in-reply-to:thread-index;
        b=F1eGHCyraOgauW5k+vzXbhsVmPp6lFQWKzWMpm8YUpGj6yo0ybVDh8TZxsxnQz7CTa3Su+aCkIlrjvb7UqAQsHjoKmujkLFYjssLSPSc1z1xxYEGkvy8afy24E1lxDjWX5jJMyk45GoTVmuaQ6L65IKwojaarTCMrOIyw7oG1f0=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <yi.zhu@intel.com>, <ipw3945-devel@lists.sourceforge.net>,
       <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: 
Subject: RE: [PATCH 2/2] [net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.
Date: Thu, 29 Nov 2007 10:43:16 +0900
Message-ID: <016501c83229$3abdbbe0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: 
Thread-Index: Acgxqy3b0Wax4D2cS2K2KiJh0hzjUQAfXe/Q
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cancel_delayed_work_sync has moved into ilw_cancel_deferred_work.
Thanks Zhu Yi.

[net/wireless/iwlwifi] : iwlwifi 4965 Fix race conditional panic.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 9918780..2474eba 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8864,6 +8864,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl_hw_cancel_deferred_work(priv);
 
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
---

