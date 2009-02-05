Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbZBEILw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbZBEILw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 03:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbZBEILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 03:11:40 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:62554 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920AbZBEILk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 03:11:40 -0500
X-IronPort-AV: E=Sophos;i="4.37,384,1231131600"; 
   d="scan'208";a="82345939"
From: Bryan Wu <cooloney@kernel.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] scripts/setlocalversion: shorten the make time when using svn
Date: Thu,  5 Feb 2009 16:13:32 +0800
Message-Id: <1233821612-9548-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

Don't bother doing `svn st` as it takes a retarded amount of time when
the source is cold

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 scripts/setlocalversion |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index f6946cf..f1c4b35 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -58,14 +58,7 @@ fi
 # Check for svn and a svn repo.
 if rev=`svn info 2>/dev/null | grep '^Last Changed Rev'`; then
 	rev=`echo $rev | awk '{print $NF}'`
-	changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l`
-
-	# Are there uncommitted changes?
-	if [ $changes != 0 ]; then
-		printf -- '-svn%s%s' "$rev" -dirty
-	else
-		printf -- '-svn%s' "$rev"
-	fi
+	printf -- '-svn%s' "$rev"
 
 	# All done with svn
 	exit
-- 
1.5.6.3
