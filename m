Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbXF1NjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbXF1NjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXF1NjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:39:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:16558 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbXF1NjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:39:07 -0400
Date: Thu, 28 Jun 2007 15:39:04 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Zhang Rui <rui.zhang@intel.com>, Greg KH <greg@kroah.com>,
       Len Brown <len.brown@intel.com>
Subject: [patch -mm] s390: struct bin_attribute changes
Message-ID: <20070628133904.GB4343@osiris.boeblingen.de.ibm.com>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

git-acpi contains a patch that adds 'struct bin_attribute *' to
the read method of struct bin_attribute. This breaks s390:

  CC      arch/s390/kernel/ipl.o
arch/s390/kernel/ipl.c:317:
 warning: initialization from incompatible pointer type
arch/s390/kernel/ipl.c:340:
  warning: initialization from incompatible pointer type

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/ipl.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.22-rc6-mm1/arch/s390/kernel/ipl.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/arch/s390/kernel/ipl.c
+++ linux-2.6.22-rc6-mm1/arch/s390/kernel/ipl.c
@@ -295,8 +295,9 @@ static ssize_t sys_ipl_device_show(struc
 static struct subsys_attribute sys_ipl_device_attr =
 	__ATTR(device, S_IRUGO, sys_ipl_device_show, NULL);
 
-static ssize_t ipl_parameter_read(struct kobject *kobj, char *buf, loff_t off,
-				  size_t count)
+static ssize_t ipl_parameter_read(struct kobject *kobj,
+				  struct bin_attribute *attr,
+				  char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_SIZE;
 
@@ -317,8 +318,9 @@ static struct bin_attribute ipl_paramete
 	.read = &ipl_parameter_read,
 };
 
-static ssize_t ipl_scp_data_read(struct kobject *kobj, char *buf, loff_t off,
-	size_t count)
+static ssize_t ipl_scp_data_read(struct kobject *kobj,
+				 struct bin_attribute *attr,
+				 char *buf, loff_t off, size_t count)
 {
 	unsigned int size = IPL_PARMBLOCK_START->ipl_info.fcp.scp_data_len;
 	void *scp_data = &IPL_PARMBLOCK_START->ipl_info.fcp.scp_data;
