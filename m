Return-Path: <linux-kernel-owner+w=401wt.eu-S964958AbXCAKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbXCAKxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 05:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXCAKxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 05:53:22 -0500
Received: from gw.goop.org ([64.81.55.164]:46844 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbXCAKxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 05:53:21 -0500
Message-ID: <45E6B0A1.8090106@goop.org>
Date: Thu, 01 Mar 2007 02:53:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] arch/i386/xen/: possible cleanups
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <20070301104817.GB10921@stusta.de>
In-Reply-To: <20070301104817.GB10921@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the following possible cleanups:
> - every file should #include the headers containing the prototypes for
>   it's global functions
>   - the xen_set_pud() prototype mismatch gcc was now able to detect
>     is corrected
> - make the following needlessly global variable static:
>   - events.c: virq_to_irq[]
> - make the following needlessly global functions static:
>   - setup.c: xen_idle()
>   - events.c: mask_evtchn()
>   - events.c: unmask_evtchn()
>   - mmu.c: xen_pgd_unpin()
> - remove the following unused variables:
>   - setup.c: pfn_to_mfn_frame_list
>   - setup.c: pfn_to_mfn_frame_list_list
> - #if 0 the following unused global function:
>   - mmu.c: xen_set_pte_atomic()
> - remove the following empty unused global functions:
>   - mmu.c: xen_pte_update()
>   - mmu.c: xen_pte_update_defer()
> - remove the following unused EXPORT_SYMBOL:
>   - setup.c: HYPERVISOR_shared_info
>   

Thanks Adrian.  I'd already done a lot of this locally, but I'll
double-check before posting.

>  struct shared_info *HYPERVISOR_shared_info = &init_shared;
> -EXPORT_SYMBOL(HYPERVISOR_shared_info);
>   

Are you sure?  I thought I added this because akpm was getting compile
errors with allmodconfig.

    J
