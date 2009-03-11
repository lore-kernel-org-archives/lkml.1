Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZCKUt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZCKUt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZCKUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:47:56 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:51013 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZCKUrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:47:55 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Simon Arlott <cxacru@fire.lp0.eu>
Subject: [PATCH 1/5] USB: atm/cxacru, fix lock imbalance
Date: Wed, 11 Mar 2009 21:47:36 +0100
Message-Id: <1236804460-1432-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not hold mutex in one place in cxacru_cm, but unlock it on fail path.
Fix this.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Simon Arlott <cxacru@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 5ed4ae0..6789089 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -485,7 +485,7 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 			usb_err(instance->usbatm, "requested transfer size too large (%d, %d)\n",
 				wbuflen, rbuflen);
 		ret = -ENOMEM;
-		goto fail;
+		goto err;
 	}
 
 	mutex_lock(&instance->cm_serialize);
@@ -565,6 +565,7 @@ static int cxacru_cm(struct cxacru_data *instance, enum cxacru_cm_request cm,
 	dbg("cm %#x", cm);
 fail:
 	mutex_unlock(&instance->cm_serialize);
+err:
 	return ret;
 }
 
-- 
1.6.2
caught by stanse
