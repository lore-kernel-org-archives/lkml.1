Return-Path: <linux-kernel-owner+w=401wt.eu-S969391AbXG3WLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969391AbXG3WLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969163AbXG3WK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:10:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:53783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969153AbXG3WK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:10:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/11] kobject: fix link error when CONFIG_HOTPLUG is disabled
Date: Mon, 30 Jul 2007 15:09:25 -0700
Message-Id: <11858333823900-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11858333772499-git-send-email-gregkh@suse.de>
References: <20070730220829.GB5263@kroah.com>
 <1185833373286-git-send-email-gregkh@suse.de>
 <11858333772499-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Leaving kobject_actions[] in kobject_uevent.c, but putting it outside
the #ifdef looks indeed like the best solution to me. This way, we
avoid adding #ifdef CONFIG_HOTPLUG into core.c, when all other
functions called do not need such a thing.


Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/kobject_uevent.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 6a80c78..df02814 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -25,14 +25,6 @@
 #define BUFFER_SIZE	2048	/* buffer for the variables */
 #define NUM_ENVP	32	/* number of env pointers */
 
-#if defined(CONFIG_HOTPLUG)
-u64 uevent_seqnum;
-char uevent_helper[UEVENT_HELPER_PATH_LEN] = "/sbin/hotplug";
-static DEFINE_SPINLOCK(sequence_lock);
-#if defined(CONFIG_NET)
-static struct sock *uevent_sock;
-#endif
-
 /* the strings here must match the enum in include/linux/kobject.h */
 const char *kobject_actions[] = {
 	"add",
@@ -43,6 +35,14 @@ const char *kobject_actions[] = {
 	"offline",
 };
 
+#if defined(CONFIG_HOTPLUG)
+u64 uevent_seqnum;
+char uevent_helper[UEVENT_HELPER_PATH_LEN] = "/sbin/hotplug";
+static DEFINE_SPINLOCK(sequence_lock);
+#if defined(CONFIG_NET)
+static struct sock *uevent_sock;
+#endif
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
-- 
1.5.2.2

