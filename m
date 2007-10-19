Return-Path: <linux-kernel-owner+w=401wt.eu-S936700AbXJSUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936700AbXJSUh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760594AbXJSUhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:37:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50646 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936080AbXJSUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:37:03 -0400
Date: Fri, 19 Oct 2007 15:36:58 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <morgan@kernel.org>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH RFC] capabilities: remove STRICT_CAP_T_TYPECHECKS
Message-ID: <20071019203658.GA6838@sergelap.austin.ibm.com>
References: <20071019203527.GA23716@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071019203527.GA23716@sergelap.austin.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> From cd7c384f76d2c0f6b12a1c0936d54ae9c5e7cb4c Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Fri, 19 Oct 2007 15:39:10 -0400
> Subject: [PATCH RFC] capabilities: fix compilation with strict type checking (v2)
> 
> Since at least 1998 the code under STRICT_CAP_T_TYPECHECKS option has
> not been used.  (See
> http://www.uwsg.iu.edu/hypermail/linux/kernel/9810.2/0705.html)
> 
> There are two options - we can remove this option altogether
> or, as this patch attempts to do, fix compilation with
> STRICT_CAP_T_TYPECHECKS so it can be enabled.

Here is the second alternative, simply removing the
STRICT_CAP_T_TYPECHECKS option.

thanks,
-serge

>From 141626df6eaba12f5566f6bce7e72c1c3e627364 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 17 Oct 2007 10:00:49 -0400
Subject: [PATCH 1/1] capabilities: remove STRICT_CAP_T_TYPECHECKS

It appears STRICT_CAP_T_TYPECHECKS was introduced in 1998 - and
always undefined since then - because the STRICT_CAP_T_TYPECHECKS
behavior is broken.  (See http://www.uwsg.iu.edu/hypermail/linux/kernel/9810.2/0705.html)

Remove this code to simplify the capabilites code.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7a8d7ad..8f7c7ed 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -64,20 +64,8 @@ struct vfs_cap_data {
 
 #ifdef __KERNEL__
 
-/* #define STRICT_CAP_T_TYPECHECKS */
-
-#ifdef STRICT_CAP_T_TYPECHECKS
-
-typedef struct kernel_cap_struct {
-	__u32 cap;
-} kernel_cap_t;
-
-#else
-
 typedef __u32 kernel_cap_t;
 
-#endif
-
 #define _USER_CAP_HEADER_SIZE  (2*sizeof(__u32))
 #define _KERNEL_CAP_T_SIZE     (sizeof(kernel_cap_t))
 
@@ -315,18 +303,9 @@ typedef __u32 kernel_cap_t;
  * Internal kernel functions only
  */
 
-#ifdef STRICT_CAP_T_TYPECHECKS
-
-#define to_cap_t(x) { x }
-#define cap_t(x) (x).cap
-
-#else
-
 #define to_cap_t(x) (x)
 #define cap_t(x) (x)
 
-#endif
-
 #define CAP_EMPTY_SET       to_cap_t(0)
 #define CAP_FULL_SET        to_cap_t(~0)
 #define CAP_INIT_EFF_SET    to_cap_t(~0 & ~CAP_TO_MASK(CAP_SETPCAP))
-- 
1.5.1.1.GIT

