Return-Path: <linux-kernel-owner+w=401wt.eu-S1765357AbYDNSPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765357AbYDNSPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764991AbYDNSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57907 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764985AbYDNSOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:39 -0400
Date: Mon, 14 Apr 2008 21:13:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper spawn_ksoftirqd() prototype
Message-ID: <20080414181331.GE6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for spawn_ksoftirqd() in 
include/linux/interrupt.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sebt on:
- 31 Mar 2008
- 22 Feb 2008

 include/linux/interrupt.h |    1 +
 init/main.c               |    2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

be4c4228059d0d56bf9d5a7c902a244625d1f94b diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 8ccc912..1a5c3d1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -276,6 +276,7 @@ extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
 extern void raise_softirq_irqoff(unsigned int nr);
 extern void raise_softirq(unsigned int nr);
+extern int spawn_ksoftirqd(void);
 
 
 /* Tasklets --- multithreaded analogue of BHs.
diff --git a/init/main.c b/init/main.c
index 8b19820..7dd9916 100644
--- a/init/main.c
+++ b/init/main.c
@@ -756,8 +756,6 @@ __setup("nosoftlockup", nosoftlockup_setup);
 
 static void __init do_pre_smp_initcalls(void)
 {
-	extern int spawn_ksoftirqd(void);
-
 	migration_init();
 	spawn_ksoftirqd();
 	if (!nosoftlockup)


