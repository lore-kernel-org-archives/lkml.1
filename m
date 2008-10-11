Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYJKNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYJKNFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 09:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYJKNEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 09:04:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42131 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbYJKNEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 09:04:51 -0400
Date: Sat, 11 Oct 2008 15:11:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
Message-ID: <20081011131115.GB12131@one.firstfloor.org>
References: <20081009171453.GA15321@redhat.com> <200810111929.19891.nickpiggin@yahoo.com.au> <20081011112218.GA12131@one.firstfloor.org> <200810112242.28229.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810112242.28229.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > That would be nice. It would be interesting to know what is causing
> > > the slowdown.
> >
> > At least that test is extremly cache footprint sensitive. A lot of the
> > cache misses are surprisingly in hd_struct, because it runs
> > with hundred of disks and each needs hd_struct references in the fast path.
> > The recent introduction of fine grained per partition statistics
> > caused a large slowdown. But I don't think kernel workloads
> > are normally that extremly cache sensitive.
> 
> That's interesting. struct device is pretty big. I wonder if fields

Yes it is (it actually can be easily shrunk -- see willy's recent
patch to remove the struct completion from knodes), but that won't help 
because it will always
be larger than a cache line and it's in the middle, so the 
accesses to first part of it and last part of it will be separate.

> couldn't be rearranged to minimise the fastpath cacheline footprint?
> I guess that's already been looked at?

Yes, but not very intensively. So far I was looking for more 
detailed profiling data to see the exact accesses.

Of course if you have any immediate ideas that could be tried too.

-Andi

-- 
ak@linux.intel.com
