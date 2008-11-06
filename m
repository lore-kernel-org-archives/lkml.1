Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYKFIbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYKFIbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 03:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYKFIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 03:31:38 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38387 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645AbYKFIbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:31:37 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH] kbuild: introduce KECHO convenience echo
Date: Thu,  6 Nov 2008 03:31:34 -0500
Message-Id: <1225960295-30366-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bunch of places in the build system where we do 'echo' to show
some nice status lines.  This means we still get output when running in
silent mode.  So declare a new KECHO variable that only does 'echo' when we
are in a suitable verbose build mode.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/Kbuild.include |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 982dcae..9dc96cf 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -25,6 +25,13 @@ basetarget = $(basename $(notdir $@))
 escsq = $(subst $(squote),'\$(squote)',$1)
 
 ###
+# Easy method for doing a status message
+       kecho = :
+ quiet_kecho = echo
+silent_kecho = :
+KECHO = $($(quiet)kecho)
+
+###
 # filechk is used to check if the content of a generated file is updated.
 # Sample usage:
 # define filechk_sample
-- 
1.6.0.3

