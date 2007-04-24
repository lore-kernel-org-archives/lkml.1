Return-Path: <linux-kernel-owner+w=401wt.eu-S1422910AbXDXRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422910AbXDXRzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422931AbXDXRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:55:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51530 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422910AbXDXRzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:55:46 -0400
Date: Tue, 24 Apr 2007 10:55:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: William Lee Irwin III <wli@holomorphy.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
In-Reply-To: <20070424175001.GF5475@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0704241054270.8592@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704201223280.21417@schroedinger.engr.sgi.com>
 <20070420192906.GB2986@holomorphy.com> <Pine.LNX.4.64.0704201231250.21514@schroedinger.engr.sgi.com>
 <20070420193856.GC2986@holomorphy.com> <Pine.LNX.4.64.0704201243280.21514@schroedinger.engr.sgi.com>
 <20070420200322.GD2986@holomorphy.com> <20070420201101.GC5475@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0704241039110.8341@schroedinger.engr.sgi.com>
 <20070424174226.GE5475@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0704241045160.8418@schroedinger.engr.sgi.com>
 <20070424175001.GF5475@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Siddha, Suresh B wrote:

> On Tue, Apr 24, 2007 at 10:47:45AM -0700, Christoph Lameter wrote:
> > On Tue, 24 Apr 2007, Siddha, Suresh B wrote:
> > > Anyhow, this is a straight forward optimization and needs to be done. Do you
> > > have any specific concerns?
> > 
> > Yes there should not be contention on per cpu data in principle. The 
> > point of per cpu data is for the cpu to have access to contention free 
> > cachelines.
> > 
> > If the data is contented then it should be moved out of per cpu data and properly 
> > placed to minimize contention. Otherwise we will get into cacheline 
> > aliases (__read_mostly in per cpu??) etc etc in the per cpu areas.
> 
> yes, we were planning to move this to a different percpu section, where
> all the elements in this new section will be cacheline aligned(both
> at the start, aswell as end)

I would not call this a per cpu area. It is used by multiple cpus it 
seems. But for 0.5%? on what benchmark? Is is really worth it?

