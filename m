Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYKVRny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYKVRny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbYKVRig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:38:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58507 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874AbYKVRif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:38:35 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 32/32] hotplug_memory_notifier section annotation
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wRG-0006gw-NF@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:38:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Same as for hotplug_cpu - we want static notifier_block in there in meminitdata,
to avoid false positives whenever it's used.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/memory.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/memory.h b/include/linux/memory.h
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -91,7 +91,7 @@ extern int memory_notify(unsigned long val, void *v);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 #define hotplug_memory_notifier(fn, pri) {			\
-	static struct notifier_block fn##_mem_nb =		\
+	static __meminitdata struct notifier_block fn##_mem_nb =\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_memory_notifier(&fn##_mem_nb);			\
 }
