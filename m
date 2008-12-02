Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYLBU6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYLBU6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbYLBU6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:58:12 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:48313 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYLBU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :sender;
        b=m8KJ3Q8WynO9+7DbCwx1RFNOnJuuouZWmOHK/+QF6k67Ncg6gSBk+DLj79Qn4lPNCO
         C6GvAAmBWl7McIonzn7uURpOiCGBiuAkMWkS4VK1ZyxopS/MjNP6wdkTgS0GkEGt5EMO
         yX7Y8lthxfFBtg0TTlq493OWKHEaAmQyegzKI=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] setlocalversion: add git-svn support
Date: Tue,  2 Dec 2008 21:58:06 +0100
Message-Id: <1228251486-29275-2-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1228251486-29275-1-git-send-email-jacmet@sunsite.dk>
References: <1228251486-29275-1-git-send-email-jacmet@sunsite.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print svn revision in addition to git info on git-svn repos.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 scripts/setlocalversion |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 81d984b..f6946cf 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -19,6 +19,11 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 		fi
 	fi
 
+	# Is this git on svn?
+	if git config --get svn-remote.svn.url >/dev/null; then
+	        printf -- '-svn%s' "`git-svn find-rev $head`"
+	fi
+
 	# Are there uncommitted changes?
 	git update-index --refresh --unmerged > /dev/null
 	if git diff-index --name-only HEAD | grep -v "^scripts/package" \
-- 
1.5.6.5

