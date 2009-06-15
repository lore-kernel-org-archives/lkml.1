Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZFOKkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZFOKkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZFOKj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:39:58 -0400
Received: from ozlabs.org ([203.10.76.45]:46308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbZFOKj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:39:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: rr tree build failure
Date: Mon, 15 Jun 2009 20:09:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
References: <20090615164022.9b06b579.sfr@canb.auug.org.au>
In-Reply-To: <20090615164022.9b06b579.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906152009.57309.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 04:10:22 pm Stephen Rothwell wrote:
> Hi Rusty,
>
> Today's linux-next build (sparc64 defconfig) failed like this:
>
> arch/sparc/mm/init_64.c: In function 'paging_init':
> arch/sparc/mm/init_64.c:1802: error: 'CPU_MASK_ALL_PTR' undeclared (first
> use in this function) arch/sparc/kernel/smp_64.c: In function
> 'setup_per_cpu_areas':
> arch/sparc/kernel/smp_64.c:1541: error: 'CPU_MASK_ALL_PTR' undeclared
> (first use in this function)
>
...
> Rusty, I assume that there is something that Dave can use in the sparc
> tree already instead of CPU_MASK_ALL_PTR (cpu_all_mask?).

cpu_all_mask, yes.

I have this great patch someone sent me :)

Thanks,
Rusty.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 12 Jun 2009 18:43:54 +1000
Subject: [PATCH] sparc: replace uses of CPU_MASK_ALL_PTR

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

