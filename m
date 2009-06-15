Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZFOFc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZFOFc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZFOFcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:32:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61329 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZFOFct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:32:49 -0400
Message-ID: <4A35DD5B.9050106@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 13:34:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: remove unneeded __ref tag
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those two functions no longer call alloc_bootmmem_cpumask_var(), so
no need to tag them with __init_refok.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c        |    2 +-
 kernel/sched_cpupri.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6032f51..54e47bc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7828,7 +7828,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		free_rootdomain(old_rd);
 }
 
-static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
+static int init_rootdomain(struct root_domain *rd, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 7deffc9..e6c2517 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -152,7 +152,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
  *
  * Returns: -ENOMEM if memory fails.
  */
-int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
+int cpupri_init(struct cpupri *cp, bool bootmem)
 {
 	gfp_t gfp = GFP_KERNEL;
 	int i;
-- 
1.5.4.rc3

