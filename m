Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZA0F3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZA0F3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZA0F3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:29:05 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:45550 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZA0F3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:29:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=es+DeXUTt1Z09IAJ3RDT7QxGr3lujaY0I1wfAzJ6shYoJJgIGe9Ak73sBt6W8Z20o5
         W+/DYTRVFgyVwnl33ILEZ3k/3vve4sZGxjjwu2XR4WvAKJ6YAN0t1g92L25XZ62IXVjS
         Ltqibkomkt86DeCPxX8uZEdQgHVDfYsagtPVQ=
Message-ID: <497E9B9D.4010102@gmail.com>
Date: Tue, 27 Jan 2009 14:29:01 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
References: <20090126103243.GA31307@elte.hu>	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>	 <497E8778.9060503@gmail.com> <1233032609.3248.78.camel@localhost.localdomain>
In-Reply-To: <1233032609.3248.78.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

Impact: build fix

x86_cpu_to_apicid and x86_bios_cpu_apicid aren't defined for voyage.
Earlier patch forgot to conditionalize early percpu clearing.  Fix it.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
These two patches have been merged into #tj-percpu.  Thanks.

 arch/x86/kernel/setup_percpu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 4caa78d..c7458ea 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -125,8 +125,10 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	/* indicate the early static arrays will soon be gone */
+#ifdef CONFIG_X86_LOCAL_APIC
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
+#endif
 #if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
-- 
1.6.0.2

