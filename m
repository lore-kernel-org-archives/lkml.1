Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbXKAX44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbXKAX44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXKAX4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:56:47 -0400
Received: from ns2.suse.de ([195.135.220.15]:34216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbXKAX4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:56:46 -0400
Date: Fri, 2 Nov 2007 00:56:44 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071101235644.GA20144@wotan.suse.de>
References: <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org> <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org> <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org> <20071101023758.GA30613@wotan.suse.de> <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org> <20071101154705.GA745@wotan.suse.de> <alpine.LFD.0.999.0711010901290.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711010901290.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 09:08:45AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 Nov 2007, Nick Piggin wrote:
> > 
> > Untested patch follows
> 
> Ok, this looks ok.
> 
> Except I would remove the VM_MAYSHARE bit from the test.

But we do want to allow forced COW faults for MAP_PRIVATE mappings. gdb
uses this for inserting breakpoints (but fortunately, a COW page in a
MAP_PRIVATE mapping is a much more natural thing for the VM).


> That whole bit should go, in fact.
> 
> We used to make it something different: iirc, a read-only SHARED mapping 
> was downgraded to a non-shared mapping, because we wanted to avoid some of 
> the costs we used to have with the VM implementation (actually, I think it 
> was various filesystems that don't like shared mappings because they don't 
> have a per-page writeback). But we left the VM_MAYSHARE bit on, to get 
> /proc/<pid>/mmap things right.
> 
> Or something like that. I forget the details. But I *think* we don't 
> actually need this any more.
> 
> But basically, the "right" way to test for shared mappings is historically 
> to just test the VM_MAYSHARE bit - but not *both* bits. Because VM_SHARE 
> may have been artificially cleared.
 
I think you're right -- VM_MAYSHARE is basically testing for MAP_SHARED.
I just don't know exactly what you're proposing here.

Thanks,
Nick
