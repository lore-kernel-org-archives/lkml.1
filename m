Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZFFV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZFFV4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZFFV4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 17:56:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:33932 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbZFFV4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 17:56:15 -0400
Message-ID: <4A2AE5D6.2040809@kernel.org>
Date: Sat, 06 Jun 2009 14:55:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] core: use cpumask_copy instead of = for cpus_allowed
 in fork
References: <4A2835D8.6040903@kernel.org> <200906051428.08299.rusty@rustcorp.com.au> <4A28B3A9.3010505@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <4A2A356B.6090102@redhat.com> <4A2A38B9.7030809@kernel.org> <4A2A3969.5030101@redhat.com> <4A2A4B80.1010605@kernel.org> <4A2AE4AC.60805@kernel.org>
In-Reply-To: <4A2AE4AC.60805@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


so later could use nr_cpumask_bits in cpumask_size when MAXSMP is used

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   52 ++++++++++++++++++++----------
 kernel/fork.c                             |    2 -
 2 files changed, 36 insertions(+), 18 deletions(-)

Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1207,7 +1207,7 @@ static struct task_struct *copy_process(
 	 * to ensure it is on a valid CPU (and if not, just force it back to
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
-	p->cpus_allowed = current->cpus_allowed;
+	cpumask_copy(&p->cpus_allowed, &current->cpus_allowed);
 	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
