Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbXCWUAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbXCWUAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 16:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934166AbXCWUAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 16:00:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57277 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934154AbXCWUAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 16:00:42 -0400
Date: Fri, 23 Mar 2007 15:00:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] utsns: fix !CONFIG_UTS_NS behavior
Message-ID: <20070323200039.GA15775@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] utsns: fix !CONFIG_UTS_NS behavior

When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
not unshare a new uts namespace, but also does not return -EINVAL.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/utsname.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

bc350994ac67df8f1b917f9979c065d87757eabe
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index a4555fe..e10267d 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -70,6 +70,8 @@ static inline int unshare_utsname(unsign
 
 static inline int copy_utsname(int flags, struct task_struct *tsk)
 {
+	if (flags & CLONE_NEWUTS)
+		return -EINVAL;
 	return 0;
 }
 static inline void put_uts_ns(struct uts_namespace *ns)
-- 
1.1.6
