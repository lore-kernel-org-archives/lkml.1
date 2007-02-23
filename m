Return-Path: <linux-kernel-owner+w=401wt.eu-S1750917AbXBWLiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbXBWLiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXBWLiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:38:03 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42823 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXBWLiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:38:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 11/14] x86_64 irq: Remove unnecessary irq 0 setup.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:36:25 -0700
In-Reply-To: <m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:35:05 -0700")
Message-ID: <m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The code in io_apic.c and in i8259.c currently hardcode the same
vector for the timer interrupt so there is no reason for a special
assignment for the timer as the setup for the i8259 already takes care
of this.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/i8259.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 01e2cf0..103517d 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -520,12 +520,6 @@ void __init init_IRQ(void)
 
 #ifdef CONFIG_SMP
 	/*
-	 * IRQ0 must be given a fixed assignment and initialized,
-	 * because it's used before the IO-APIC is set up.
-	 */
-	__get_cpu_var(vector_irq)[FIRST_DEVICE_VECTOR] = 0;
-
-	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
 	 */
-- 
1.5.0.g53756

