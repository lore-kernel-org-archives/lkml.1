Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYLBU6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYLBU6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYLBU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:58:11 -0500
Received: from ik-out-1112.google.com ([66.249.90.181]:46446 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYLBU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=OWOZSQoL0NcdeWvx5SHuQquvQEk96DGO7/kp9Uc4VJMXlUuzXV/NG60aHeFJ8A2hwd
         MFI1xFZMcqhYkrc05VYdueE6amFC9mSmtmnWvy7Hn/I2MFzVSRc9bpQA90BIt/0k9sRB
         tK/gg7dXg30rqjUHYxApu1s/LZcOkRO8fHYN0=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] setlocalversion: print correct subversion revision
Date: Tue,  2 Dec 2008 21:58:05 +0100
Message-Id: <1228251486-29275-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Output svn revision of latest change, instead of repo revision as thats
what we're interested in (especially when working on a branch/tag).

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 72d2335..81d984b 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -51,7 +51,7 @@ if hgid=`hg id 2>/dev/null`; then
 fi
 
 # Check for svn and a svn repo.
-if rev=`svn info 2>/dev/null | grep '^Revision'`; then
+if rev=`svn info 2>/dev/null | grep '^Last Changed Rev'`; then
 	rev=`echo $rev | awk '{print $NF}'`
 	changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l`
 
-- 
1.5.6.5

