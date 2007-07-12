Return-Path: <linux-kernel-owner+w=401wt.eu-S937844AbXGLBAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937844AbXGLBAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934425AbXGLA7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:59:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937761AbXGLA7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:59:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove OPEN_MAX
X-Windows: power tools for power fools.
Message-Id: <20070712005914.CA51C4D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 17:59:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The OPEN_MAX macro in limits.h should not be there.  It claims to be the
limit on file descriptors in a process, but its value is wrong for that.
There is no constant value, but a variable resource limit (RLIMIT_NOFILE).
Nothing in the kernel uses OPEN_MAX except things that are wrong to do so.
I've submitted other patches to remove those uses.

The proper thing to do according to POSIX is not to define OPEN_MAX at all.
The sysconf (_SC_OPEN_MAX) implementation works by calling getrlimit.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/limits.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/limits.h b/include/linux/limits.h
index eaf2e09..c4b4e57 100644
--- a/include/linux/limits.h
+++ b/include/linux/limits.h
@@ -6,7 +6,6 @@
 #define NGROUPS_MAX    65536	/* supplemental group IDs are available */
 #define ARG_MAX       131072	/* # bytes of args + environ for exec() */
 #define CHILD_MAX        999    /* no limit :-) */
-#define OPEN_MAX         256	/* # open files a process may have */
 #define LINK_MAX         127	/* # links a file may have */
 #define MAX_CANON        255	/* size of the canonical input queue */
 #define MAX_INPUT        255	/* size of the type-ahead buffer */
