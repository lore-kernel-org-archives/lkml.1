Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbZDWKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbZDWKey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZDWKen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:34:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:45476 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbZDWKel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:34:41 -0400
Date: Thu, 23 Apr 2009 06:33:36 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: upstream tree build failure
Message-ID: <20090423103336.GA3825@zod.rchland.ibm.com>
References: <20090423160656.fac84e3f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423160656.fac84e3f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:06:56PM +1000, Stephen Rothwell wrote:
>Hi all,
>
>[I am now using gcc version 4.4.0 ...]
>
>Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
>
>arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression
>
>Previous gcc versions didn't notice this because one of the preceding
>#ifs always evaluated to true.  I have applied the following patch for today.
>
>-- 
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>http://www.canb.auug.org.au/~sfr/
>
>From: Stephen Rothwell <sfr@canb.auug.org.au>
>Date: Thu, 23 Apr 2009 16:00:47 +1000
>Subject: [PATCH] powerpc: fix for long standing bug noticed by gcc 4.4.0
>
>Previous gcc versions didn't notice this because one of the preceding
>
>gcc 4.4.0 produced this error:
>
>arch/powerpc/mm/tlb_nohash_low.S:206:6: error: #elif with no expression
>
>Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Your changelog got truncated in the first sentence.  No big deal.

I have a gcc 4.4.0 system as well.  I'll try a bunch of various builds to see
if it catches anything else.  This fix looks good to me in the meantime.

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

josh

>---
> arch/powerpc/mm/tlb_nohash_low.S |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/arch/powerpc/mm/tlb_nohash_low.S b/arch/powerpc/mm/tlb_nohash_low.S
>index 45fed36..21e1b9a 100644
>--- a/arch/powerpc/mm/tlb_nohash_low.S
>+++ b/arch/powerpc/mm/tlb_nohash_low.S
>@@ -203,6 +203,6 @@ ALT_MMU_FTR_SECTION_END_IFCLR(MMU_FTR_USE_TLBILX)
> 	isync
> 1:	wrtee	r10
> 	blr
>-#elif
>+#else
> #error Unsupported processor type !
> #endif
