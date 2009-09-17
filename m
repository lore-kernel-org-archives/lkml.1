Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZIQCpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZIQCpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 22:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbZIQCpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 22:45:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51592 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206AbZIQCpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 22:45:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 11:42:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Am?rico_Wang <xiyou.wangcong@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/3][mmotm] kcore: more fixes for init
Message-Id: <20090917114256.1f3971d8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	<20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

proc_kcore_init() doesn't check NULL case.
fix it and remove unnecessary comments.

Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 fs/proc/kcore.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
@@ -606,6 +606,10 @@ static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
 				      &proc_kcore_operations);
+	if (!proc_root_kcore) {
+		printk(KERN_ERR "couldn't create /proc/kcore\n");
+		return 0; /* Always returns 0. */
+	}
 	/* Store text area if it's special */
 	proc_kcore_text_init();
 	/* Store vmalloc area */
@@ -615,7 +619,6 @@ static int __init proc_kcore_init(void)
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
 	hotplug_memory_notifier(kcore_callback, 0);
-	/* Other special area, area-for-module etc is arch specific. */
 
 	return 0;
 }

