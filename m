Return-Path: <linux-kernel-owner+w=401wt.eu-S1760021AbYACF5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021AbYACF5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 00:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754364AbYACF50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 00:57:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50840 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbYACF50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 00:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jdKvmWLRD17Oyp3Beh6Av7PK/IDGPi/ZWdhLGKV19gP4VrbXXD2IiUoOo/VCAf+0eWZ5wToAsu9i0Pf3OfrhAF7+G8Lb3wpGJV5VXNCSdpGFDEIaPkgsPkt4fEL8rEHFZyXPkyPGyYZL+WlUrnxh/TgP9bfecIo0WYTWoB4DWjQ=
Date: Thu, 3 Jan 2008 14:01:00 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 6/7] scsi : convert semaphore to mutex in struct class
Message-ID: <20080103060100.GG4885@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex instead of semaphore in struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
---
drivers/scsi/hosts.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -upr linux/drivers/scsi/hosts.c linux.new/drivers/scsi/hosts.c
--- linux/drivers/scsi/hosts.c	2007-12-28 10:45:46.000000000 +0800
+++ linux.new/drivers/scsi/hosts.c	2007-12-28 10:46:19.000000000 +0800
@@ -441,7 +441,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	down(&class->sem);
+	mutex_lock(&class->mutex);
 	list_for_each_entry(cdev, &class->children, node) {
 		p = class_to_shost(cdev);
 		if (p->host_no == hostnum) {
@@ -449,7 +449,7 @@ struct Scsi_Host *scsi_host_lookup(unsig
 			break;
 		}
 	}
-	up(&class->sem);
+	mutex_unlock(&class->mutex);
 
 	return shost;
 }
