Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656Ab0A0Uqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0A0Uqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291Ab0A0Uqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:42 -0500
Received: from mail.perches.com ([173.55.12.10]:1541 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab0A0Uqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:34 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 08/13] drivers/block/floppy.c: Remove some unnecessary casting
Date: Wed, 27 Jan 2010 12:46:24 -0800
Message-Id: <cf276ce1d44fe5fcb1689142e55a9c81c495165b.1264624292.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove char/void __user * use
Remove kmalloc cast

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 14fefe2..5bad295 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3104,13 +3104,13 @@ static struct cont_t raw_cmd_cont = {
 	.done		= raw_cmd_done
 };
 
-static inline int raw_cmd_copyout(int cmd, char __user *param,
+static inline int raw_cmd_copyout(int cmd, void __user *param,
 				  struct floppy_raw_cmd *ptr)
 {
 	int ret;
 
 	while (ptr) {
-		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
+		ret = copy_to_user(param, ptr, sizeof(*ptr));
 		if (ret)
 			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
@@ -3148,7 +3148,7 @@ static void raw_cmd_free(struct floppy_raw_cmd **ptr)
 	}
 }
 
-static inline int raw_cmd_copyin(int cmd, char __user *param,
+static inline int raw_cmd_copyin(int cmd, void __user *param,
 				 struct floppy_raw_cmd **rcmd)
 {
 	struct floppy_raw_cmd *ptr;
@@ -3157,12 +3157,11 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
 
 	*rcmd = NULL;
 	while (1) {
-		ptr = (struct floppy_raw_cmd *)
-		    kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
-		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
+		ret = copy_from_user(ptr, param, sizeof(*ptr));
 		if (ret)
 			return -EFAULT;
 		ptr->next = NULL;
-- 
1.6.6.rc0.57.gad7a

