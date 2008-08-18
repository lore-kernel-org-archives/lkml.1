Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYHRGzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYHRGzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYHRGzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:55:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39613 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYHRGzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:55:39 -0400
From: "Andi Kleen" <andi@firstfloor.org>
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
       David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix security.h compilation with !CONFIG_SECURITY
Date: Mon, 18 Aug 2008 08:55:37 +0200
Message-Id: <1219042537-13839-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This recent patch

commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40
Author: David Howells <dhowells@redhat.com>
Date:   Thu Aug 14 11:37:28 2008 +0100

    security: Fix setting of PF_SUPERPRIV by __capable()

broke compilation with !CONFIG_SECURITY:

linux/include/linux/security.h: In function 'security_ptrace_traceme':
linux/include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)

Add the obvious fix.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 2ee5ecf..0cc23a1 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1757,7 +1757,7 @@ static inline int security_ptrace_may_access(struct task_struct *child,
 
 static inline int security_ptrace_traceme(struct task_struct *child)
 {
-	return cap_ptrace_traceme(parent);
+	return cap_ptrace_traceme(child);
 }
 
 static inline int security_capget(struct task_struct *target,
-- 
1.5.6

