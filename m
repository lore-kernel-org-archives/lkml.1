Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbYCUBmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbYCUBmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYCUBl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:41:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:40118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbYCUBl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,534,1199692800"; 
   d="scan'208";a="308055437"
Subject: [PATCH] Add definitions of USHRT_MAX
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 21 Mar 2008 09:40:14 +0800
Message-Id: <1206063614.14496.72.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definitions of USHRT_MAX and others into kernel. ipc uses it and
slub implementation might also use it.

The patch is against 2.6.25-rc6.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>

---

--- linux-2.6.25-rc6/include/linux/kernel.h	2008-03-20 04:25:46.000000000 +0800
+++ linux-2.6.25-rc6_work/include/linux/kernel.h	2008-03-20 04:17:45.000000000 +0800
@@ -20,6 +20,9 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define USHRT_MAX	((u16)(~0U))
+#define SHRT_MAX	((s16)(USHRT_MAX>>1))
+#define SHRT_MIN	(-SHRT_MAX - 1)
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
--- linux-2.6.25-rc6/ipc/util.h	2008-03-20 04:25:46.000000000 +0800
+++ linux-2.6.25-rc6_work/ipc/util.h	2008-03-20 04:22:07.000000000 +0800
@@ -12,7 +12,6 @@
 
 #include <linux/err.h>
 
-#define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
 
 void sem_init (void);


