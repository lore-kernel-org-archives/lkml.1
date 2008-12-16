Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbYLPIAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbYLPIAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:00:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYLPIAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:00:34 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48933 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYLPIAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:00:33 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [mmotm][PATCH] proc: enclose desc variable of show_stat() in CONFIG_SPARSE_IRQ
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081216165758.DBB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 17:00:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied after: linux-next.patch
==
commit 240d367b4e6c6e3c5075e034db14dba60a6f5fa7 moved desc usage point into
#ifdef CONFIG_SPARSE_IRQ.
Then, variable declaration also shold be enclosed. otherwise following warning happend.

fs/proc/stat.c: In function 'show_stat':
fs/proc/stat.c:31: warning: unused variable 'desc'


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/stat.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/fs/proc/stat.c
===================================================================
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -28,7 +28,9 @@ static int show_stat(struct seq_file *p,
 	u64 sum_softirq = 0;
 	struct timespec boottime;
 	unsigned int per_irq_sum;
+#ifdef CONFIG_SPARSE_IRQ
 	struct irq_desc *desc;
+#endif
 
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = cputime64_zero;


