Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbZIOUyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbZIOUyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 16:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758531AbZIOUx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 16:53:57 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:48965 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758517AbZIOUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 16:53:56 -0400
X-Trace: 259131786/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.84.74/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.84.74
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlgFAFqbr0pPRVRK/2dsb2JhbACBU95khBcF
X-IronPort-AV: E=Sophos;i="4.44,391,1249254000"; 
   d="scan'208";a="259131786"
Date: Tue, 15 Sep 2009 21:53:12 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric B Munson <ebmunson@us.ibm.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, Arnd Bergman <arnd@arndb.de>
Subject: Re: [PATCH] Fix for hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
 in -mm
In-Reply-To: <1253011613-6429-1-git-send-email-ebmunson@us.ibm.com>
Message-ID: <Pine.LNX.4.64.0909152146470.25625@sister.anvils>
References: <1252487811-9205-1-git-send-email-ebmunson@us.ibm.com>
 <1253011613-6429-1-git-send-email-ebmunson@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Eric B Munson wrote:
> Resending because this seems to have fallen between the cracks.

Yes, indeed.  I think it isn't quite what Arnd was suggesting, but I
agree with you that we might as well go for 0x080000 (so that even Alpha
can be just a cut-and-paste job from asm-generic), and right now it's
more important to finalize the number than what file it appears in.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> 
> The patch
> hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
> used the value 0x40 for MAP_HUGETLB which is the same value used for
> various other flags on some architectures.  This collision causes
> unexpected use of huge pages in the best case and mmap to fail with
> ENOMEM or ENOSYS in the worst.  This patch changes the value for
> MAP_HUGETLB to a value that is not currently used on any arch.
> 
> This patch should be considered a fix to
> hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch.
> 
> Reported-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
>  include/asm-generic/mman-common.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
> index 12f5982..e6adb68 100644
> --- a/include/asm-generic/mman-common.h
> +++ b/include/asm-generic/mman-common.h
> @@ -19,7 +19,7 @@
>  #define MAP_TYPE	0x0f		/* Mask for type of mapping */
>  #define MAP_FIXED	0x10		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x20		/* don't use a file */
> -#define MAP_HUGETLB	0x40		/* create a huge page mapping */
> +#define MAP_HUGETLB	0x080000	/* create a huge page mapping */
>  
>  #define MS_ASYNC	1		/* sync memory asynchronously */
>  #define MS_INVALIDATE	2		/* invalidate the caches */
> -- 
> 1.6.3.2
