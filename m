Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbXF3DP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbXF3DP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXF3DPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:15:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:65330 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXF3DPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Bk4VDXWeL6f2KAbiu/WXqUDwW9v2bxZZapfpC+0cU5y2GBIu2rH25ywN35EVJQc5+tkAII9UKs5Kyd3nvPJCmNaHxZK2AkIAW7QuPJ279nBoBxgKPZPfroLyOvi99CF2JsoYdCPdiieMg7DxlpVfcxlCUb0OK2XRx3fxrtKszRs=
Date: Sat, 30 Jun 2007 12:06:04 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] void unregister_chrdev - make void
Message-ID: <20070630030604.GB4045@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20070630030516.GA4045@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630030516.GA4045@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

unregister_chrdev() does not return meaningful value.
This patch makes it return void like most of unregister_* functions.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/char_dev.c      |    3 +--
 include/linux/fs.h |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

Index: 2.6-mm/fs/char_dev.c
===================================================================
--- 2.6-mm.orig/fs/char_dev.c
+++ 2.6-mm/fs/char_dev.c
@@ -321,14 +321,13 @@ void unregister_chrdev_region(dev_t from
 	}
 }
 
-int unregister_chrdev(unsigned int major, const char *name)
+void unregister_chrdev(unsigned int major, const char *name)
 {
 	struct char_device_struct *cd;
 	cd = __unregister_chrdev_region(major, 0, 256);
 	if (cd && cd->cdev)
 		cdev_del(cd->cdev);
 	kfree(cd);
-	return 0;
 }
 
 static DEFINE_SPINLOCK(cdev_lock);
Index: 2.6-mm/include/linux/fs.h
===================================================================
--- 2.6-mm.orig/include/linux/fs.h
+++ 2.6-mm/include/linux/fs.h
@@ -1593,7 +1593,7 @@ extern int alloc_chrdev_region(dev_t *, 
 extern int register_chrdev_region(dev_t, unsigned, const char *);
 extern int register_chrdev(unsigned int, const char *,
 			   const struct file_operations *);
-extern int unregister_chrdev(unsigned int, const char *);
+extern void unregister_chrdev(unsigned int, const char *);
 extern void unregister_chrdev_region(dev_t, unsigned);
 extern int chrdev_open(struct inode *, struct file *);
 extern void chrdev_show(struct seq_file *,off_t);
