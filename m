Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZIOBAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZIOBAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 21:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZIOBAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 21:00:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756475AbZIOBAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 21:00:20 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] SELinux: inline selinux_is_enabled in !CONFIG_SECURITY_SELINUX
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: torvalds@linux-foundation.org, jmorris@namei.org, sds@tycho.nsa.gov
Date: Mon, 14 Sep 2009 20:59:48 -0400
Message-ID: <20090915005948.12692.40854.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch building a kernel emits millions of warning like:

include/linux/selinux.h:92: warning: ‘selinux_is_enabled’ defined but not used

When it is build without CONFIG_SECURITY_SELINUX.  This is harmless, but
the function should be inlined, so it gets compiled out.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/selinux.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/selinux.h b/include/linux/selinux.h
index 223d06a..82e0f26 100644
--- a/include/linux/selinux.h
+++ b/include/linux/selinux.h
@@ -89,7 +89,7 @@ static inline void selinux_secmark_refcount_dec(void)
 	return;
 }
 
-static bool selinux_is_enabled(void)
+static inline bool selinux_is_enabled(void)
 {
 	return false;
 }

