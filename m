Return-Path: <linux-kernel-owner+w=401wt.eu-S937392AbXGLA7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937392AbXGLA7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757756AbXGLA7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:59:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576AbXGLA7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:59:02 -0400
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] avoid OPEN_MAX in SCM_MAX_FD
X-Shopping-List: (1) Diplomatic hydrants
   (2) Apocalyptic sycophant secretions
   (3) Dormant caves
   (4) Intolerant polemical furniture
Message-Id: <20070712005825.EC42A4D0555@magilla.localdomain>
Date: Wed, 11 Jul 2007 17:58:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The OPEN_MAX constant is an arbitrary number with no useful relation to
anything.  Nothing should be using it.  SCM_MAX_FD is just an arbitrary
constant and it should be clear that its value is chosen in net/scm.h
and not actually derived from anything else meaningful in the system.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/net/scm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 5637d5e..423cb1d 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -8,7 +8,7 @@
 /* Well, we should have at least one descriptor open
  * to accept passed FDs 8)
  */
-#define SCM_MAX_FD	(OPEN_MAX-1)
+#define SCM_MAX_FD	255
 
 struct scm_fp_list
 {
