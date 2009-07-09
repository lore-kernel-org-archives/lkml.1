Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZGIAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZGIAQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 20:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZGIAQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 20:16:37 -0400
Received: from mail-pz0-f175.google.com ([209.85.222.175]:53913 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbZGIAQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 20:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hj8W8Eq4mcktoe9j00K+tkIQ3xFK/jYMXshOWKP43JhjVpGXpUp+kVOaCpzMCMnkp3
         103lSiubFMnoTuyoPADNnvE6qYNmiCccwDn7YXRqPbZ5QnjDH7P5Kek98upRdO6Kc6dA
         QrE+3Cogvj+w21KK6y4m5fe6P0F3QvwEAny00=
From: tom.leiming@gmail.com
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, dwmw2@infradead.org,
       kay.sievers@vrfy.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] driver core:firmware_class:fix memory leak of page pointers array
Date: Thu,  9 Jul 2009 08:16:31 +0800
Message-Id: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The page pointers array is allocated in fw_realloc_buffer() called by
firmware_data_write(), and should be freed in release function of firmware
device.

Signed-off-by:Ming Lei <tom.leiming@gmail.com>
Reported-by:Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/base/firmware_class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index fc46653..2643366 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -180,7 +180,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 				goto err;
 			}
 			/* Pages will be freed by vfree() */
-			fw_priv->pages = NULL;
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
-- 
1.6.0.GIT

