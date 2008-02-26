Return-Path: <linux-kernel-owner+w=401wt.eu-S1765056AbYBZV1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765056AbYBZV1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761540AbYBZV1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:27:06 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:4166 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbYBZV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:27:04 -0500
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, ak@suse.de,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20080226114417.c8948b61.pj@sgi.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
	 <20080226114417.c8948b61.pj@sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 26 Feb 2008 16:27:09 -0500
Message-Id: <1204061229.5309.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 11:44 -0600, Paul Jackson wrote:
> David,
> 
> Perhaps I missed it, but could you elaborate on what sort of testing
> these patches for MPOL_F_RELATIVE_NODES and MPOL_F_STATIC_NODES have
> received?
> 
> The main reason I didn't push my version of these patches in December
> was I figured it would take a week or three of obsessive-compulsive
> testing to verify that we didn't break various corner cases of the
> mbind/mempolicy system call interface.
> 
> In particular, do we know that Oracle works with this?  At least in
> years past, when Andi was the primary developer here, he had some
> good and detailed awareness of what it took to keep Oracle happy
> with this NUMA memory policy apparatus.  I don't know if we still
> have that awareness.
> 

I've recently been "playing with" Andi's numactl/libnuma/mempolicy
regression tests on 25-rc2-mm1.  I found a couple of problems caused by
changes in behavior on newer kernels--not in the mempolicy area, but in
a couple of the tests themselves and in numastat, used by the primary
mempolicy regression test.  I haven't seen any discussion of these
issues on the mailing lists, or I missed it.  So, I've attempted my own
fixes.

I have placed a tarball containing patches against numactl-1.0.2 sources
at:
http://free.linux.hp.com/~lts/Patches/Numactl/numactl-1.0.2-patches-080226.tar.gz

See the patch descriptions for more info.  The individual patches and
series live in the same Numactl directory for easy browsing.

The numactl-1.0.2 sources are located in Andi's repository at:

	ftp://ftp.suse.com/pub/people/ak/numa/numactl-1.0.2.tar.gz

With [3(1) of] these patches, the regression tests pass on my x86_64
NUMA test platform [4 socket/node, dual core, 32GB] on 2.6.25-rc2-mm1
with and without Mel Gorman's "two zonelist" patch series.  I haven't
gotten around to checking out David's latest series yet, nor have I
tried Andi's tests with cpusets.  I don't know whether the tests will
pass in arbitrary cpusets--I expect not.  It's on my list.  In any case,
you can grab the patches if you want to regression test your own
patches.

Regards,
Lee

(1) patches required for regression tests:

numastat-01-fix-report-order-for-new-kernels.patch
regress2-01-fix-checkaffinity-numnodes-calc.patch
regress2-02-checktopology-numnodes-calc.patch

regress-01-reorg-and-annotate.patch is just a "beautification" [in the
eye of the beholder, of course] patch so that I could figure out what
was going on.


	

