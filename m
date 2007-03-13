Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXCMIjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXCMIjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 04:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXCMIjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 04:39:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbXCMIjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 04:39:48 -0400
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] avoid OPEN_MAX in SCM_MAX_FD
X-Windows: warn your friends about it.
Message-Id: <20070313083912.89D891801C5@magilla.sf.frob.com>
Date: Tue, 13 Mar 2007 01:39:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The OPEN_MAX constant is an arbitrary number with no useful relation to
anything.  Nothing should be using it.  This patch changes SCM_MAX_FD to
use NR_OPEN instead of OPEN_MAX.  This increases the size of the struct
scm_fp_list type fourfold, to make it big enough to contain as many file
descriptors as could be asked of it.  This size increase may not be very
worthwhile, but at any rate if an arbitrary limit unrelated to anything
else is being defined it should be done explicitly here with:

	#define SCM_MAX_FD	255

Using the OPEN_MAX constant here is just confusing and misleading.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/net/scm.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 5637d5e..4d37c5e 100644  
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -8,7 +8,7 @@
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
  */
-#define SCM_MAX_FD	(OPEN_MAX-1)
+#define SCM_MAX_FD	(NR_OPEN-1)
 
 struct scm_fp_list
 {
