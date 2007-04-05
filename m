Return-Path: <linux-kernel-owner+w=401wt.eu-S1767304AbXDEVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767304AbXDEVA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767309AbXDEVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:00:59 -0400
Received: from gw.goop.org ([64.81.55.164]:34072 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767304AbXDEVA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:00:58 -0400
Message-ID: <46156366.70206@goop.org>
Date: Thu, 05 Apr 2007 14:00:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: What protects cpu_tlbstate?
References: <4615518A.4070003@goop.org> <200704052228.36590.ak@suse.de>
In-Reply-To: <200704052228.36590.ak@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The interrupts can only happen when the other CPU is already lazy
> and enter_lazy_tlb would be a nop then.  The flushers itself are
> synchronized by the page_table_lock or the mm semaphore.
>
> Against switch_mm it tries to protect with ordering.
>
> wmb()s are not needed on x86 (ok minus errata on ppro and
> VIA magic mode but which is UP only). That would leave some rmb()s,
> but I don't see any place they would be needed. 
>   

Hm, I was more wondering about simple compiler reordering.  Does the
relative order of setting and reading cpu_tlbstate.state, active_mm and
the mm->cpu_vm_mask matter?

    J
