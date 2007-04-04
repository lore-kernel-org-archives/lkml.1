Return-Path: <linux-kernel-owner+w=401wt.eu-S1751068AbXDDQtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068AbXDDQtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXDDQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:49:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:35096 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbXDDQtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:49:08 -0400
Date: Wed, 4 Apr 2007 18:48:48 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Dan Aloni <da-x@monatomic.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-ID: <20070404164848.GN19587@v2.random>
References: <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de> <Pine.LNX.4.64.0704041023040.17341@blonde.wat.veritas.com> <20070404102407.GA529@wotan.suse.de> <20070404122701.GB19587@v2.random> <20070404135530.GA29026@localdomain> <20070404141457.GF19587@v2.random> <20070404144421.GA13762@localdomain> <20070404152717.GG19587@v2.random> <20070404161515.GB24339@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404161515.GB24339@localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Wed, Apr 04, 2007 at 07:15:15PM +0300, Dan Aloni wrote:
> The main difference is that disk-backed swap can create I/O pressure which
> would slow down the swap-outs that are not of zeroed pages (and other I/Os
> on that disk for that matter). For purely-RAM virtual memory the latency 
> incured from managing newly allocated and zeroed pages is neglegible 
> compared to the latencies you get from reading/flushing those pages to 
> disk if you add swap to the picture.

Sorry but you're telling me the obvious... clearly you're right, swap
is slower, ram is faster. As a corollary on a 64bit system you could
always throw money at ram and _guarantee_ that those anon read page
faults never hit swap. That's not the point.

If 4G more of virtual memory are allocated in the address space of a
task because of this kernel change, it's the same problem if those 4G
are later allocated in swap or in ram depending on the runtime
environment of the kernel. The problem is that 4G more will be
allocated, it doesn't matter _where_. The user with a 8G system will
not be slowed down much, the user with a 128M system will trash beyond
repair, but it's the same problem for both. If the new ram will go
into ram or swap is irrelevant because it's an unknown variable that
depends on the amount of ram and swap and on what else is running
(infact there will be a third guy with even less luck that will go out
of memory and crash after hitting an oom killer bug ;), it's the same
problem in all three cases.
