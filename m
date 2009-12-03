Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZLCNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZLCNWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZLCNWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:22:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:32802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbZLCNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:22:17 -0500
Date: Thu, 3 Dec 2009 13:21:45 GMT
From: tip-bot for Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, arjan@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <200910090724.n997OQl6013538@imap1.linux-foundation.org>
References: <200910090724.n997OQl6013538@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] include/linux/compiler-gcc4.h: Fix build bug - gcc-4.0.2 doesn't understand __builtin_object_size
Message-ID: <tip-7cff7ce94a7df2ccf5ac76b48ee0995fee2060df@git.kernel.org>
Git-Commit-ID: 7cff7ce94a7df2ccf5ac76b48ee0995fee2060df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cff7ce94a7df2ccf5ac76b48ee0995fee2060df
Gitweb:     http://git.kernel.org/tip/7cff7ce94a7df2ccf5ac76b48ee0995fee2060df
Author:     Andrew Morton <akpm@linux-foundation.org>
AuthorDate: Fri, 9 Oct 2009 00:01:39 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 3 Dec 2009 07:29:17 +0100

include/linux/compiler-gcc4.h: Fix build bug - gcc-4.0.2 doesn't understand __builtin_object_size

Maybe 4.1.0 doesn't too, but this fixed it for me.

Caused by:

 4a31276: x86: Turn the copy_from_user check into an (optional) compile time warning
 9f0cf4a: x86: Use __builtin_object_size() to validate the buffer size for copy_from_user()

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
LKML-Reference: <200910090724.n997OQl6013538@imap1.linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler-gcc4.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 77542c5..e6ef279 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -38,7 +38,9 @@
 
 #endif
 
+#if __GNUC_MINOR__ > 0
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
 #if __GNUC_MINOR__ >= 4
 #define __compiletime_warning(message) __attribute__((warning(message)))
 #define __compiletime_error(message) __attribute__((error(message)))
