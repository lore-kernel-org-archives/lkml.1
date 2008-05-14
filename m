Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYENVyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYENVyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYENVyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:54:03 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58786 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752348AbYENVyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:54:00 -0400
Date: Wed, 14 May 2008 14:53:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080514214326.GF9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805141444220.19897@schroedinger.engr.sgi.com>
References: <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com>
 <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com>
 <20080514212130.GD9921@parisc-linux.org> <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com>
 <20080514214326.GF9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matthew Wilcox wrote:

> > Oh. The last message I got was an enthusiatic report on the performance 
> > gains you saw by pinning the process after we looked at slub statistics 
> > that showed that the behavior of the tests was different from your 
> > expectations. I got messages here that indicate that this was a scsi 
> > testing program that you had under development. And yes we saw the remote 
> > freeing degradations there.
> 
> What I said was:
> 
> : I've also been playing around with locking the scsi_ram_0 thread to
> : one CPU and it has a huge effect on the numbers.
> 
> : So we can see that scsi_ram_0 is clearly wandering between the two
> : CPUs normally; it takes up a significant (3 seconds ~= 7-8%) of the
> : execution time, and that locking it to one CPU (which interrupts tend
> : to be) improves the number of ops per second ... even of the CPU which
> : is forced to take all the extra work of running it!


The last message that I got on March 31st said:

>>I have a version below which tries to start the tasks at a similar time
>by using pause() and then signalling to wake all the tasks up.  I don't
>?know a better way to start threads simultaneously ... maybe MAP_SHARED a
>file and write to it in one task while spinning in the other tasks
>waiting for it to change value?

>I've also been playing around with locking the scsi_ram_0 thread to one
>CPU and it has a huge effect on the numbers.

This indicated to me that you were still developing a test here and 
discovered some startling things.

> Note the complete lack of comparison between slub and slab here!  As far
> as I know, slub still loses against slab by a few % -- but I haven't
> finished running a comparison with -rc2 yet.

Indeed remote frees are slightly slower in some situations. Dont really 
dispute that. I am just not sure that the TPC test is really suffering 
from that symptom. I thought for a long time that the tbench regression 
was due to a similar effect too until I got down to it.

> I thought you'd already run this test and were asking for the results of
> this to be validated against a real TPC run.

AFAICT the last state was that you were tinkering around with a test.

> I'm rather annoyed by this.  You demand a test-case to reproduce the
> problem and then when I come up with one, you ignore it!

Ignore it? That is pretty strange statement given that I helped you 
analyze the behavior of your test and understand what was going on the 
system.

