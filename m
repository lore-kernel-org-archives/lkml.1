Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZFOJoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZFOJoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbZFOJo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:44:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32791 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZFOJo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:44:28 -0400
Date: Mon, 15 Jun 2009 19:44:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sparc: replace uses of CPU_MASK_ALL_PTR
Message-Id: <20090615194430.a1b42798.sfr@canb.auug.org.au>
In-Reply-To: <20090615.015201.25929512.davem@davemloft.net>
References: <20090615164022.9b06b579.sfr@canb.auug.org.au>
	<20090615172640.32b1243b.sfr@canb.auug.org.au>
	<20090615.015201.25929512.davem@davemloft.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPU_MASK_ALL is the (deprecated) "all bits set" cpumask, defined as so:

	#define CPU_MASK_ALL (cpumask_t) { { ... } }

Taking the address of such a temporary is questionable at best,
unfortunately 321a8e9d (cpumask: add CPU_MASK_ALL_PTR macro) added
CPU_MASK_ALL_PTR:

	#define CPU_MASK_ALL_PTR (&CPU_MASK_ALL)

Which formalizes this practice.  One day gcc could bite us over this
usage (though we seem to have gotten away with it so far).

[Description by Rusty Russell]
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/smp_64.c |    2 +-
 arch/sparc/mm/init_64.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 1de47d2..f3a83b0 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1538,5 +1538,5 @@ void __init setup_per_cpu_areas(void)
 
 	of_fill_in_cpu_data();
 	if (tlb_type == hypervisor)
-		mdesc_fill_in_cpu_data(CPU_MASK_ALL_PTR);
+		mdesc_fill_in_cpu_data(cpu_all_mask);
 }
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b5a5932..ca92e2f 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -1799,7 +1799,7 @@ void __init paging_init(void)
 
 	if (tlb_type == hypervisor) {
 		sun4v_mdesc_init();
-		mdesc_populate_present_mask(CPU_MASK_ALL_PTR);
+		mdesc_populate_present_mask(cpu_all_mask);
 	}
 
 	/* Once the OF device tree and MDESC have been setup, we know
-- 
1.6.3.1

On Mon, 15 Jun 2009 01:52:01 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
>
> Sorry, slipped through the cracks.  Could you please send me
> a fresh copy of that patch?

See above.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
