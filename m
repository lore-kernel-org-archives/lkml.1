Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbYCXBZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbYCXBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 21:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYCXBZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 21:25:48 -0400
Received: from mga10.intel.com ([192.55.52.92]:42955 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754992AbYCXBZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 21:25:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,544,1199692800"; 
   d="scan'208";a="538716177"
Subject: [PATCH] Add definitions of USHORT_MAX and others
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       mel@csn.ul.ie, mpm@selenic.com, linux-mm@kvack.org
In-Reply-To: <20080321152407.b0fbe81f.akpm@linux-foundation.org>
References: <20080317230516.078358225@sgi.com>
	 <20080317230528.279983034@sgi.com> <1205917757.10318.1.camel@ymzhang>
	 <Pine.LNX.4.64.0803191049450.29173@schroedinger.engr.sgi.com>
	 <1205983937.14496.24.camel@ymzhang>
	 <20080321152407.b0fbe81f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 24 Mar 2008 09:22:30 +0800
Message-Id: <1206321750.14496.126.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the new patch. Thanks for the comments.

---

Add definitions of USHORT_MAX and others into kernel. ipc uses it and
slub implementation might also use it.

The patch is against 2.6.25-rc6.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>

---

diff -Nraup linux-2.6.25-rc6/include/linux/kernel.h linux-2.6.25-rc6_maxshort/include/linux/kernel.h
--- linux-2.6.25-rc6/include/linux/kernel.h	2008-03-24 02:05:25.000000000 +0800
+++ linux-2.6.25-rc6_maxshort/include/linux/kernel.h	2008-03-24 02:07:27.000000000 +0800
@@ -20,6 +20,9 @@
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
+#define USHORT_MAX	((u16)(~0U))
+#define SHORT_MAX	((s16)(USHORT_MAX>>1))
+#define SHORT_MIN	(-SHORT_MAX - 1)
 #define INT_MAX		((int)(~0U>>1))
 #define INT_MIN		(-INT_MAX - 1)
 #define UINT_MAX	(~0U)
diff -Nraup linux-2.6.25-rc6/ipc/msg.c linux-2.6.25-rc6_maxshort/ipc/msg.c
--- linux-2.6.25-rc6/ipc/msg.c	2008-03-24 02:05:25.000000000 +0800
+++ linux-2.6.25-rc6_maxshort/ipc/msg.c	2008-03-24 02:07:27.000000000 +0800
@@ -324,19 +324,19 @@ copy_msqid_to_user(void __user *buf, str
 		out.msg_rtime		= in->msg_rtime;
 		out.msg_ctime		= in->msg_ctime;
 
-		if (in->msg_cbytes > USHRT_MAX)
-			out.msg_cbytes	= USHRT_MAX;
+		if (in->msg_cbytes > USHORT_MAX)
+			out.msg_cbytes	= USHORT_MAX;
 		else
 			out.msg_cbytes	= in->msg_cbytes;
 		out.msg_lcbytes		= in->msg_cbytes;
 
-		if (in->msg_qnum > USHRT_MAX)
-			out.msg_qnum	= USHRT_MAX;
+		if (in->msg_qnum > USHORT_MAX)
+			out.msg_qnum	= USHORT_MAX;
 		else
 			out.msg_qnum	= in->msg_qnum;
 
-		if (in->msg_qbytes > USHRT_MAX)
-			out.msg_qbytes	= USHRT_MAX;
+		if (in->msg_qbytes > USHORT_MAX)
+			out.msg_qbytes	= USHORT_MAX;
 		else
 			out.msg_qbytes	= in->msg_qbytes;
 		out.msg_lqbytes		= in->msg_qbytes;
diff -Nraup linux-2.6.25-rc6/ipc/util.c linux-2.6.25-rc6_maxshort/ipc/util.c
--- linux-2.6.25-rc6/ipc/util.c	2008-03-24 02:05:25.000000000 +0800
+++ linux-2.6.25-rc6_maxshort/ipc/util.c	2008-03-24 02:07:27.000000000 +0800
@@ -84,8 +84,8 @@ void ipc_init_ids(struct ipc_ids *ids)
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
-		if(seq_limit > USHRT_MAX)
-			ids->seq_max = USHRT_MAX;
+		if(seq_limit > USHORT_MAX)
+			ids->seq_max = USHORT_MAX;
 		 else
 		 	ids->seq_max = seq_limit;
 	}
diff -Nraup linux-2.6.25-rc6/ipc/util.h linux-2.6.25-rc6_maxshort/ipc/util.h
--- linux-2.6.25-rc6/ipc/util.h	2008-03-24 02:05:25.000000000 +0800
+++ linux-2.6.25-rc6_maxshort/ipc/util.h	2008-03-24 02:07:27.000000000 +0800
@@ -12,7 +12,6 @@
 
 #include <linux/err.h>
 
-#define USHRT_MAX 0xffff
 #define SEQ_MULTIPLIER	(IPCMNI)
 
 void sem_init (void);


