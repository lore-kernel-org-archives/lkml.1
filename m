Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYDXOdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYDXOdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYDXOdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:33:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:18028 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDXOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oRK7SXoj8DJt+WBqOBxoGMv2B/huQsLI4FHY3qytZs9AJxYBW2Nk39drUTsCy76+68gxySHF5BRQQnO3XyTOvhXtC6yBaweP2Cpf554lxCaewDNUtVGbY4y0lOCP+hNG0IPZhwXd9nqsdNjFcbA8a8IObTN1zhDaQFTX4F5Yfac=
From: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Ciaran McCreesh <ciaran.mccreesh@googlemail.com>
Subject: [RFC, PATCH] printk when requesting firmware
Date: Thu, 24 Apr 2008 15:33:37 +0100
Message-Id: <1209047617-2426-1-git-send-email-ciaran.mccreesh@googlemail.com>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before requesting firmware, printk a message saying what we're requesting. This
makes it easier to see what's going on, and provides an explanation for the
huge silent delay that one would otherwise get after accidentally building
ipw2200 as a non-module.
---
 drivers/base/firmware_class.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 1fef7df..9fd4a85 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -396,6 +396,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (!firmware_p)
 		return -EINVAL;
 
+	printk(KERN_INFO "firmware: requesting %s\n", name);
+
 	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
 	if (!firmware) {
 		printk(KERN_ERR "%s: kmalloc(struct firmware) failed\n",
-- 
1.5.4.2

