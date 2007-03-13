Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXCMInF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXCMInF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXCMInF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:43:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbXCMInE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:43:04 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH] Remove CHILD_MAX
Emacs: where editing text is like playing Paganini on a glass harmonica.
Message-Id: <20070313084229.B31FA1801C5@magilla.sf.frob.com>
Date: Tue, 13 Mar 2007 01:42:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The CHILD_MAX macro in limits.h should not be there.  It claims to be the
limit on processes a user can own, but its value is wrong for that.
There is no constant value, but a variable resource limit (RLIMIT_NPROC).
Nothing in the kernel uses CHILD_MAX.

The proper thing to do according to POSIX is not to define CHILD_MAX at all.
The sysconf (_SC_CHILD_MAX) implementation works by calling getrlimit.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/limits.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/limits.h b/include/linux/limits.h
index c4b4e57..2d0f941 100644  
--- a/include/linux/limits.h
+++ b/include/linux/limits.h
@@ -5,7 +5,6 @@
 
 #define NGROUPS_MAX    65536	/* supplemental group IDs are available */
 #define ARG_MAX       131072	/* # bytes of args + environ for exec() */
-#define CHILD_MAX        999    /* no limit :-) */
 #define LINK_MAX         127	/* # links a file may have */
 #define MAX_CANON        255	/* size of the canonical input queue */
 #define MAX_INPUT        255	/* size of the type-ahead buffer */
