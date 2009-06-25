Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZFYHUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZFYHUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZFYHU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:20:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbZFYHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:20:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=hngoOtGVJuPtGn3wfd8aYyV0Hj32ECU8hrDJCtAq9AGfoiQ0iFnJO8ndW/e7XcR2A
	/DlRrLkTpOPDd/TFpG6gw==
From: Paul Menage <menage@google.com>
Subject: [PATCH] UML: Fix some apparent bitrot in mmu_context.h
To: rusty@rustcorp.com.au
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Date: Thu, 25 Jun 2009 00:19:56 -0700
Message-ID: <20090625071956.20800.4589.stgit@menage.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML: Fix some apparent bitrot in mmu_context.h

- cpumask_clear() -> cpumask_clear_cpu()

Signed-off-by: Paul Menage <menage@google.com>

--

Fixes the following compile errors:

arch/um/include/asm/mmu_context.h: In function 'switch_mm':
arch/um/include/asm/mmu_context.h:38: warning: passing argument 1 of 'cpumask_clear' makes pointer from integer without
a cast
arch/um/include/asm/mmu_context.h:38: error: too many arguments to function 'cpumask_clear'

---

 arch/um/include/asm/mmu_context.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/include/asm/mmu_context.h b/arch/um/include/asm/mmu_context.h
index edd719e..34d8130 100644
--- a/arch/um/include/asm/mmu_context.h
+++ b/arch/um/include/asm/mmu_context.h
@@ -35,7 +35,7 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 	unsigned cpu = smp_processor_id();
 
 	if(prev != next){
-		cpumask_clear(cpu, mm_cpumask(prev));
+		cpumask_clear_cpu(cpu, mm_cpumask(prev));
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 		if(next != &init_mm)
 			__switch_mm(&next->context.id);

