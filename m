Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbZLFTlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbZLFTlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 14:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLFTlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 14:41:13 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:49587 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZLFTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 14:41:12 -0500
Date: Sun, 6 Dec 2009 20:41:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpumask: Fix generate_sched_domains() for UP
Message-ID: <alpine.DEB.2.00.0912062038070.5693@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit acc3f5d7cabbfd6cec71f0c1f9900621fa2d6ae7 ("cpumask:
Partition_sched_domains takes array of cpumask_var_t") changed the function
signature of generate_sched_domains() for the CONFIG_SMP=y case, but forgot to
update the corresponding function for the CONFIG_SMP=n case, causing:

kernel/cpuset.c:2073: warning: passing argument 1 of 'generate_sched_domains' from incompatible pointer type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/cpuset.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3cf2183..43fb7e8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -737,7 +737,7 @@ static void do_rebuild_sched_domains(struct work_struct *unused)
 {
 }
 
-static int generate_sched_domains(struct cpumask **domains,
+static int generate_sched_domains(cpumask_var_t **domains,
 			struct sched_domain_attr **attributes)
 {
 	*domains = NULL;
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
