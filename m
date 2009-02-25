Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZBYCK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZBYCK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 21:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZBYCKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 21:10:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:47742 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZBYCKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 21:10:14 -0500
Message-ID: <49A4A86F.9010001@kernel.org>
Date: Wed, 25 Feb 2009 11:09:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, rusty@rustcorp.com.au, tglx@linutronix.de,
       x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       jeremy@goop.org, cpw@sgi.com, nickpiggin@yahoo.com.au,
       ink@jurassic.park.msu.ru
Subject: [PATCH x86/core/percpu 1/2] x86, percpu: fix minor bugs in setup_percpu.c
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224201718.GE28772@elte.hu> <20090224205105.GA19460@elte.hu> <20090224211659.GA3687@elte.hu>
In-Reply-To: <20090224211659.GA3687@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Feb 2009 02:09:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes in setup_percpu.c made a now meaningless DBG()
statement fail to compile and introduced a
comparison-of-different-types warning.  Fix them.

Compile failure is reported by Ingo Molnar.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup_percpu.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 2d946a8..c29f301 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -270,7 +270,7 @@ static ssize_t __init setup_pcpu_embed(size_t static_size)
 
 	/* allocate and copy */
 	pcpue_unit_size = PFN_ALIGN(static_size + PERCPU_DYNAMIC_RESERVE);
-	pcpue_unit_size = max(pcpue_unit_size, PCPU_MIN_UNIT_SIZE);
+	pcpue_unit_size = max_t(size_t, pcpue_unit_size, PCPU_MIN_UNIT_SIZE);
 	pcpue_ptr = pcpu_alloc_bootmem(0, num_possible_cpus() * pcpue_unit_size,
 				       PAGE_SIZE);
 	if (!pcpue_ptr)
@@ -438,8 +438,6 @@ void __init setup_per_cpu_areas(void)
 		 */
 		if (cpu == boot_cpu_id)
 			switch_to_new_gdt(cpu);
-
-		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
 	/* indicate the early static arrays will soon be gone */
-- 
1.6.0.2

