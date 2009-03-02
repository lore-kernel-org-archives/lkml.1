Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbZCBBmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbZCBBmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZCBBlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:41:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbZCBBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:41:52 -0500
Date: Sun, 1 Mar 2009 20:41:41 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] debug_objects: add toggle to turn object debugging off
	again
Message-ID: <20090302014141.GI28503@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

While trying to debug why my Atom netbook is falling over booting
rawhide debug-enabled kernels, I stumbled across the fact that we've
been enabling object debugging by default. However, once you default it
to on, you've got no way to turn it back off again at runtime.

Add a boolean toggle to turn it off. I would just make it an int
module_param, however people may already expect the boolean enable
behaviour, so just add an analogue for disabling.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 54f21a5..1a328f3 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -604,6 +604,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	debug_objects	[KNL] Enable object debugging
 
+	no_debug_objects
+			[KNL] Disable object debugging
+
 	debugpat	[X86] Enable PAT debugging
 
 	decnet.addr=	[HW,NET]
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 5d99be1..90e46fa 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -55,7 +55,15 @@ static int __init enable_object_debug(char *str)
 	debug_objects_enabled = 1;
 	return 0;
 }
+
+static int __init disable_object_debug(char *str)
+{
+	debug_objects_enabled = 0;
+	return 0;
+}
+
 early_param("debug_objects", enable_object_debug);
+early_param("no_debug_objects", disable_object_debug);
 
 static const char *obj_states[ODEBUG_STATE_MAX] = {
 	[ODEBUG_STATE_NONE]		= "none",
