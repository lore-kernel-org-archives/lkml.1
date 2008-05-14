Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719AbYENVnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbYENVnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYENVna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:43:30 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40883 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYENVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:43:28 -0400
Date: Wed, 14 May 2008 15:43:27 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080514214326.GF9921@parisc-linux.org>
References: <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com> <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com> <20080514212130.GD9921@parisc-linux.org> <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 02:33:11PM -0700, Christoph Lameter wrote:
> On Wed, 14 May 2008, Matthew Wilcox wrote:
> 
> > > No. I thought you were satisfied with the performance increase you saw 
> > > when pinning the process to a single processor?
> > 
> > Er, no.  That program emulates a TPC-C run from the point of view of
> > doing as much IO as possible from all CPUs.  Pinning the process to one
> > CPU would miss the point somewhat.
> 
> Oh. The last message I got was an enthusiatic report on the performance 
> gains you saw by pinning the process after we looked at slub statistics 
> that showed that the behavior of the tests was different from your 
> expectations. I got messages here that indicate that this was a scsi 
> testing program that you had under development. And yes we saw the remote 
> freeing degradations there.

What I said was:

: I've also been playing around with locking the scsi_ram_0 thread to
: one CPU and it has a huge effect on the numbers.

: So we can see that scsi_ram_0 is clearly wandering between the two
: CPUs normally; it takes up a significant (3 seconds ~= 7-8%) of the
: execution time, and that locking it to one CPU (which interrupts tend
: to be) improves the number of ops per second ... even of the CPU which
: is forced to take all the extra work of running it!

Note the complete lack of comparison between slub and slab here!  As far
as I know, slub still loses against slab by a few % -- but I haven't
finished running a comparison with -rc2 yet.

> > I seem to remember telling you that you might get more realistic
> > performance numbers by pinning the scsi_ram_0 kernel thread to a single
> > CPU (ie emulating an interrupt tied to one CPU rather than letting the
> > scheduler choose to run the thread on the 'best' CPU).
> 
> If this is a stand in for the TPC then why did you not point that 
> out when Pekka and I recently asked you to retest some configurations?

I thought you'd already run this test and were asking for the results of
this to be validated against a real TPC run.

I'm rather annoyed by this.  You demand a test-case to reproduce the
problem and then when I come up with one, you ignore it!

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
