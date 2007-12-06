Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbXLFV2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbXLFV2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 16:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbXLFV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 16:28:08 -0500
Received: from phunq.net ([64.81.85.152]:38090 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755049AbXLFV2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 16:28:05 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Thu, 6 Dec 2007 13:27:59 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org
References: <200712051603.02183.phillips@phunq.net> <200712061204.14854.phillips@phunq.net> <20071206122701.85627fb4.akpm@linux-foundation.org>
In-Reply-To: <20071206122701.85627fb4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712061328.00247.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 December 2007 12:27, Andrew Morton wrote:
> On Thu, 6 Dec 2007 12:04:14 -0800
>
> Daniel Phillips <phillips@phunq.net> wrote:
> > Any idea
> > how to extend the accounting idea to all tasks involved in a
> > particular block device stack?
>
> SMOP, I'd have thought.

Agreed, which I realized as soon as the post was one minute old.  Sure, 
each helper for the device registers as a helper which puts a pointer 
in the task struct, which points to the accounting info so only one new 
field in task struct.  The more I ponder, the more doable it seems.

> As long as each piece of code which handles 
> data for this stack knows that it's handling data for that stack it
> should be able to account its memory allocations.

Don't forget that we do not actually have a usable notion of "block 
device stack" yet.  Perhaps you are just assuming that is 
easy/imminent?

> The tricky part will be networking allocations because a NIC can of
> course handle data for all sorts of consumers.  But I expect this can
> be greatly simplified with a few heuristics - work out how much
> memory your typical networking stack will allocate for a frame and
> tack that onto the total. Couple of pages worst case..

Actually, the same pattern that Peter and I developed for handling 
network deadlock extends to this accounting concept.  As you say, it's 
a SMOP.

Daniel
