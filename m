Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbXDBPyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbXDBPyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXDBPyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:54:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48158 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932962AbXDBPyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:54:23 -0400
Date: Mon, 2 Apr 2007 08:54:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704021744.39880.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704020851300.30394@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <200704011246.52238.ak@suse.de> <Pine.LNX.4.64.0704020832320.30394@schroedinger.engr.sgi.com>
 <200704021744.39880.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007, Andi Kleen wrote:

> > Correct. 2MB worth of struct page is 128 mb of memory. Are there nodes 
> > with smaller amounts of memory? 
> 
> Yes the discontigmem minimum is 64MB and there are some setups
> (mostly with numa emulation) where you end up with nodes that small.

Ok. Then I guess we cannot remove discontigmem.
 
> BTW there is no guarantee the node size is a multiple of 128MB so
> you likely need to handle the overlap case. Otherwise we can 
> get cache corruptions

How does sparsemem handle that?

> Sparsemem is still quite experimental; discontigmem is the default
> on x86-64.

Ok more fodder for preserving the choice.

> > > Do you have any benchmarks numbers to prove it? There seem to be a few
> > > benchmarks where the discontig virt_to_page is a problem
> > > (although I know ways to make it more efficient), and sparsemem
> > > is normally slower. Still some numbers would be good.
> > 
> > You want a benchmark to prove that the removal of memory references and 
> > code improves performance?
> 
> You're just moving them into MMU, not really removing it.  And need more TLB entries.

No no no. For the gazillions time: All of 1-1 mapped kernel memory on 
x86_64 needs a 2 MB page table entry. The virtual memmap uses the same. 
There are *no* additional TLBs used.

> It might be faster or it might not. There are some unexpected issues, like most x86-64 
> CPUs have a quite small number of large TLBs so you can get thrashing etc.
> 
> So numbers with TLB intensive workloads would be good. 

You did not read the descriptions. Sigh.

