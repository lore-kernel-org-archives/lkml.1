Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbYD2Nbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbYD2Nbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755042AbYD2Nbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:31:45 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:31901 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbYD2Nbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:31:44 -0400
To: Amit Shah <amit.shah@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, chrisw@redhat.com, allen.m.kay@intel.com,
       linux-kernel@vger.kernel.org, gcosta@redhat.com, avi@qumranet.com,
       virtualization@lists.linux-foundation.org, BENAMI@il.ibm.com
Subject: Re: [PATCH] KVM PV Guest: Implement paravirtualized DMA
From: Andi Kleen <andi@firstfloor.org>
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com>
	<1209465451-3758-2-git-send-email-amit.shah@qumranet.com>
	<1209465451-3758-3-git-send-email-amit.shah@qumranet.com>
	<1209465451-3758-4-git-send-email-amit.shah@qumranet.com>
Date: Tue, 29 Apr 2008 15:31:32 +0200
In-Reply-To: <1209465451-3758-4-git-send-email-amit.shah@qumranet.com> (Amit Shah's message of "Tue, 29 Apr 2008 13:37:31 +0300")
Message-ID: <87od7shjnv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Apr 2008 13:24:39.0401 (UTC) FILETIME=[6062F590:01C8A9FC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@qumranet.com> writes:
> +
> +static struct page *page;
> +static unsigned long page_gfn;
Bad variable names

> +
> +const struct dma_mapping_ops *orig_dma_ops;

I suspect real dma ops stacking will need some further thought than
your simple hacks
> +
> +	match = find_matching_pt_dev(&pt_devs_head, &pv_pci_info);
> +	if (match) {
> +		r = match->is_pv;
> +		goto out;
> +	}
> +
> +	memcpy(page_address(page), &pv_pci_info, sizeof(pv_pci_info));

Note that on 32bit page_address() might be not mapped.


> +
> +	npages = get_order(size) + 1;

Are you sure that's correct? It looks quite bogus. order is a 2 logarithm,
normally npages = 1 << order

if you want  npages from order the correct  need 1 << order

Haven't read further, but to be honest the code doesn't seem to be anywhere
near merging quality.

-Andi

