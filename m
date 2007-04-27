Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbXD0S6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbXD0S6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXD0S5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:57:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:35261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757053AbXD0S53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:57:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: John Anthony Kazos Jr <jakj@j-a-k-j.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/46] Kobject: kobject_uevent.c: Collapse unnecessary loop nesting (top_kobj)
Date: Fri, 27 Apr 2007 11:53:32 -0700
Message-Id: <11777001041847-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777001002860-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr <jakj@j-a-k-j.com>

Collapses a do..while() loop within an if() to a simple while() loop for
simplicity and readability.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 4122f38..d9a3510 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -95,10 +95,8 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 
 	/* search the kset we belong to */
 	top_kobj = kobj;
-	if (!top_kobj->kset && top_kobj->parent) {
-		do {
-			top_kobj = top_kobj->parent;
-		} while (!top_kobj->kset && top_kobj->parent);
+	while (!top_kobj->kset && top_kobj->parent) {
+		top_kobj = top_kobj->parent;
 	}
 	if (!top_kobj->kset) {
 		pr_debug("kobject attempted to send uevent without kset!\n");
-- 
1.5.1.2

