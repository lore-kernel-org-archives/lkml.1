Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXCTJpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXCTJpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbXCTJpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:45:42 -0400
Received: from amsfep19-int.chello.nl ([213.46.243.16]:55384 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753555AbXCTJpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:45:41 -0400
Subject: Re: [RFC][PATCH 0/6] per device dirty throttling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Chinner <dgc@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de,
       tomoki.sekiyama.qu@hitachi.com
In-Reply-To: <20070320093845.GQ32602149@melbourne.sgi.com>
References: <20070319155737.653325176@programming.kicks-ass.net>
	 <20070320074751.GP32602149@melbourne.sgi.com>
	 <1174378104.16478.17.camel@twins>
	 <20070320093845.GQ32602149@melbourne.sgi.com>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 10:45:38 +0100
Message-Id: <1174383938.16478.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 20:38 +1100, David Chinner wrote:
> On Tue, Mar 20, 2007 at 09:08:24AM +0100, Peter Zijlstra wrote:
> > On Tue, 2007-03-20 at 18:47 +1100, David Chinner wrote:
> > > So overall we've lost about 15-20% of the theoretical aggregate
> > > perfomrance, but we haven't starved any of the devices over a
> > > long period of time.
> > > 
> > > However, looking at vmstat for total throughput, there are periods
> > > of time where it appears that the fastest disk goes idle. That is,
> > > we drop from an aggregate of about 550MB/s to below 300MB/s for
> > > several seconds at a time. You can sort of see this from the file
> > > size output above - long term the ratios remain the same, but in the
> > > short term we see quite a bit of variability.
> > 
> > I suspect you did not apply 7/6? There is some trouble with signed vs
> > unsigned in the initial patch set that I tried to 'fix' by masking out
> > the MSB, but that doesn't work and results in 'time' getting stuck for
> > about half the time.
> 
> I applied the fixes patch as well, so i had all that you posted...

Humm, not that then.

> > >  but it's almost
> > > like it is throttling a device completely while it allows another
> > > to finish writing it's quota (underestimating bandwidth?).
> > 
> > Yeah, there is some lumpy-ness in BIO submission or write completions it
> > seems, and when that granularity (multiplied by the number of active
> > devices) is larger than the 'time' period over with we average
> > (indicated by vm_cycle_shift) very weird stuff can happen.
> 
> Sounds like the period is a bit too short atm if we can get into this
> sort of problem with only 2 active devices....

Yeah, trouble is, I significantly extended this period in 7/6.
Will have to ponder a bit on what is happening then.

Anyway, thanks for the feedback.

I'll try and reproduce the umount problem, maybe that will give some
hints.

