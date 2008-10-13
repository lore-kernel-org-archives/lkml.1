Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbYJMOFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbYJMOFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYJMOFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:05:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753225AbYJMOFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:05:24 -0400
Message-ID: <48F37190.2020801@linux-foundation.org>
Date: Mon, 13 Oct 2008 09:04:32 -0700
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] hugetlbfs: handle pages higher order than MAX_ORDER
References: <1223458431-12640-1-git-send-email-apw@shadowen.org> <1223458431-12640-2-git-send-email-apw@shadowen.org> <48ECDD37.8050506@linux-foundation.org> <20081008185532.GA13304@brain> <48ED0B68.2060001@linux-foundation.org> <20081013133404.GC15657@brain>
In-Reply-To: <20081013133404.GC15657@brain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Currently memory hot remove is not supported with VMEMMAP.  Obviously
> that should be fixed overall and I am assuming it will.  But the fact
> remains that the buddy guarentee is that the mem_map is contigious out
> to MAX_ORDER-1 order pages only beyond that we may not assume
> contiguity.  This code is broken under the guarentees that are set out
> by buddy.  Yes it is true that we do only have one memory model combination
> currently where a greater guarentee of contigious within a node is
> violated, but right now this code violates the current guarentees.
>   
> I assume the objection here is the injection of the additional branch
> into these loops.  The later rejig patch removes this for the non-giant
> cases for the non-huge use cases.  Are we worried about these same
> branches in the huge cases?  If so we could make this support dependant
> on a new configuration option, or perhaps only have two loop chosen
> based on the order of the page.
>   
I think we are worried about these additional checks spreading further 
because there may be assumptions of contiguity elsewhere (in particular 
when new code is added) since the traditional nature of the memmap is to 
be linear and not spread out over memory.

A fix for this particular situation may be as simple as making gigantic 
pages depend on SPARSE_VMEMMAP? For x86_64 this is certainly sufficient.
> Something like the patch below?  This patch is not tested as yet, but if
> this form is acceptable we can get the pair of patches (this plus the
> prep compound update) tested together and I can repost them once that is
> done.  This against 2.6.27.
>   
What is the difference here to the earlier versions?

