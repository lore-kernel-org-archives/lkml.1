Return-Path: <linux-kernel-owner+w=401wt.eu-S1422802AbXBHAdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422802AbXBHAdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbXBHAd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:33:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:56424 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422874AbXBHAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:38 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/28] kobject: kobject_put cleanup
Date: Wed,  7 Feb 2007 16:30:08 -0800
Message-Id: <11708946871208-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946832214-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com> <11708946762594-git-send-email-greg@kroah.com> <11708946802786-git-send-email-greg@kroah.com> <11708946832214-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch removes redundant argument checks for kobject_put().

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index c033dc8..74b8dbc 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -195,8 +195,7 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		if (parent)
-			kobject_put(parent);
+		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -420,8 +419,7 @@ void kobject_cleanup(struct kobject * kobj)
 		t->release(kobj);
 	if (s)
 		kset_put(s);
-	if (parent) 
-		kobject_put(parent);
+	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)
-- 
1.4.4.4

