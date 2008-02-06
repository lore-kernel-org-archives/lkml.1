Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYBFT4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYBFT4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYBFTzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:55:54 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38251 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYBFTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:55:53 -0500
Date: Wed, 6 Feb 2008 19:55:36 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: John Heil <kerndev@sc-software.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Bug: 2.6.24-smp: Eeek! page_mapcount(page) went negative! (-1)
In-Reply-To: <Pine.LNX.4.64.0802061003370.4601@sc-software.com>
Message-ID: <Pine.LNX.4.64.0802061948380.32204@blonde.site>
References: <Pine.LNX.4.64.0802061003370.4601@sc-software.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008, kerndev@sc-software.com wrote:
> 
> Before digging into this myself (don't really have enought time),
> I thought I'd submit it here...

Thanks for the report.

> Feb  6 09:09:47 sc-software kernel: Eeek! page_mapcount(page) went negative!

These very often turn out the be due to bad RAM or some such:
worth running memtest86+ overnight when you can, though its
success wouldn't be conclusive.

> (-1)
> Feb  6 09:09:47 sc-software kernel:   page pfn = 12b1b1
> Feb  6 09:09:47 sc-software kernel:   page->flags = 80080014
> Feb  6 09:09:47 sc-software kernel:   page->count = 0

That's a free page which shouldn't have appeared in the pagetable.
It could be that there's a bit error somewhere in that pfn of 12b1b1.

> Feb  6 09:09:47 sc-software kernel:   page->mapping = 00000000
> Feb  6 09:09:47 sc-software kernel:   vma->vm_ops = 0x0
> Feb  6 09:09:47 sc-software kernel: ------------[ cut here ]------------
> Feb  6 09:09:47 sc-software kernel: kernel BUG at mm/rmap.c:631!
> Feb  6 09:09:47 sc-software kernel: invalid opcode: 0000 [#2] PREEMPT SMP
> Feb  6 09:09:47 sc-software kernel: Modules linked in: shpchp pci_hotplug
> ohci1394 ieee1394
> Feb  6 09:09:47 sc-software kernel:
> Feb  6 09:09:47 sc-software kernel: Pid: 3710, comm: X Tainted: G      D

But that [#2] and that D taint both say there was already a problem
before this: anything showing in the log for that?

Hugh
