Return-Path: <linux-kernel-owner+w=401wt.eu-S966691AbXG3RC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966691AbXG3RC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXG3RCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:02:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:22135 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025AbXG3RCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:02:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,199,1183359600"; 
   d="scan'208";a="111465981"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Fix ENOSYS undeclared errors from linux/pm.h
Date: Mon, 30 Jul 2007 10:02:47 -0700
Message-ID: <617E1C2C70743745A92448908E030B2A0209C217@scsmsx411.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix ENOSYS undeclared errors from linux/pm.h
Thread-Index: AcfSy3RSY07jDJE7ScO400pQ0g5Ekg==
From: "Luck, Tony" <tony.luck@intel.com>
To: "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Jul 2007 17:02:48.0942 (UTC) FILETIME=[752CE8E0:01C7D2CB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_SUSPEND=n I get build errors from at least a couple of
files because of the use of ENOSYS in the stub for pm_suspend().
Should those .c files be forced to include errno.h?  Or should we
have the include in pm.h?  Assuming the latter ...

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/include/linux/pm.h b/include/linux/pm.h
index e52f6f8..a90c020 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -23,6 +23,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/errno.h>
 #include <linux/list.h>
 #include <asm/atomic.h>
 
