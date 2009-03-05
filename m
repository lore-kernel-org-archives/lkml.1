Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbZCEOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbZCEOgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCEOgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:36:39 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:19363 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZCEOgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:36:38 -0500
X-BigFish: VPS-27(zz1432R98dR1805M936fKzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG1F89-03-F82-01
Date: Thu, 5 Mar 2009 15:36:08 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] kvm/x86/mmu: don't unnecessarily recalculate table_gfn in *fetch
Message-ID: <20090305143608.GF8751@amd.com>
References: <1236255153-4432-1-git-send-email-joerg.roedel@amd.com> <1236255153-4432-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1236255153-4432-4-git-send-email-joerg.roedel@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Mar 2009 14:36:08.0897 (UTC) FILETIME=[B92E9B10:01C99D9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 01:12:30PM +0100, Joerg Roedel wrote:
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index a0c11ea..79668ba 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -315,7 +315,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>  			direct = 1;
>  			if (!is_dirty_pte(gw->ptes[level - 1]))
>  				access &= ~ACC_WRITE_MASK;
> -			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
> +			table_gfn = gw->table_gfn[level - delta];
>  		} else {
>  			direct = 0;
>  			table_gfn = gw->table_gfn[level - 2];

Made a mistake here when rebasing these patches. Updated patch is below:

>From de38a141a0ba44b3d46e333620d518cd831326c0 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 4 Mar 2009 20:49:15 +0100
Subject: [PATCH 3/6] kvm/x86/mmu: don't unnecessarily recalculate table_gfn in *fetch

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a0c11ea..79668ba 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -315,7 +315,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			direct = 1;
 			if (!is_dirty_pte(gw->ptes[level - 1]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(gw->ptes[level - 1]);
+			table_gfn = gw->table_gfn[level - 1];
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];
-- 
1.5.6.4


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

