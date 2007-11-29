Return-Path: <linux-kernel-owner+w=401wt.eu-S1762624AbXK2Bnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762624AbXK2Bnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbXK2Bnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:43:33 -0500
Received: from hu-out-0506.google.com ([72.14.214.225]:32440 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552AbXK2Bnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:43:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:in-reply-to:thread-index;
        b=HsgMtD8YFbhFYwnAsXwroZQc50KzD36pbIJ322aY/W6l5DoJoFmnQ1uWGrf/8gSLVB7xwpPHmrVTnWOh7UFGBwDIoIIIsqt7tZAUzna91PVtnYM4fpBCoIr0bfuN+gZUaQetg20X9yZ7yOSl9kV11CGvJHfxshC682G5xWktQl8=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'Zhu Yi'" <yi.zhu@intel.com>
Cc: <ipw3945-devel@lists.sourceforge.net>, <linux-wireless@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <00e501c831ab$2e78daa0$9c94fea9@jason> <1196298656.7614.77.camel@debian.sh.intel.com>
Subject: RE: [PATCH 1/2] [net/wireless/iwlwifi] : iwlwifi 3945 Fix raceconditional panic.
Date: Thu, 29 Nov 2007 10:42:49 +0900
Message-ID: <016401c83229$3302d250$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <1196298656.7614.77.camel@debian.sh.intel.com>
Thread-Index: AcgyJPMrK/8DoAiVSmOa50uab7nVxQAAxFfA
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/29, Zhu Yi <yi.zhu@intel.com>:
> 
> Good catch. But it will be better if you add it into
> iwl_cancel_deferred_work().
> 

Thanks.
I agree with you. 
Actually, I considered it, but I was afraid of side effect.
Anyway, I'm attaching a new one.

Thanks.
Joonwoo

[net/wireless/iwlwifi] : iwlwifi 3945 Fix race conditional panic.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 465da4f..e51e872 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8270,6 +8270,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
 	iwl_hw_cancel_deferred_work(priv);
 
+	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
---

