Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYAYHTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYAYHTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbYAYHPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:52480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbYAYHO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:59 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Tony Jones <tonyj@suse.de>,
       Jan Harkes <jaharkes@cs.cmu.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 018/196] coda: convert struct class_device to struct device
Date: Thu, 24 Jan 2008 23:09:16 -0800
Message-Id: <1201245134-4876-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tony Jones <tonyj@suse.de>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/coda/psdev.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index dcc6aea..e3eb355 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -362,8 +362,8 @@ static int init_coda_psdev(void)
 		goto out_chrdev;
 	}		
 	for (i = 0; i < MAX_CODADEVS; i++)
-		class_device_create(coda_psdev_class, NULL,
-				MKDEV(CODA_PSDEV_MAJOR,i), NULL, "cfs%d", i);
+		device_create(coda_psdev_class, NULL,
+			      MKDEV(CODA_PSDEV_MAJOR,i), "cfs%d", i);
 	coda_sysctl_init();
 	goto out;
 
@@ -405,7 +405,7 @@ static int __init init_coda(void)
 	return 0;
 out:
 	for (i = 0; i < MAX_CODADEVS; i++)
-		class_device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
+		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
 	unregister_chrdev(CODA_PSDEV_MAJOR, "coda");
 	coda_sysctl_clean();
@@ -424,7 +424,7 @@ static void __exit exit_coda(void)
                 printk("coda: failed to unregister filesystem\n");
         }
 	for (i = 0; i < MAX_CODADEVS; i++)
-		class_device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
+		device_destroy(coda_psdev_class, MKDEV(CODA_PSDEV_MAJOR, i));
 	class_destroy(coda_psdev_class);
 	unregister_chrdev(CODA_PSDEV_MAJOR, "coda");
 	coda_sysctl_clean();
-- 
1.5.3.8

