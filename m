Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbYGKNyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbYGKNyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbYGKNsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:13 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34981 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759433AbYGKNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:58 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 28/30] W1: ds2490.c ds_write_block remove extra ds_wait_status
Date: Fri, 11 Jul 2008 17:51:43 +0400
Message-Id: <12157843072670-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the extra ds_wait_status() in ds_write_block().

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index d9e07d6..466048f 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -648,8 +648,6 @@ static int ds_write_block(struct ds_device *dev, u8 *buf, int len)
 	if (err < 0)
 		return err;
 
-	ds_wait_status(dev, &st);
-
 	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
 	if (err)
 		return err;
-- 
1.4.4.4

