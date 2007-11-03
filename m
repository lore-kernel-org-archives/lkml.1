Return-Path: <linux-kernel-owner+w=401wt.eu-S1761895AbXKCByY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761895AbXKCByY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbXKCBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:53:56 -0400
Received: from thunk.org ([69.25.196.29]:41035 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611AbXKCBxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:53:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH,RFC 2/3] Fix scripts/setlocalversion to avoid erroneous -dirty tag
Date: Fri,  2 Nov 2007 21:53:00 -0400
Message-Id: <1194054781-16609-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.4.499.g1104e-dirty
In-Reply-To: <1194054781-16609-1-git-send-email-tytso@mit.edu>
References: <1194054781-16609-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If git's index file is out of date, and some files have been touched
such that their timestamp doesn't what is in the index, "git
diff-index HEAD" may show that a particular file is dirty, when in
fact it really isn't.  Running "git status" will update the index to
avoid these false positives.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 scripts/setlocalversion |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 20711f5..bfc8c8c 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -16,6 +16,7 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	fi
 
 	# Are there uncommitted changes?
+	git status >& /dev/null
 	if git diff-index HEAD | read dummy; then
 		printf '%s' -dirty
 	fi
-- 
1.5.3.4.499.g1104e-dirty

