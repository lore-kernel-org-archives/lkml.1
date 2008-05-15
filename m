Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYEOTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYEOTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762446AbYEOTJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:09:12 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42135 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762363AbYEOTJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:09:09 -0400
Date: Thu, 15 May 2008 12:09:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <matthew@wil.cx>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <20080515185130.GR9921@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com>
References: <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
 <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
 <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com>
 <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com>
 <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com>
 <20080515185130.GR9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Matthew Wilcox wrote:

> Or possibly your assumptions have been the main factor.  I gave you a
> reproducer for this problem 6 weeks ago.  As far as I can tell, you
> haven't run it since.

Assumptions may be the issue. My own "reproducer" for remote frees is 
available from my git tree and I usually prefer to run my own. We 
discussed the results of that program last fall. You stated yesterday that 
your code is proprietary. I am not sure what I am allowed to do with the 
code. I did not know that it was proprietary before yesterday and I would 
have just forwarded that code to Pekka yesterday if I would not have 
caught that message in time.

I thought that what you provided it was a test program to exercise 
and optimize the scsi subsystem?

> > > > You could just start with 2.6.25.X which already contains the slab 
> > > > statistics.
> > > 
> > > Certainly.  Exactly how does collecting these stats work?  Am I supposed
> > > to zero the counters after the TPC has done its initial ramp-up?  What
> > > commands should I run, and at exactly which points?
> > 
> > Compile slabinfo and then do f.e. slabinfo -AD (this is documented in the 
> > help text provided when enabling statistics).
> 
> That's an utterly unhelpful answer.  Let me try asking again.
> 
> Exactly how does collecting these stats work?  Am I supposed to zero
> the counters after the TPC has done its initial ramp-up?  What commands
> should I run, and at exactly which points?

There is no way of zeroing the counters. Run slabinfo -AD after the 
test application has been running for awhile. If you want a differential 
then you have to take two datapoints.
 
> Otherwise I'll get something wrong and these numbers will be useless to
> you.  Or that's what you'll claim anyway.

No. I guess I will end up with a lot of guess work of what is going on on 
the system since the information is limited for some reason.

> For reference the helptext says:
> 
>           SLUB statistics are useful to debug SLUBs allocation behavior in
>           order find ways to optimize the allocator. This should never be
>           enabled for production use since keeping statistics slows down
>           the allocator by a few percentage points. The slabinfo command
>           supports the determination of the most active slabs to figure
>           out which slabs are relevant to a particular load.
>           Try running: slabinfo -DA
> 
> By the way, when you say 'compile slabinfo', you mean the file shipped
> as Documentation/vm/slabinfo.c (rather than, say, something out of tree?)

Yes. 
