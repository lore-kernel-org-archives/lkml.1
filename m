Return-Path: <linux-kernel-owner+w=401wt.eu-S935861AbXGLBBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935861AbXGLBBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761823AbXGLBBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:01:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761779AbXGLBBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:01:45 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove CHILD_MAX
Message-Id: <20070712010110.120F14D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 18:01:10 -0700 (PDT)
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
