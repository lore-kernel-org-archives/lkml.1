Return-Path: <linux-kernel-owner+w=401wt.eu-S1760075AbXKCByG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760075AbXKCByG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 21:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbXKCBxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 21:53:55 -0400
Received: from thunk.org ([69.25.196.29]:41034 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbXKCBxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 21:53:54 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH,RFC 1/3] Change CONFIG_LOCALVERSION_AUTO to use a git-describe-ish format
Date: Fri,  2 Nov 2007 21:52:59 -0400
Message-Id: <1194054781-16609-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.4.499.g1104e-dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the automatic local version to have the form -nnnnn-gSHA1SUMID,
where 'nnnnn' is the number of commits since the last tag (i.e.,
2.6.21-rc7).  This makes it much more likely that the package names created
for the kernel will look "newer" to a package manager.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 82e4993..20711f5 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -12,7 +12,7 @@ cd "${1:-.}" || usage
 if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	# Do we have an untagged version?
 	if git name-rev --tags HEAD | grep -E '^HEAD[[:space:]]+(.*~[0-9]*|undefined)$' > /dev/null; then
-		printf '%s%s' -g `echo "$head" | cut -c1-8`
+	        git-describe | awk -F- '{printf("-%05d-%s", $(NF-1),$(NF))}'
 	fi
 
 	# Are there uncommitted changes?
-- 
1.5.3.4.499.g1104e-dirty

