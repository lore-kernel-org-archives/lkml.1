Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbYCERjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbYCERjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYCERj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:39:29 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50170 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761907AbYCERj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:39:28 -0500
Date: Wed, 5 Mar 2008 17:38:28 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: preempt bug in set_pmd_pfn?
In-Reply-To: <47CECEE9.3000801@goop.org>
Message-ID: <Pine.LNX.4.64.0803051721200.13410@blonde.site>
References: <47CDBB87.8090906@goop.org> <20080304212821.GB8944@elte.hu>
 <47CDBEDC.1050302@goop.org> <20080305064814.GB28398@elte.hu>
 <Pine.LNX.4.64.0803051407310.22243@blonde.site> <47CECEE9.3000801@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Jeremy Fitzhardinge wrote:
> 
> If a thread goes from processor A -> B -> A, where A is first preempted
> between a pagetable update and a tlb flush, then the second time the thread
> runs on A may run with a stale tlb (if in the meantime A has either been idle
> or only running kernel threads).

Right, thanks, because __flush_tlb_one opts out of the full active_mm
checking which goes on for userspace mms (which covers, for example,
the case of preemption before dup_mmap's flush_tlb_mm).

But is there actually a case where there's a problem?  So far as I can see,
set_pmd_pfn is there solely for discontig_32's __init remap_numa_kva; and
set_pte_pfn is there solely for set_fixmap, which operates on a per-cpu
area of pagetable, which would already be in bigger trouble if preemption
to another cpu were possible.

Hugh
