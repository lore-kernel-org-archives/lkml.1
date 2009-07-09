Return-Path: <linux-kernel-owner+w=401wt.eu-S1750920AbZGIXsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750920AbZGIXsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbZGIXsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:48:24 -0400
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:46457 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750732AbZGIXsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:48:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] trivial: printk(KERN_* vs. pr_* and __FUNCTION_ in IMA
Date: Thu, 9 Jul 2009 19:48:21 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901A68D09@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] trivial: printk(KERN_* vs. pr_* and __FUNCTION_ in IMA
Thread-Index: AcoA772tTSSU9nJ9Tyq87KR01txaXw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jul 2009 23:48:22.0401 (UTC) FILETIME=[BE569710:01CA00EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup of the IBM Integrity Measurement Architecture source. 

Change a few printk(KERN_* to equivelent pr_* form and use __func__ instead
Of gcc specific __FUNCTION__.  Along with some minor whitespace cleanup due
to the changes.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
index b8dd693..11e6e2a 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -138,18 +138,15 @@ void iint_free(struct kref *kref)
 	iint->version = 0;
 	iint->flags = 0UL;
 	if (iint->readcount != 0) {
-		printk(KERN_INFO "%s: readcount: %ld\n", __FUNCTION__,
-		       iint->readcount);
+		pr_info("%s: readcount: %ld\n", __func__, iint->readcount);
 		iint->readcount = 0;
 	}
 	if (iint->writecount != 0) {
-		printk(KERN_INFO "%s: writecount: %ld\n", __FUNCTION__,
-		       iint->writecount);
+		pr_info("%s: writecount: %ld\n", __func__, iint->writecount);
 		iint->writecount = 0;
 	}
 	if (iint->opencount != 0) {
-		printk(KERN_INFO "%s: opencount: %ld\n", __FUNCTION__,
-		       iint->opencount);
+		pr_info("%s: opencount: %ld\n", __func__, iint->opencount);
 		iint->opencount = 0;
 	}
 	kref_set(&iint->refcount, 1);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 101c512..1a47e2c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -55,11 +55,10 @@ void ima_file_free(struct file *file)
 
 	mutex_lock(&iint->mutex);
 	if (iint->opencount <= 0) {
-		printk(KERN_INFO
-		       "%s: %s open/free imbalance (r:%ld w:%ld o:%ld f:%ld)\n",
-		       __FUNCTION__, file->f_dentry->d_name.name,
-		       iint->readcount, iint->writecount,
-		       iint->opencount, atomic_long_read(&file->f_count));
+		pr_info("%s: %s open/free imbalance (r:%ld w:%ld o:%ld f:%ld)\n",
+			__func__, file->f_dentry->d_name.name,
+			iint->readcount, iint->writecount,
+			iint->opencount, atomic_long_read(&file->f_count));
 		if (!(iint->flags & IMA_IINT_DUMP_STACK)) {
 			dump_stack();
 			iint->flags |= IMA_IINT_DUMP_STACK; 
