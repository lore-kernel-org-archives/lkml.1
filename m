Return-Path: <linux-kernel-owner+w=401wt.eu-S2992864AbXDDLjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992864AbXDDLjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992866AbXDDLjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:39:32 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:44618 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992864AbXDDLjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:39:31 -0400
Date: Wed, 4 Apr 2007 07:39:17 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: gregkh@suse.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/kobject_uevent.c: Collapse unnecessary loop nesting
 (top_kobj)
Message-ID: <alpine.DEB.0.83.0704040730530.25382@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Collapses a do..while() loop within an if() to a simple while() loop for 
simplicity and readability.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I'm sure GCC is able to handle this optimization decently, but there's no 
reason at all for the additional nesting level for the loop.

--- linux-2.6.20.4/lib/kobject_uevent.c.orig	2007-04-04 07:25:08.000000000 -0400
+++ linux-2.6.20.4/lib/kobject_uevent.c	2007-04-04 07:27:28.000000000 -0400
@@ -95,10 +95,8 @@ int kobject_uevent_env(struct kobject *k
 
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
