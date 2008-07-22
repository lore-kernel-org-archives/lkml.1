Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYGVAbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYGVAbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYGVA36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:58 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6764 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694AbYGVA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gwmH5t5HTc+9/UfCHSTbYU0N+ZkLP/GedJlHwWK4iqAxJW/ej8NHsXRiTtgE9EdnMB
         Xc0UJd1Z50zz8kQn5/PUBmJlS2+z+FGST+KTfl5Kgaj0KMHCQr9vl89IDrLMclgdJizJ
         Nnm9W/rL9xRUjFUc3uS+CuMPZHF94Xa4H2sfw=
Message-ID: <48852A00.5050306@gmail.com>
Date: Mon, 21 Jul 2008 20:29:52 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ipw2100-admin@linux.intel.com, linux-wireless@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] iwl-4965: test below 0 on unsigned num_tbs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

num_tbs is unsigned so the test doesn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index de330ae..9e957a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3121,7 +3121,7 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
-	if ((num_tbs >= MAX_NUM_OF_TBS) || (num_tbs < 0)) {
+	if (num_tbs >= MAX_NUM_OF_TBS) {
 		IWL_ERROR("Error can not send more than %d chunks\n",
 			  MAX_NUM_OF_TBS);
 		return -EINVAL;
