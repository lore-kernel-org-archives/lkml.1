Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXEOMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXEOMrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 08:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXEOMrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 08:47:18 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:6512 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbXEOMrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 08:47:17 -0400
Message-ID: <4649ABC9.6020605@sw.ru>
Date: Tue, 15 May 2007 16:47:05 +0400
From: Vasily Averin <vvs@sw.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: [patch i2o 5/6] i2o_proc files permission
References: <4649AA6C.2080808@sw.ru>
In-Reply-To: <4649AA6C.2080808@sw.ru>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reading from some i2o related proc files can lead to the i2o controller hang due
unknown reasons. As a workaround this patch changes the permission of these
files to root-only accessible.

Signed-off-by: Vasily Averin <vvs@sw.ru>

--- lk2.6/drivers/message/i2o/i2o_proc.c
+++ lk2.6/drivers/message/i2o/i2o_proc.c
@@ -1855,17 +1855,17 @@ static i2o_proc_entry i2o_proc_generic_i
  * Device specific entries
  */
 static i2o_proc_entry generic_dev_entries[] = {
-	{"groups", S_IFREG | S_IRUGO, &i2o_seq_fops_groups},
-	{"phys_dev", S_IFREG | S_IRUGO, &i2o_seq_fops_phys_device},
-	{"claimed", S_IFREG | S_IRUGO, &i2o_seq_fops_claimed},
-	{"users", S_IFREG | S_IRUGO, &i2o_seq_fops_users},
-	{"priv_msgs", S_IFREG | S_IRUGO, &i2o_seq_fops_priv_msgs},
-	{"authorized_users", S_IFREG | S_IRUGO, &i2o_seq_fops_authorized_users},
-	{"dev_identity", S_IFREG | S_IRUGO, &i2o_seq_fops_dev_identity},
-	{"ddm_identity", S_IFREG | S_IRUGO, &i2o_seq_fops_ddm_identity},
-	{"user_info", S_IFREG | S_IRUGO, &i2o_seq_fops_uinfo},
-	{"sgl_limits", S_IFREG | S_IRUGO, &i2o_seq_fops_sgl_limits},
-	{"sensors", S_IFREG | S_IRUGO, &i2o_seq_fops_sensors},
+	{"groups", S_IFREG | S_IRUSR, &i2o_seq_fops_groups},
+	{"phys_dev", S_IFREG | S_IRUSR, &i2o_seq_fops_phys_device},
+	{"claimed", S_IFREG | S_IRUSR, &i2o_seq_fops_claimed},
+	{"users", S_IFREG | S_IRUSR, &i2o_seq_fops_users},
+	{"priv_msgs", S_IFREG | S_IRUSR, &i2o_seq_fops_priv_msgs},
+	{"authorized_users", S_IFREG | S_IRUSR, &i2o_seq_fops_authorized_users},
+	{"dev_identity", S_IFREG | S_IRUSR, &i2o_seq_fops_dev_identity},
+	{"ddm_identity", S_IFREG | S_IRUSR, &i2o_seq_fops_ddm_identity},
+	{"user_info", S_IFREG | S_IRUSR, &i2o_seq_fops_uinfo},
+	{"sgl_limits", S_IFREG | S_IRUSR, &i2o_seq_fops_sgl_limits},
+	{"sensors", S_IFREG | S_IRUSR, &i2o_seq_fops_sensors},
 	{NULL, 0, NULL}
 };
