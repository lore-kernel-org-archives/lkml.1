Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYKTTLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYKTTLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 14:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYKTTLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 14:11:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38317 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743AbYKTTLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 14:11:22 -0500
Date: Thu, 20 Nov 2008 20:10:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mark McLoughlin <markmc@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 4/8] intel-iommu: move DMA PTE defs out of
	dma_remapping.h
Message-ID: <20081120191053.GA3955@elte.hu>
References: <1227191861.4901.24.camel@macbook.infradead.org> <1227196190-488-1-git-send-email-markmc@redhat.com> <1227196190-488-2-git-send-email-markmc@redhat.com> <1227196190-488-3-git-send-email-markmc@redhat.com> <1227196190-488-4-git-send-email-markmc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227196190-488-4-git-send-email-markmc@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mark McLoughlin <markmc@redhat.com> wrote:

> +struct dma_pte {
> +	u64 val;
> +};
> +#define dma_clear_pte(p)	do {(p).val = 0;} while (0)
> +
> +#define dma_set_pte_readable(p) do {(p).val |= DMA_PTE_READ;} while (0)
> +#define dma_set_pte_writable(p) do {(p).val |= DMA_PTE_WRITE;} while (0)
> +#define dma_set_pte_prot(p, prot) \
> +		do {(p).val = ((p).val & ~3) | ((prot) & 3); } while (0)
> +#define dma_pte_addr(p) ((p).val & VTD_PAGE_MASK)
> +#define dma_set_pte_addr(p, addr) do {\
> +		(p).val |= ((addr) & VTD_PAGE_MASK); } while (0)
> +#define dma_pte_present(p) (((p).val & 3) != 0)

If you touch this, please also clean this up to use proper inlines, 
not CPP macros.

Thanks,

	Ingo
