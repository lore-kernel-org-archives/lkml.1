Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZCJWHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZCJWHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZCJWG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:06:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:35786 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZCJWG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:06:56 -0400
Date: Tue, 10 Mar 2009 22:05:06 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
cc: Matt Mackall <mpm@selenic.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org, penberg@cs.helsinki.fi, linux-mm@kvack.org
Subject: Re: PROBLEM: kernel BUG at mm/slab.c:3002!
In-Reply-To: <49B6B72B.7070408@hp.com>
Message-ID: <Pine.LNX.4.64.0903102148150.31262@blonde.anvils>
References: <49B68450.9000505@hp.com> <1236705532.3205.14.camel@calx> 
 <49B6A374.6040805@hp.com> <1236707030.3205.21.camel@calx> <49B6B72B.7070408@hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Alan D. Brunelle wrote:
> Matt Mackall wrote:
> > On Tue, 2009-03-10 at 13:29 -0400, Alan D. Brunelle wrote:
> >> Matt Mackall wrote:
> >>> On Tue, 2009-03-10 at 11:16 -0400, Alan D. Brunelle wrote:
> >>>> Running blktrace & I/O loads cause a kernel BUG at mm/slab.c:3002!.
> >>> Pid: 11346, comm: blktrace Tainted: G    B      2.6.29-rc7 #3 ProLiant
> >>> DL585 G5   
> >>>
> >>> That 'B' there indicates you've hit 'bad page' before this. That bug
> >>> seems to be strongly correlated with some form of hardware trouble.
> >>> Unfortunately, that makes everything after that point a little suspect.
> >>
> >> /If/ it were a hardware issue, that might explain the subsequent issue
> >> when I switched to SLUB instead...
> > 
> > Well it was almost certainly not a bug in SLAB itself (and your SLUB
> > test is obviously quite conclusive there). We'd have lots of reports.
> > It's probably too early to conclude it's hardware though.
> > 
> >> How does one look for "bad page reports"?
> > 
> > It'll look something like this (pasted from Google):
> > 
> >>>     kernel: Bad page state at free_hot_cold_page (in process 'beam',
> >>> page c1a95320)
> >>>     kernel: flags:0x40020118 mapping:f401adc0 mapped:0 count:0
> >>> private:0x00000000
> > 
> 
> Interestingly enough, I'm not seeing the kernel detect such things - but
> in going into the hardware server logs, a co-worker found "unrecoverable
> system errors" being detected at about the same times we're seeing the
> panics.

In 2.6.29-rc, the "B" taint should be associated with mm/page_alloc.c's
bad_page() KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
but it could also now come from mm/memory.c's print_bad_pte()
KERN_ALERT "BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
which replaces the old mm/rmap.c Eeeks, and some other cases too.

Hugh
