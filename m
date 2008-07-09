Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYGIHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYGIHzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGIHzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:55:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219AbYGIHzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:55:39 -0400
Subject: Re: [PATCH 16 of 55] xen64: add extra pv_mmu_ops
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Stephen Tweedie <sct@redhat.com>,
       Eduardo Habkost <ehabkost@redhat.com>
In-Reply-To: <76d0856d664470b81640.1215554798@localhost>
References: <76d0856d664470b81640.1215554798@localhost>
Content-Type: text/plain
Date: Wed, 09 Jul 2008 08:55:10 +0100
Message-Id: <1215590110.16579.7.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jeremy,

On Tue, 2008-07-08 at 15:06 -0700, Jeremy Fitzhardinge wrote:
> We need extra pv_mmu_ops for 64-bit, to deal with the extra level of
> pagetable.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/xen/enlighten.c   |   33 +++++++++++++++++++++++++++-
>  arch/x86/xen/mmu.c         |   51 +++++++++++++++++++++++++++++++++++++++++++-
>  arch/x86/xen/mmu.h         |   15 +++++++++++-
>  include/asm-x86/xen/page.h |    4 +++
>  4 files changed, 99 insertions(+), 4 deletions(-)
...
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -438,14 +438,19 @@
>  
>  void xen_set_pte(pte_t *ptep, pte_t pte)
>  {
> +#ifdef CONFIG_X86_PAE
>  	ptep->pte_high = pte.pte_high;
>  	smp_wmb();
>  	ptep->pte_low = pte.pte_low;
> +#else
> +	*ptep = pte;
> +#endif
>  }

You've dropped non-PAE support already, right? Any reason to use the
X86_PAE macro instead of X86_32?

Cheers,
Mark.

