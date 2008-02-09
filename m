Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYBIR77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYBIR77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYBIR7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:59:52 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:26217 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbYBIR7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:59:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J7XDclTTCJSa1ngVrDQm+hOZCVhsyGaahwCdj+6kLqi4XAYEstAE/1vmlaZd7COFrv4XaJcLKS/U2Bfc8FxnmcGBHMkWvO0Ssub0MZU0gNU61okgdMuwMsQsm/X8YGKMnRpsaHLVvrJ4XoaH9EjQSxamKpqnxq+AP8sTE9NqC2Y=
Message-ID: <8bd0f97a0802090959g367ef6a4h304b01e6f930781f@mail.gmail.com>
Date: Sat, 9 Feb 2008 12:59:50 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: schwidefsky@de.ibm.com, "Bryan Wu" <Bryan.Wu@analog.com>
Subject: Re: m68knommu compile error
Cc: "Adrian Bunk" <bunk@kernel.org>, gerg@uclinux.org,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1202554715.8936.18.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080208222516.GC6505@cs181133002.pp.htv.fi>
	 <1202552472.8936.7.camel@localhost>
	 <1202554715.8936.18.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 9, 2008 5:58 AM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Sat, 2008-02-09 at 11:21 +0100, Martin Schwidefsky wrote:
> > On Sat, 2008-02-09 at 00:25 +0200, Adrian Bunk wrote:
> > > Commit 2f569afd9ced9ebec9a6eb3dbf6f83429be0a7b4 breaks m68knommu:
> >
> > Does the patch below fixes the problem? I tried to cross compile for
> > m68knommu but it seems like you need a special m68k compiler to get it
> > compile all the way through. With the patch it did fail with a different
> > error, so I assume it is fixed. The problem is that the pgtable_t is
> > simply missing for m68knommu, I must have overlooked a reject for one of
> > the constant regenerations of the patch to keep up with upstream. Sorry
> > about that.
>
> This is a problem for all nommu architectures. The patch fixed all four
> of them.
>
> ---
> [PATCH] Add pgtable_t to nommu architectures.
>
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> The pte_fn_t in include/linux/mm.h make it necessary for all
> architecture to define a pgtable_t type, even those that do
> not have an mmu.
>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>
>  include/asm-blackfin/page.h  |    1 +
>  include/asm-h8300/page.h     |    1 +
>  include/asm-m68knommu/page.h |    1 +
>  include/asm-v850/page.h      |    1 +
>  4 files changed, 4 insertions(+)
>
> diff -urpN linux-2.6/include/asm-blackfin/page.h linux-2.6-patched/include/asm-blackfin/page.h
> --- linux-2.6/include/asm-blackfin/page.h       2008-02-09 11:46:28.000000000 +0100
> +++ linux-2.6-patched/include/asm-blackfin/page.h       2008-02-09 11:46:36.000000000 +0100
> @@ -39,6 +39,7 @@ typedef struct {
>  typedef struct {
>         unsigned long pgprot;
>  } pgprot_t;
> +typedef struct page *pgtable_t;
>
>  #define pte_val(x)     ((x).pte)
>  #define pmd_val(x)     ((&x)->pmd[0])

thanks, this fixed building Blackfin for me.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
