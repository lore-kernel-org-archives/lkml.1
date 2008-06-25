Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYFYOkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYFYOkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbYFYOgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:36:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:11017 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954AbYFYOgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:36:33 -0400
Message-Id: <20080625143615.498786512@de.ibm.com>
References: <20080625143459.100139455@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Jun 2008 16:35:15 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 16/21] Cleanup vmlogrdr printk messages.
Content-Disposition: inline; filename=815-printk-vmlogrdr.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message descriptions are still missing though ..

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmlogrdr.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

Index: quilt-2.6/drivers/s390/char/vmlogrdr.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmlogrdr.c
+++ quilt-2.6/drivers/s390/char/vmlogrdr.c
@@ -216,9 +216,7 @@ static int vmlogrdr_get_recording_class_
 	char *tail;
 	int len,i;
 
-	printk (KERN_DEBUG "vmlogrdr: query command: %s\n", cp_command);
 	cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
-	printk (KERN_DEBUG "vmlogrdr: response: %s", cp_response);
 	len = strnlen(cp_response,sizeof(cp_response));
 	// now the parsing
 	tail=strnchr(cp_response,len,'=');
@@ -268,11 +266,7 @@ static int vmlogrdr_recording(struct vml
 			 logptr->recording_name,
 			 qid_string);
 
-		printk (KERN_DEBUG "vmlogrdr: recording command: %s\n",
-			cp_command);
 		cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
-		printk (KERN_DEBUG "vmlogrdr: recording response: %s",
-			cp_response);
 	}
 
 	memset(cp_command, 0x00, sizeof(cp_command));
@@ -282,10 +276,7 @@ static int vmlogrdr_recording(struct vml
 		onoff,
 		qid_string);
 
-	printk (KERN_DEBUG "vmlogrdr: recording command: %s\n", cp_command);
 	cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
-	printk (KERN_DEBUG "vmlogrdr: recording response: %s",
-		cp_response);
 	/* The recording command will usually answer with 'Command complete'
 	 * on success, but when the specific service was never connected
 	 * before then there might be an additional informational message
@@ -567,10 +558,7 @@ static ssize_t vmlogrdr_purge_store(stru
 			 "RECORDING %s PURGE ",
 			 priv->recording_name);
 
-	printk (KERN_DEBUG "vmlogrdr: recording command: %s\n", cp_command);
 	cpcmd(cp_command, cp_response, sizeof(cp_response), NULL);
-	printk (KERN_DEBUG "vmlogrdr: recording response: %s",
-		cp_response);
 
 	return count;
 }
@@ -682,28 +670,20 @@ static int vmlogrdr_register_driver(void
 
 	/* Register with iucv driver */
 	ret = iucv_register(&vmlogrdr_iucv_handler, 1);
-	if (ret) {
-		printk (KERN_ERR "vmlogrdr: failed to register with "
-			"iucv driver\n");
+	if (ret)
 		goto out;
-	}
 
 	ret = driver_register(&vmlogrdr_driver);
-	if (ret) {
-		printk(KERN_ERR "vmlogrdr: failed to register driver.\n");
+	if (ret)
 		goto out_iucv;
-	}
 
 	ret = driver_create_file(&vmlogrdr_driver,
 				 &driver_attr_recording_status);
-	if (ret) {
-		printk(KERN_ERR "vmlogrdr: failed to add driver attribute.\n");
+	if (ret)
 		goto out_driver;
-	}
 
 	vmlogrdr_class = class_create(THIS_MODULE, "vmlogrdr");
 	if (IS_ERR(vmlogrdr_class)) {
-		printk(KERN_ERR "vmlogrdr: failed to create class.\n");
 		ret = PTR_ERR(vmlogrdr_class);
 		vmlogrdr_class = NULL;
 		goto out_attr;
@@ -871,12 +851,10 @@ static int __init vmlogrdr_init(void)
 	rc = vmlogrdr_register_cdev(dev);
 	if (rc)
 		goto cleanup;
-	printk (KERN_INFO "vmlogrdr: driver loaded\n");
 	return 0;
 
 cleanup:
 	vmlogrdr_cleanup();
-	printk (KERN_ERR "vmlogrdr: driver not loaded.\n");
 	return rc;
 }
 
@@ -884,7 +862,6 @@ cleanup:
 static void __exit vmlogrdr_exit(void)
 {
 	vmlogrdr_cleanup();
-	printk (KERN_INFO "vmlogrdr: driver unloaded\n");
 	return;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

