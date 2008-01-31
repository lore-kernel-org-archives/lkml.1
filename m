Return-Path: <linux-kernel-owner+w=401wt.eu-S933160AbYAaMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160AbYAaMSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 07:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763887AbYAaMSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 07:18:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761334AbYAaMSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 07:18:45 -0500
Date: Thu, 31 Jan 2008 13:18:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 5/5] x86: EFI memory mapping changes according to
	changes to ioremap and c_p_a
Message-ID: <20080131121823.GF12571@elte.hu>
References: <1201764968.12950.26.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201764968.12950.26.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang, Ying <ying.huang@intel.com> wrote:

> +			/* Assume pages are mapped as WB */
> +			if (mode == IOR_MODE_UNCACHED)
> +				set_memory_uc(md->virt_addr, md->num_pages);
> +			/* Assume pages are mapped as unexecutable */
> +			if ((__supported_pte_mask & _PAGE_NX) &&
> +			    xmode == IOR_XMODE_EXEC)
> +				set_memory_x(md->virt_addr, md->num_pages);

hm, why is the check for __supported_pte_mask needed? That is already 
listened to in set_memory_x(). [if not then it's an ioremap bug that we 
want to fix.]

> -static int ioremap_change_attr(unsigned long paddr, unsigned long size,
> -			       enum ioremap_mode mode,
> -			       enum ioremap_xmode xmode)
> +int ioremap_change_attr(unsigned long paddr, unsigned long size,
> +			enum ioremap_mode mode,
> +			enum ioremap_xmode xmode)

hm, there should be no need to use this raw API.

	Ingo
