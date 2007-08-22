Return-Path: <linux-kernel-owner+w=401wt.eu-S933622AbXHVWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933622AbXHVWeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbXHVWeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:34:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44371 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbXHVWeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:34:09 -0400
Date: Thu, 23 Aug 2007 04:17:03 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Redefine register_hotcpu_notifier() !HOTPLUG_CPU stub as
 static inline function
Message-ID: <alpine.LFD.0.999.0708230415010.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The present do {} while stub's return cannot be checked, but the real
HOTPLUG_CPU=y implementation of register_hotcpu_notifier() is int-
returning. So let us make this stub consistent with the full version.
Redefining this as such will also help us remove some #ifdef-ery
elsewhere in kernel code, as shown in forthcoming patch.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/linux/cpu.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 1d5ded0..ed6fa22 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -119,7 +119,10 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+static inline int register_hotcpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 #define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
