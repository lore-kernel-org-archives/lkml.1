Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZBWRlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZBWRlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZBWRlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:41:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43883 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbZBWRlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:41:44 -0500
Date: Mon, 23 Feb 2009 17:41:38 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 04/20] Convert gfp_zone() to use a table of
	precalculated value
Message-ID: <20090223174138.GQ6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0902231003090.7298@qirst.com> <20090223163322.GN6740@csn.ul.ie> <alpine.DEB.1.10.0902231130280.3333@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902231130280.3333@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 11:33:00AM -0500, Christoph Lameter wrote:
> On Mon, 23 Feb 2009, Mel Gorman wrote:
> 
> > I was concerned with mispredictions here rather than the actual assembly
> > and gfp_zone is inlined so it's lot of branches introduced in a lot of paths.
> 
> The amount of speculation that can be done by the processor pretty
> limited to a few instructions. So the impact of a misprediction also
> should be minimal.

It really is quite a bit of code overall.

   text	   data	    bss	    dec	    hex	filename
4071245	 823620	 741180	5636045	 55ffcd	linux-2.6.29-rc5-vanilla/vmlinux
4070872	 823684	 741180	5635736	 55fe98 linux-2.6.29-rc5-convert-gfpzone/vmlinux

That's 373 bytes of text with oodles of branches. I don't know what the
cost of misprediction is going to be but surely this is having some impact
on the branch prediction tables?

> The decoder is likely to have sucked in the following
> code anyways.
> 

Probably. To be honest, measuring this would likely be tricker but this
is less branches and less code in a fast path. The question is if a
cache line of data is justified or not. Right now, I think it is but
I'll go with the general consensus if we can find one.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
