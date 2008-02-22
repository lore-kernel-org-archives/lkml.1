Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbYBVSOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbYBVSOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYBVSOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:14:00 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:31136 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYBVSN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:13:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DobiAAzXe5EJia00qZrQ1UceZT8Cndvy5ypJ246YjQQyOPROQJ32q8Ph+p/ncu9GE/nHuPkuCfZT4wMWX3bGaaEha5zfRPxedjPCWDvJ8dzalogJn4Lv4BI+KHJ53c5Mr3b5GmgULs7drwdNtk8IOvOtVN8i8V6fUF5GEUGMr3g=
Subject: [PATCH] char: fix sparse shadowed variable warnings in cyclades.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 10:14:15 -0800
Message-Id: <1203704055.5962.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nested min() macros.
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_x' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here
drivers/char/cyclades.c:2750:7: warning: symbol '_y' shadows an earlier one
drivers/char/cyclades.c:2750:7: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/char/cyclades.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index e4f579c..f8f4d54 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2747,8 +2747,8 @@ static int cy_write(struct tty_struct *tty, const unsigned char *buf, int count)
 
 	spin_lock_irqsave(&info->card->card_lock, flags);
 	while (1) {
-		c = min(count, min((int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1),
-				   (int)(SERIAL_XMIT_SIZE - info->xmit_head)));
+		c = min(count, (int)(SERIAL_XMIT_SIZE - info->xmit_cnt - 1));
+		c = min(c, (int)(SERIAL_XMIT_SIZE - info->xmit_head));
 
 		if (c <= 0)
 			break;
-- 
1.5.4.2.200.g99e75



