Return-Path: <linux-kernel-owner+w=401wt.eu-S1767310AbXDEVDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767310AbXDEVDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767311AbXDEVDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:03:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:57012 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767310AbXDEVDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:03:45 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: What protects cpu_tlbstate?
Date: Thu, 5 Apr 2007 23:03:35 +0200
User-Agent: KMail/1.9.6
Cc: Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4615518A.4070003@goop.org> <200704052228.36590.ak@suse.de> <46156366.70206@goop.org>
In-Reply-To: <46156366.70206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704052303.35846.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 23:00:22 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > The interrupts can only happen when the other CPU is already lazy
> > and enter_lazy_tlb would be a nop then.  The flushers itself are
> > synchronized by the page_table_lock or the mm semaphore.
> >
> > Against switch_mm it tries to protect with ordering.
> >
> > wmb()s are not needed on x86 (ok minus errata on ppro and
> > VIA magic mode but which is UP only). That would leave some rmb()s,
> > but I don't see any place they would be needed. 
> >   
> 
> Hm, I was more wondering about simple compiler reordering.  Does the
> relative order of setting and reading cpu_tlbstate.state, active_mm and
> the mm->cpu_vm_mask matter?

Hmm, perhaps a barrier between state and active_mm might be a good idea.
Setting active_mm after state might be problematic.
cpu_vm_mask should be already a memory barrier.

-Andi
