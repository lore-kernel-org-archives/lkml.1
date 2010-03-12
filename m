Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab0CLNqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:46:13 -0500
Received: from smtp.nokia.com ([192.100.105.134]:53280 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0CLNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:46:11 -0500
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ext-phil.2.carmody@nokia.com,
       ext-jani.1.nikula@nokia.com
Subject: [PATCH] err.h: add __must_check to error pointer handlers
Date: Fri, 12 Mar 2010 15:45:40 +0200
Message-Id: <1268401540-8994-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.5.2
X-OriginalArrivalTime: 12 Mar 2010 13:45:46.0578 (UTC) FILETIME=[51685320:01CAC1EA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __must_check to error pointer handlers to have the compiler warn
about mistakes like:

	if (err)
		ERR_PTR(err);

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 include/linux/err.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/err.h b/include/linux/err.h
index 1b12642..448afc1 100644
--- a/include/linux/err.h
+++ b/include/linux/err.h
@@ -19,22 +19,22 @@
 
 #define IS_ERR_VALUE(x) unlikely((x) >= (unsigned long)-MAX_ERRNO)
 
-static inline void *ERR_PTR(long error)
+static inline void * __must_check ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
-static inline long PTR_ERR(const void *ptr)
+static inline long __must_check PTR_ERR(const void *ptr)
 {
 	return (long) ptr;
 }
 
-static inline long IS_ERR(const void *ptr)
+static inline long __must_check IS_ERR(const void *ptr)
 {
 	return IS_ERR_VALUE((unsigned long)ptr);
 }
 
-static inline long IS_ERR_OR_NULL(const void *ptr)
+static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 {
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
@@ -46,7 +46,7 @@ static inline long IS_ERR_OR_NULL(const void *ptr)
  * Explicitly cast an error-valued pointer to another pointer type in such a
  * way as to make it clear that's what's going on.
  */
-static inline void *ERR_CAST(const void *ptr)
+static inline void * __must_check ERR_CAST(const void *ptr)
 {
 	/* cast away the const */
 	return (void *) ptr;
-- 
1.6.5.2

