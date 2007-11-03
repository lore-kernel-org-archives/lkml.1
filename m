Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbXKCByi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbXKCByi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXKCBx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:53:57 -0400
Received: from thunk.org ([69.25.196.29]:41036 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbXKCBxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:53:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH,RFC 3/3] scripts/setlocalversion: Fix false positive -dirty tag caused by make-kpkg
Date: Fri,  2 Nov 2007 21:53:01 -0400
Message-Id: <1194054781-16609-3-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.4.499.g1104e-dirty
In-Reply-To: <1194054781-16609-2-git-send-email-tytso@mit.edu>
References: <1194054781-16609-1-git-send-email-tytso@mit.edu>
 <1194054781-16609-2-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make-kpkg modifies scripts/package/Makefile and deletes
scripts/package/builddeb as part of its build process.  Ignore these
changes so the tree isn't marked as -dirty, when it is just an
artifact of make-kpkg.  (make-kpkg clean restores the files to their
original state, and these helper scripts won't affect the final
compiled kernel in any way.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 scripts/setlocalversion |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index bfc8c8c..ad56a06 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -17,7 +17,8 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 
 	# Are there uncommitted changes?
 	git status >& /dev/null
-	if git diff-index HEAD | read dummy; then
+	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
+	    | read dummy; then
 		printf '%s' -dirty
 	fi
 fi
-- 
1.5.3.4.499.g1104e-dirty

