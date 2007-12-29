Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXL2BNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXL2BNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXL2BNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:13:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:28847 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXL2BNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=UW7A7a+GSDc9baHEHPmpNvWSerTCG9TN8JaX5J0fCTtiZGx/0Su5g0fOaHL5XDuHpF6sGkEfs90Ib2+Cx/mA78LDp9L5o701SADfF/QatZXOaGncYdwCvPyrhLjnaW47RuaIcWfcWTh07M4oXalGmKCKnwp1zSnXUcjHl17bFbc=
Date: Sat, 29 Dec 2007 09:17:07 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 10/12] scsi : Use mutex instead of semaphore in driver core
Message-ID: <20071229011707.GK2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
