Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYDSWc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYDSWc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYDSWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:32:48 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:39340 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYDSWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:32:48 -0400
X-Greylist: delayed 1462 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Apr 2008 18:32:47 EDT
Date: Sun, 20 Apr 2008 00:07:14 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Matt Mackall <mpm@selenic.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       dev-etrax <dev-etrax@axis.com>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH][trivial][2/2] cris: add constfy to pgd_offset()
Message-ID: <20080419220714.GE3031@axis.com>
References: <20080419185723.A8F1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419190442.A8F4.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080419190710.A8F7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080419190710.A8F7.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2008 at 12:09:25PM +0200, KOSAKI Motohiro wrote:
> add constfy to pgd_offset() for avoid following warnings.
> 
>   CC      mm/pagewalk.o
> mm/pagewalk.c: In function 'walk_page_range':
> mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
> ointer target type
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Matt Mackall <mpm@selenic.com>
> CC: "Vegard Nossum" <vegard.nossum@gmail.com>
> CC: Mikael Starvik <starvik@axis.com>
> CC: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> ---
>  include/asm-cris/pgtable.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/include/asm-cris/pgtable.h
> ===================================================================
> --- a/include/asm-cris/pgtable.h        2008-04-19 19:25:50.000000000 +0900
> +++ b/include/asm-cris/pgtable.h        2008-04-19 19:27:31.000000000 +0900
> @@ -229,7 +229,7 @@ static inline void pmd_set(pmd_t * pmdp,
>  #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
> 
>  /* to find an entry in a page-table-directory */
> -static inline pgd_t * pgd_offset(struct mm_struct * mm, unsigned long address)
> +static inline pgd_t * pgd_offset(const struct mm_struct * mm, unsigned long address)
>  {
>         return mm->pgd + pgd_index(address);
>  }

Thanks, I've added the following to the CRIS-tree.

---
 include/asm-cris/pgtable.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-cris/pgtable.h b/include/asm-cris/pgtable.h
index a260757..a307ed6 100644
--- a/include/asm-cris/pgtable.h
+++ b/include/asm-cris/pgtable.h
@@ -229,7 +229,8 @@ static inline void pmd_set(pmd_t * pmdp, pte_t * ptep)
 #define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD-1))
 
 /* to find an entry in a page-table-directory */
-static inline pgd_t * pgd_offset(struct mm_struct * mm, unsigned long address)
+static inline pgd_t *pgd_offset(const struct mm_struct *mm,
+				unsigned long address)
 {
 	return mm->pgd + pgd_index(address);
 }
-- 
1.5.4.2.133.g3d51e

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
