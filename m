Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZCEQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZCEQmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 11:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZCEQjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 11:39:33 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47132 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbZCEQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 11:39:32 -0500
Subject: [RFC][PATCH 10/11] add checkpoint/restart compile helper
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 05 Mar 2009 08:39:12 -0800
References: <20090305163857.0C18F3FD@kernel>
In-Reply-To: <20090305163857.0C18F3FD@kernel>
Message-Id: <20090305163912.3A8363E9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is to aid the compiler a little bit so that we
don't have to add as many #ifdefs.  Gets used in the
next patch.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/include/linux/checkpoint.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN include/linux/checkpoint.h~cr-compile-helper include/linux/checkpoint.h
--- linux-2.6.git/include/linux/checkpoint.h~cr-compile-helper	2009-03-05 08:37:04.000000000 -0800
+++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-03-05 08:37:04.000000000 -0800
@@ -115,6 +115,10 @@ static inline void __files_deny_checkpoi
 
 int cr_explain_file(struct file *file, char *explain, int left);
 int cr_file_supported(struct file *file);
+static inline int cr_enabled(void)
+{
+	return 1;
+}
 
 #else /* !CONFIG_CHECKPOINT_RESTART */
 
@@ -128,6 +132,13 @@ static inline int cr_file_supported(stru
 {
 	return 0;
 }
+/*
+ * Use this when you can in lieu of an #ifdef
+ */
+static inline int cr_enabled(void)
+{
+	return 0;
+}
 
 #endif /* CONFIG_CHECKPOINT_RESTART */
 #endif /* _CHECKPOINT_CKPT_H_ */
_
