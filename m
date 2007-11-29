Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbXK2KaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbXK2KaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:30:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbXK2K3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:29:51 -0500
Received: from mail.suse.de ([195.135.220.2]:33292 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbXK2K3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:29:50 -0500
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
References: <474C34CC.6060509@gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Nov 2007 11:29:48 +0100
In-Reply-To: <474C34CC.6060509@gmail.com>
Message-ID: <p734pf59wf7.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> writes:
> 
> - We properly flush TLB entries that change. This used to not be the case, and so we

For low values of "properly" @)

> +	pte = lookup_address(addr);
> +	change_page_attr(page, 1, __pgprot(pte->pte_low | _PAGE_VISIBLE));
> +	__flush_tlb_one(addr);

That's not enough, you need to flush all CPUs.

Also when you don't call global_flush_tlb() eventually because c_p_a() will leak flush
objects over time.

-Andi

