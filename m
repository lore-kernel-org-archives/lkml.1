Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYHNNix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYHNNix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750980AbYHNNin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:38:43 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:44401 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbYHNNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:38:43 -0400
Date: Thu, 14 Aug 2008 14:39:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc][patch] mm: dirty page accounting race fix
In-Reply-To: <1218718149.10800.224.camel@twins>
Message-ID: <Pine.LNX.4.64.0808141421550.14452@blonde.site>
References: <20080814094537.GA741@wotan.suse.de>  <Pine.LNX.4.64.0808141210200.4398@blonde.site>
 <1218718149.10800.224.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Peter Zijlstra wrote:
> On Thu, 2008-08-14 at 12:55 +0100, Hugh Dickins wrote:
> 
> > But holding the page table lock on one pte of the
> > page doesn't guarantee much about the integrity of the whole dance:
> > do_wp_page does its set_page_dirty_balance for this case, you'd
> > need to spell out the bad sequence more to convince me.
>  
> Now you're confusing me... are you saying ptes can be changed from under
> your feet even while holding the pte_lock?

Well, yes, dirty and accessed can be changed from another thread in
userspace while we hold pt lock in the kernel.  (But dirty could only
be changed if the pte is writable, and in dirty balancing cases that
should be being prevented.)

But no, that isn't what I was thinking of.  pt lock better be enough
to secure against kernel modifications to the pte.  I was just thinking
there are (potentially) all those other ptes of the page, and this pte
may be modified the next instant, it wasn't obvious to me that missing
the one is so terrible.

Give me time, please don't let me confuse you, one of us is enough.

Hugh
