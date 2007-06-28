Return-Path: <linux-kernel-owner+w=401wt.eu-S1764365AbXF1QES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764365AbXF1QES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbXF1QEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 12:04:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:24644 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbXF1QEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 12:04:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,471,1175497200"; 
   d="scan'208";a="259977501"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch -mm] s390: struct bin_attribute changes
Date: Fri, 29 Jun 2007 00:04:04 +0800
Message-ID: <823A93EED437D048963A3697DB0E35DE16B700@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <20070628133904.GB4343@osiris.boeblingen.de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch -mm] s390: struct bin_attribute changes
Thread-Index: Ace5ibTFejOQ7eHQQzq7hiZQB6VeVAAEud0w
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Greg KH" <greg@kroah.com>, "Brown, Len" <len.brown@intel.com>
X-OriginalArrivalTime: 28 Jun 2007 16:04:07.0407 (UTC) FILETIME=[F4F54FF0:01C7B99D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oops. Sorry.
Thanks for fixing it.

Best regards,
Rui

-----Original Message-----
From: Heiko Carstens [mailto:heiko.carstens@de.ibm.com] 
Sent: 2007Äê6ÔÂ28ÈÕ 21:39
To: Andrew Morton
Cc: linux-kernel@vger.kernel.org; Martin Schwidefsky; Zhang, Rui; Greg KH; Brown, Len
Subject: [patch -mm] s390: struct bin_attribute changes

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
