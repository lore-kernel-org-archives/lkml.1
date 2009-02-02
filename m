Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217AbZBBNtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbZBBNtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZBBNsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:48:50 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:41663 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbZBBNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:48:49 -0500
Subject: Re: [PATCH -mmotm] mm: unify some pmd_*() functions fix
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>
In-Reply-To: <1233183874-26066-1-git-send-email-righi.andrea@gmail.com>
References: <1233183874-26066-1-git-send-email-righi.andrea@gmail.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 02 Feb 2009 14:48:46 +0100
Message-Id: <1233582526.18006.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 00:04 +0100, Andrea Righi wrote:
> Also unify implementations of pmd_*() functions in arch/*.
> 
> This patch must be applied on top of mm-unify-some-pmd_-functions.patch.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>

> diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
> index b2658b9..6a85281 100644
> --- a/arch/s390/include/asm/pgalloc.h
> +++ b/arch/s390/include/asm/pgalloc.h
> @@ -63,8 +63,7 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
>  #define pud_alloc_one(mm,address)		({ BUG(); ((pud_t *)2); })
>  #define pud_free(mm, x)				do { } while (0)
> 
> -#define pmd_alloc_one(mm,address)		({ BUG(); ((pmd_t *)2); })
> -#define pmd_free(mm, x)				do { } while (0)
> +#define pmd_alloc_one	pmd_alloc_one_bug
> 
>  #define pgd_populate(mm, pgd, pud)		BUG()
>  #define pgd_populate_kernel(mm, pgd, pud)	BUG()

This does not compile for 32 bit s390. With the patches for 'dynamic
page tables' and '1K/2k page tables' I decided to get completely
independent from the nopmd/nopud #ifdef hell. The include files from
asm-generic are simply not used for s390. Please drop the above hunk
from your patch and leave s390 as it is.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


