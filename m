Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbZFMQjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbZFMQjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932741AbZFMQim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:38:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:34544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932771AbZFMQil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:38:41 -0400
Subject: [RFC][PATCH 3/10 -tip] x86: cpu_debug.c use a WARN_ONCE() instead
 of a pr_err()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1244910575.11733.17.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:00:18 +0530
Message-Id: <1244910618.11733.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use a WARN_ONCE() instead of a pr_err(). Hitting this is a
bug we want to fix.

Also added email address.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpu_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index f7b42d2..3aa3596 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -644,8 +644,8 @@ static int cpu_init_cpu(void)
 		pr_info("cpu%d(%d) debug files %d\n",
 			cpu, nr_cpu_ids, per_cpu(cpu_priv_count, cpu));
 		if (per_cpu(cpu_priv_count, cpu) > MAX_CPU_FILES) {
-			pr_err("Register files count %d exceeds limit %d\n",
-				per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
+			WARN_ONCE(1, "debug files count %d exceeds limit %d\n",
+				  per_cpu(cpu_priv_count, cpu), MAX_CPU_FILES);
 			per_cpu(cpu_priv_count, cpu) = MAX_CPU_FILES;
 			err = -ENFILE;
 		}
@@ -678,6 +678,6 @@ static void __exit cpu_debug_exit(void)
 module_init(cpu_debug_init);
 module_exit(cpu_debug_exit);
 
-MODULE_AUTHOR("Jaswinder Singh Rajput");
+MODULE_AUTHOR("Jaswinder Singh Rajput <jaswinder@kernel.org>");
 MODULE_DESCRIPTION("CPU Debug module");
 MODULE_LICENSE("GPL");
-- 
1.6.0.6



