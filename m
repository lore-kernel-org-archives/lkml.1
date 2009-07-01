Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZGANvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZGANvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbZGANvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:51:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:56398 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbZGANvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:51:05 -0400
Subject: Re: [PATCH -tip RESEND] x86: amd_iommu.c device_nb should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090701132219.GC13524@elte.hu>
References: <1246450627.6940.6.camel@hpdv5.satnam>
	 <20090701132219.GC13524@elte.hu>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 19:20:32 +0530
Message-Id: <1246456232.6940.13.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 15:22 +0200, Ingo Molnar wrote:
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > device_nb is used only by same file, it should be static.
> > 
> > Also fixed NULL pointer issue.
> > 
> > Fixed following sparse warnings :
> >   arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?
> >   arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer
> 
> Mind resending this with a proper changelog, along the template of:
> 
> |  This Sparse warning:
> |
> |      arch/x86/kernel/amd_iommu.c...
> |
> |  triggers because <reason>. <do action> to fix that - this also
> |  addresses the Sparse warning.
> 
> Where, in this current case:
> 
>  <reason>    := device_nb is global but is only used in a single .c file
>  <do action> := change device_nb to static
> 
> Please fill in the reason and action for the NULL fix as well.
> 
> Please write all similar warning fix commit log messages in a 
> similar way in the future if you want me to apply them.
> 

Please apply this :

[PATCH] x86: amd_iommu.c device_nb should be static

This sparse warning:

  arch/x86/kernel/amd_iommu.c:1195:23: warning: symbol 'device_nb' was not declared. Should it be static?

triggers because device_nb is global but is only used in a single .c file.
change device_nb to static to fix that - this also address the sparse warning.

This sparse warning:

  arch/x86/kernel/amd_iommu.c:1766:10: warning: Using plain integer as NULL pointer

triggers because plain integer 0 is used in place of NULL pointer.
change 0 to NULL to fix that - this also address the sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9372f04..6c99f50 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1192,7 +1192,7 @@ out:
 	return 0;
 }
 
-struct notifier_block device_nb = {
+static struct notifier_block device_nb = {
 	.notifier_call = device_change_notifier,
 };
 
@@ -1763,7 +1763,7 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	flag |= __GFP_ZERO;
 	virt_addr = (void *)__get_free_pages(flag, get_order(size));
 	if (!virt_addr)
-		return 0;
+		return NULL;
 
 	paddr = virt_to_phys(virt_addr);
 
-- 
1.6.0.6




