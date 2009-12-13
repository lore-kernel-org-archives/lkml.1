Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZLNARy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZLNARy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754909AbZLMX5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34164 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897AbZLMX5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:47 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jens.axboe@oracle.com,
       torvalds@linux-foundation.org, philipp.reisner@linbit.com
Subject: [PATCH 2/9] Constify struct file_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:30 +0100
Message-Id: <ccaec1215371ca2d99835a906c6a1b7c55f9d78e.1260662997.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662997.git.re.emese@gmail.com>
References: <cover.1260662997.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/block/drbd/drbd_int.h  |    2 +-
 drivers/block/drbd/drbd_proc.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2312d78..c975587 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1490,7 +1490,7 @@ void drbd_bump_write_ordering(struct drbd_conf *mdev, enum write_ordering_e wo);
 
 /* drbd_proc.c */
 extern struct proc_dir_entry *drbd_proc;
-extern struct file_operations drbd_proc_fops;
+extern const struct file_operations drbd_proc_fops;
 extern const char *drbd_conn_str(enum drbd_conns s);
 extern const char *drbd_role_str(enum drbd_role s);
 
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index bdd0b49..df8ad96 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -38,7 +38,7 @@ static int drbd_proc_open(struct inode *inode, struct file *file);
 
 
 struct proc_dir_entry *drbd_proc;
-struct file_operations drbd_proc_fops = {
+const struct file_operations drbd_proc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= drbd_proc_open,
 	.read		= seq_read,
-- 
1.6.5.3

