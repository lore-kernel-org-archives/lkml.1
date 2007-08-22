Return-Path: <linux-kernel-owner+w=401wt.eu-S1764689AbXHVWv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764689AbXHVWv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbXHVWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:51:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55429 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXHVWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:51:49 -0400
Date: Thu, 23 Aug 2007 04:34:43 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU
 stubs as static inline function
In-Reply-To: <alpine.LFD.0.999.0708230415010.2049@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0708230425280.2049@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708230415010.2049@enigma.security.iitk.ac.in
 >
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Eeks, please replace previous patch with this, and change the patch
  name and changelog as per that indicated in this mail -- apologies
  for the inconvenience caused! ]


[PATCH] Redefine {un}register_hotcpu_notifier() !HOTPLUG_CPU stubs as static inline functions

The return of the present "do {} while" based stub definition of
register_hotcpu_notifier() cannot be checked, but the real HOTPLUG_CPU=y
implementation of register_hotcpu_notifier() is int-returning. So let us
make this stub consistent with the full version. Redefining this as such
will also help us remove some #ifdef-ery elsewhere in kernel code, as
shown in forthcoming patch. Also do the same for unregister_xxx case.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/linux/cpu.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 1d5ded0..6a3697f 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -119,8 +119,13 @@ static inline void cpuhotplug_mutex_unlock(struct mutex *cpu_hp_mutex)
 #define lock_cpu_hotplug()	do { } while (0)
 #define unlock_cpu_hotplug()	do { } while (0)
 #define hotcpu_notifier(fn, pri)	do { (void)(fn); } while (0)
-#define register_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
-#define unregister_hotcpu_notifier(nb)	do { (void)(nb); } while (0)
+static inline int register_hotcpu_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+static inline void unregister_hotcpu_notifier(struct notifier_block *nb)
+{
+}
 
 /* CPUs don't go offline once they're online w/o CONFIG_HOTPLUG_CPU */
 static inline int cpu_is_offline(int cpu) { return 0; }
