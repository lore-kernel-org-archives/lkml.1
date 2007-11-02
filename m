Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbXKBGal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbXKBGal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXKBGaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:30:19 -0400
Received: from ns2.suse.de ([195.135.220.15]:52313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbXKBGaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:30:13 -0400
Date: Fri, 2 Nov 2007 07:30:11 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071102063011.GB20967@wotan.suse.de>
References: <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org> <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org> <20071101023758.GA30613@wotan.suse.de> <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org> <20071101154705.GA745@wotan.suse.de> <alpine.LFD.0.999.0711010901290.3342@woody.linux-foundation.org> <20071101235644.GA20144@wotan.suse.de> <alpine.LFD.0.999.0711011816260.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711011816260.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 06:17:42PM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Nov 2007, Nick Piggin wrote:
> > 
> > But we do want to allow forced COW faults for MAP_PRIVATE mappings. gdb
> > uses this for inserting breakpoints (but fortunately, a COW page in a
> > MAP_PRIVATE mapping is a much more natural thing for the VM).
> 
> Yes, I phrased that badly. I meant that I'd be happier if we got rid of 
> VM_MAYSHARE entirely, and just used VM_SHARED. I thought we already made 
> them always be the same (and any VM_MAYSHARE use is historical).

Oh yeah, I think it would probably be clearer to use VM_SHARED == MAP_SHARED,
and test the write permission explicitly. Though there could be something
I missed that makes it not as easy as it sounds... probably something best
left for Hugh ;)

