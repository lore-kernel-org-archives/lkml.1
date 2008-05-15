Return-Path: <linux-kernel-owner+w=401wt.eu-S1762117AbYEOSOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762117AbYEOSOZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbYEOSOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:14:15 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49627 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYEOSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:14:14 -0400
Date: Thu, 15 May 2008 12:13:56 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080515181356.GP9921@parisc-linux.org>
References: <20080510221515.3540a6cc@bree.surriel.com> <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:58:01AM -0700, Christoph Lameter wrote:
> On Thu, 15 May 2008, Matthew Wilcox wrote:
> 
> > On Thu, May 15, 2008 at 10:05:35AM -0700, Christoph Lameter wrote:
> > > Thanks for using the slab statistics. I wish I had these numbers for the 
> > > TPC benchmark. That would allow us to understand what is going on while it 
> > > is running.
> > 
> > Hang on, you want slab statistics for the TPC run?  You didn't tell me
> > that.  We're trying to gather oprofile data (and having trouble because
> > the machine crashes when we start using oprofile -- this is with the git
> > tree you/pekka put together for us to test).
> 
> Well we talked about this when you send me the test program. I just 
> thought that it would be logical to do the same for the real case.

You ran the test ... you didn't say "It would be helpful if you could
get these results for me for TPC-C".

> Details of the crash please?

I don't have any.

> You could just start with 2.6.25.X which already contains the slab 
> statistics.

Certainly.  Exactly how does collecting these stats work?  Am I supposed
to zero the counters after the TPC has done its initial ramp-up?  What
commands should I run, and at exactly which points?

> Also re: the test program since pinning a process does increase the 
> performance by orders of magnitude. Are you sure that the application was 
> properly tuned for an 8p configuration? Pinning is usually not necessary 
> for lower numbers of processors because the scheduler thrashing effect is 
> less of an issue.  If the test program is an accurate representation of 
> the TP-C benchmark then you can drastically increase its performance by 
> doing the same to the real test.

The application does nothing except submit IO and wait for it to complete.
It doesn't need to be tuned.  It's not an accurate representation of
TPC-C, it just simulates the amount of IO that a TPC-C run will generate
(and simulates it coming from all CPUs, which is accurate).

I don't want to get into details of how a TPC benchmark is tuned, because
it's not relevant.  Trust me, there are people who dedicate months of
their lives per year to tuning how TPC runs are scheduled.

The pinning I was talking about was pinning the scsi_ram_0 kernel thread
to one CPU to simulate interrupts being tied to one CPU.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
