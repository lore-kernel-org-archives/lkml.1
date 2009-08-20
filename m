Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZHTKuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZHTKuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbZHTKuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZHTKuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:50:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] Use the cut_here() function in AFS, CacheFiles,
	FS-Cache and RxRPC
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 20 Aug 2009 11:50:02 +0100
Message-ID: <20090820105001.29972.33221.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk>
References: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the cut_here() function in AFS, CacheFiles, FS-Cache and RxRPC to put
pertinent extra information between the "cut here" line and the BUG report.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/internal.h        |   11 ++++++-----
 fs/cachefiles/internal.h |    9 +++++----
 fs/fscache/internal.h    |    9 +++++----
 net/rxrpc/ar-internal.h  |    4 ++++
 4 files changed, 20 insertions(+), 13 deletions(-)


diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 106be66..59049b0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -18,6 +18,7 @@
 #include <linux/key.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 
 #include "afs.h"
 #include "afs_vl.h"
@@ -803,7 +804,7 @@ do {							\
 #define ASSERT(X)						\
 do {								\
 	if (unlikely(!(X))) {					\
-		printk(KERN_ERR "\n");				\
+		cut_here();					\
 		printk(KERN_ERR "AFS: Assertion failed\n");	\
 		BUG();						\
 	}							\
@@ -812,7 +813,7 @@ do {								\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "AFS: Assertion failed\n");		\
 		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
@@ -825,7 +826,7 @@ do {									\
 #define ASSERTRANGE(L, OP1, N, OP2, H)					\
 do {									\
 	if (unlikely(!((L) OP1 (N)) || !((N) OP2 (H)))) {		\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "AFS: Assertion failed\n");		\
 		printk(KERN_ERR "%lu "#OP1" %lu "#OP2" %lu is false\n",	\
 		       (unsigned long)(L), (unsigned long)(N),		\
@@ -840,7 +841,7 @@ do {									\
 #define ASSERTIF(C, X)						\
 do {								\
 	if (unlikely((C) && !(X))) {				\
-		printk(KERN_ERR "\n");				\
+		cut_here();					\
 		printk(KERN_ERR "AFS: Assertion failed\n");	\
 		BUG();						\
 	}							\
@@ -849,7 +850,7 @@ do {								\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "AFS: Assertion failed\n");		\
 		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index f7c255f..96007a7 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -14,6 +14,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/bug.h>
 
 struct cachefiles_cache;
 struct cachefiles_object;
@@ -313,7 +314,7 @@ do {							\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
 		BUG();							\
 	}								\
@@ -322,7 +323,7 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
 		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
@@ -333,7 +334,7 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
 		BUG();							\
 	}								\
@@ -342,7 +343,7 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "CacheFiles: Assertion failed\n");	\
 		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 1c34130..c969199 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -23,6 +23,7 @@
 
 #include <linux/fscache-cache.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 
 #define FSCACHE_MIN_THREADS	4
 #define FSCACHE_MAX_THREADS	32
@@ -333,7 +334,7 @@ do {						\
 #define ASSERT(X)							\
 do {									\
 	if (unlikely(!(X))) {						\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
 		BUG();							\
 	}								\
@@ -342,7 +343,7 @@ do {									\
 #define ASSERTCMP(X, OP, Y)						\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
 		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
@@ -353,7 +354,7 @@ do {									\
 #define ASSERTIF(C, X)							\
 do {									\
 	if (unlikely((C) && !(X))) {					\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
 		BUG();							\
 	}								\
@@ -362,7 +363,7 @@ do {									\
 #define ASSERTIFCMP(C, X, OP, Y)					\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
-		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "FS-Cache: Assertion failed\n");	\
 		printk(KERN_ERR "%lx " #OP " %lx is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index 3e7318c..de6a21b 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -687,6 +687,7 @@ do {							\
 do {								\
 	if (unlikely(!(X))) {					\
 		printk(KERN_ERR "\n");				\
+		cut_here();					\
 		printk(KERN_ERR "RxRPC: Assertion failed\n");	\
 		BUG();						\
 	}							\
@@ -696,6 +697,7 @@ do {								\
 do {									\
 	if (unlikely(!((X) OP (Y)))) {					\
 		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "RxRPC: Assertion failed\n");		\
 		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\
@@ -709,6 +711,7 @@ do {									\
 do {								\
 	if (unlikely((C) && !(X))) {				\
 		printk(KERN_ERR "\n");				\
+		cut_here();					\
 		printk(KERN_ERR "RxRPC: Assertion failed\n");	\
 		BUG();						\
 	}							\
@@ -718,6 +721,7 @@ do {								\
 do {									\
 	if (unlikely((C) && !((X) OP (Y)))) {				\
 		printk(KERN_ERR "\n");					\
+		cut_here();						\
 		printk(KERN_ERR "RxRPC: Assertion failed\n");		\
 		printk(KERN_ERR "%lu " #OP " %lu is false\n",		\
 		       (unsigned long)(X), (unsigned long)(Y));		\

