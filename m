Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXKMPXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXKMPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXKMPXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:23:08 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:56557 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbXKMPXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:23:05 -0500
Date: Tue, 13 Nov 2007 20:52:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       apw@shadowen.org
Subject: Re: mm snapshot broken-out-2007-11-13-04-14 Build Fails due kobject cleanup (Resend)
Message-ID: <20071113152229.GB32528@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails, with the build error

drivers/pci/hotplug/rpadlpar_sysfs.c:28: warning: ˜struct kobjet declared inside parameter list
drivers/pci/hotplug/rpadlpar_sysfs.c:28: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/pci/hotplug/rpadlpar_sysfs.c:59: warning: ˜struct kobjet declared inside parameter list
drivers/pci/hotplug/rpadlpar_sysfs.c: In function ˜remove_slot_store: 
drivers/pci/hotplug/rpadlpar_sysfs.c:79: error: expected ˜; before ˜return
drivers/pci/hotplug/rpadlpar_sysfs.c: At top level:
drivers/pci/hotplug/rpadlpar_sysfs.c:89: warning: initialization from incompatible pointer type
drivers/pci/hotplug/rpadlpar_sysfs.c:92: warning: initialization from incompatible pointer type
drivers/pci/hotplug/rpadlpar_sysfs.c: In function ˜remove_slot_store:
drivers/pci/hotplug/rpadlpar_sysfs.c:80: warning: control reaches end of non-void function
make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
make[2]: *** [drivers/pci/hotplug] Error 2
make[1]: *** [drivers/pci] Error 2
make: *** [drivers] Error 2

This is caused by the patch
gregkh-driver-kobject-clean-up-rpadlpar-horrid-sysfs-abuse.patch.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.24-rc2/drivers/pci/hotplug/rpadlpar_sysfs.c	2007-11-13 19:42:26.000000000 +0530
+++ linux-2.6.24-rc2/drivers/pci/hotplug/~rpadlpar_sysfs.c	2007-11-13 20:29:09.000000000 +0530
@@ -54,7 +54,7 @@ static ssize_t add_slot_show(struct kobj
 	return sprintf(buf, "0\n");
 }
 
-static ssize_t remove_slot_store(struct kobjet *kobj,
+static ssize_t remove_slot_store(struct kobject *kobj,
 				 struct kobj_attribute *attr,
 				 const char *buf, size_t nbytes)
 {
@@ -74,7 +74,7 @@ static ssize_t remove_slot_store(struct 
 
 	rc = dlpar_remove_slot(drc_name);
 	if (rc)
-		return rc
+		return rc;
 
 	return nbytes;
 }

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
