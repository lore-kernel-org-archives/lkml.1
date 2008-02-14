Return-Path: <linux-kernel-owner+w=401wt.eu-S1765008AbYBNVx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765008AbYBNVx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYBNVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:53:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:42633 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYBNVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:53:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NQtPpIxTg3yWnhdftTgN/6c6SiNI84wVwAPqLC+RD6i5VP6AxgPj3HqhzmDGdx1Qn9aPfI4fFuR7ykZ0uiGkPNUZzMM+dJspokGNxfYJFjvDSG63kV9UhX4zTforbjFITg0KaEnOQc06+LwwLZvZQDvoNjg94UCxqkSJEAbPPck=
Subject: [PATCH] ubi: fix sparse errors in ubi.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 13:53:15 -0800
Message-Id: <1203025995.5601.0.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In C, signed 1-bit bitfields can only take the values 0 and -1, only
0 and 1 are ever assigned in current code.  Make them unsigned
bitfields.

Fixes the (repeated) sparse errors:
drivers/mtd/ubi/ubi.h:220:15: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:221:17: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:222:18: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:223:16: error: dubious one-bit signed bitfield
drivers/mtd/ubi/ubi.h:224:20: error: dubious one-bit signed bitfield

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Sorry, not sure who to CC on this.

 drivers/mtd/ubi/ubi.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 4577106..a548c1d 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -217,11 +217,11 @@ struct ubi_volume {
 	void *upd_buf;
 
 	int *eba_tbl;
-	int checked:1;
-	int corrupted:1;
-	int upd_marker:1;
-	int updating:1;
-	int changing_leb:1;
+	unsigned int checked:1;
+	unsigned int corrupted:1;
+	unsigned int upd_marker:1;
+	unsigned int updating:1;
+	unsigned int changing_leb:1;
 
 #ifdef CONFIG_MTD_UBI_GLUEBI
 	/*
-- 
1.5.4.1.1278.gc75be



