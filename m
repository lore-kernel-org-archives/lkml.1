Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbYJYVoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbYJYVoE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 17:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYJYVny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 17:43:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:51196 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbYJYVny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 17:43:54 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] setlocalversion: dont include svn change count
Date: Sat, 25 Oct 2008 17:43:50 -0400
Message-Id: <1224971030-4280-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of pending changes is pretty useless, so encoding it into the
version is just annoying by the constant shuffle in corresponding modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 83b7512..453faff 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -55,7 +55,7 @@ if rev=`svn info 2>/dev/null | grep '^Revision'`; then
 
 	# Are there uncommitted changes?
 	if [ $changes != 0 ]; then
-		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+		printf -- '-svn%s%s' "$rev" -dirty
 	else
 		printf -- '-svn%s' "$rev"
 	fi
-- 
1.6.0.2

