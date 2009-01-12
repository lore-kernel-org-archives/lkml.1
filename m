Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZALG5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZALG5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZALG4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:56:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:50903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbZALG4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:56:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,251,1231142400"; 
   d="scan'208";a="656306332"
Subject: [PATCH 1/3]synchronize device shutdown
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:56:39 +0800
Message-Id: <1231743399.5867.50.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize all tasks submitted by .shutdown

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/base/core.c
===================================================================
--- linux.orig/drivers/base/core.c	2009-01-12 14:39:07.000000000 +0800
+++ linux/drivers/base/core.c	2009-01-12 14:40:45.000000000 +0800
@@ -22,6 +22,7 @@
 #include <linux/kallsyms.h>
 #include <linux/semaphore.h>
 #include <linux/mutex.h>
+#include <linux/async.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -1618,4 +1619,5 @@ void device_shutdown(void)
 	kobject_put(sysfs_dev_char_kobj);
 	kobject_put(sysfs_dev_block_kobj);
 	kobject_put(dev_kobj);
+	async_synchronize_full();
 }


