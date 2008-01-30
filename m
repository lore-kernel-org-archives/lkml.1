Return-Path: <linux-kernel-owner+w=401wt.eu-S1764638AbYA3TIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764638AbYA3TIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764293AbYA3TIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:08:16 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45949 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764283AbYA3TIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:08:15 -0500
Date: Wed, 30 Jan 2008 11:08:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Robin Holt <holt@sgi.com>
cc: Andrea Arcangeli <andrea@qumranet.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code
In-Reply-To: <20080130180207.GU26420@sgi.com>
Message-ID: <Pine.LNX.4.64.0801301104080.27491@schroedinger.engr.sgi.com>
References: <20080130022909.677301714@sgi.com> <20080130022944.236370194@sgi.com>
 <20080130180207.GU26420@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008, Robin Holt wrote:

> Index: git-linus/mm/mmu_notifier.c
> ===================================================================
> --- git-linus.orig/mm/mmu_notifier.c	2008-01-30 11:43:45.000000000 -0600
> +++ git-linus/mm/mmu_notifier.c	2008-01-30 11:56:08.000000000 -0600
> @@ -99,3 +99,8 @@ void mmu_rmap_notifier_unregister(struct
>  }
>  EXPORT_SYMBOL(mmu_rmap_notifier_unregister);
>  
> +void mmu_rmap_export_page(struct page *page)
> +{
> +	SetPageExternalRmap(page);
> +}
> +EXPORT_SYMBOL(mmu_rmap_export_page);

Then mmu_rmap_export_page would have to be called before the subsystem 
establishes the rmap entry for the page. Could we do all PageExternalRmap 
modifications under Pagelock?


