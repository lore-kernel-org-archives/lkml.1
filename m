Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXCZG2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXCZG2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 02:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933612AbXCZG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 02:28:13 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:4792 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933626AbXCZG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 02:28:12 -0400
X-AuditID: d80ac287-94e6abb000000c42-45-460767c61b2d 
Date: Mon, 26 Mar 2007 07:27:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Zachary Amsden <zach@vmware.com>
cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] i386: add ptep_test_and_clear_{dirty,young}
In-Reply-To: <4607713F.6010900@vmware.com>
Message-ID: <Pine.LNX.4.64.0703260721490.18961@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703251731040.19025@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0703260631150.15998@blonde.wat.veritas.com> <4607713F.6010900@vmware.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 26 Mar 2007 06:27:18.0107 (UTC) FILETIME=[CD60BAB0:01C76F6F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Mar 2007, Zachary Amsden wrote:
> 
> If you actually clear the bit, you need to:
> 
> +         pte_update_defer(vma->vm_mm, addr, ptep);
> 
> The reason is, when updating PTEs, the hypervisor must be notified.  Using
> atomic operations to do this is fine for all hypervisors I am aware of.
> However, for hypervisors which shadow page tables, if these PTE modifications
> are not trapped, you need a post-modification call to fulfill the update of
> the shadow page table.

Thanks for the very rapid response.

So, David just needs to move the pte_update_defer out of
ptep_clear_flush_* and into ptep_test_and_clear_*?

That leaves me wondering why you deleted ptep_test_and_clear_*
(while leaving their __HAVE_ARCHes) in the first place?

Hugh
