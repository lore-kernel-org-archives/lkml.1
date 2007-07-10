Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXGJJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXGJJbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763715AbXGJJ26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 05:28:58 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:41858 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764138AbXGJJ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 05:28:48 -0400
Message-Id: <20070710093120.145831345@de.ibm.com>
References: <20070710092935.896013926@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 10 Jul 2007 11:29:46 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 11/16] dasd: Avoid compile warnings on !CONFIG_DASD_PROFILE
Content-Disposition: inline; filename=011-dasd-profile.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

drivers/s390/block/dasd_proc.c:33:
 warning: 'dasd_get_user_string' defined but not used 
drivers/s390/block/dasd_proc.c:172:
 warning: 'dasd_statistics_array' defined but not used 

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/dasd_proc.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: quilt-2.6/drivers/s390/block/dasd_proc.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/dasd_proc.c
+++ quilt-2.6/drivers/s390/block/dasd_proc.c
@@ -28,6 +28,7 @@ static struct proc_dir_entry *dasd_proc_
 static struct proc_dir_entry *dasd_devices_entry = NULL;
 static struct proc_dir_entry *dasd_statistics_entry = NULL;
 
+#ifdef CONFIG_DASD_PROFILE
 static char *
 dasd_get_user_string(const char __user *user_buf, size_t user_len)
 {
@@ -47,6 +48,7 @@ dasd_get_user_string(const char __user *
 		buffer[user_len] = 0;
 	return buffer;
 }
+#endif /* CONFIG_DASD_PROFILE */
 
 static int
 dasd_devices_show(struct seq_file *m, void *v)
@@ -167,6 +169,7 @@ dasd_calc_metrics(char *page, char **sta
 	return len;
 }
 
+#ifdef CONFIG_DASD_PROFILE
 static char *
 dasd_statistics_array(char *str, unsigned int *array, int shift)
 {
@@ -180,6 +183,7 @@ dasd_statistics_array(char *str, unsigne
 	str += sprintf(str,"\n");
 	return str;
 }
+#endif /* CONFIG_DASD_PROFILE */
 
 static int
 dasd_statistics_read(char *page, char **start, off_t off,

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

