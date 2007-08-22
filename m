Return-Path: <linux-kernel-owner+w=401wt.eu-S1763723AbXHVTF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763723AbXHVTF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbXHVTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:04:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42814 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764974AbXHVTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:04:52 -0400
Date: Wed, 22 Aug 2007 12:04:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel <riel@redhat.com>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <1187766156.6114.280.camel@twins>
Message-ID: <Pine.LNX.4.64.0708221157180.13813@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com>  <1187692586.6114.211.camel@twins>
  <Pine.LNX.4.64.0708211347480.3082@schroedinger.engr.sgi.com> 
 <1187730812.5463.12.camel@lappy>  <Pine.LNX.4.64.0708211418120.3267@schroedinger.engr.sgi.com>
  <1187734144.5463.35.camel@lappy>  <Pine.LNX.4.64.0708211532560.5728@schroedinger.engr.sgi.com>
 <1187766156.6114.280.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Peter Zijlstra wrote:

> Its unavoidable, at some point it just happens. Also using reclaim
> doesn't seem like the ideal way to get out of live-locks since reclaim
> itself can live-lock on these large boxen.

If reclaim can live lock then it needs to be fixed.

> As shown, there are cases where there just isn't any memory to reclaim.
> Please accept this.

That is an extreme case that AFAIK we currently ignore and could be 
avoided with some effort. The initial PF_MEMALLOC patchset seems to be 
still enough to deal with your issues.

> Also, by reclaiming memory and getting out of the tight spot you give
> the rest of the system access to that memory, and it can be used for
> other things than getting out of the tight spot.

The rest of the system may have their own tights spots. Language the "the 
tight spot" sets up all sort of alarms over here since you seem to be 
thinking about a system doing a single task. The system may be handling 
multiple critical tasks on various devices that have various memory needs. 
So multiple critical spots can happen concurrently in multiple 
application contexts.

> You really want a separate allocation state that allows only reclaim to
> access memory.

We have that with PF_MEMALLOC.

> Also, failing a memory allocation isn't bad, why are you so worried
> about that? It happens all the time.

Its a performance impact and plainly does not make sense if there is 
reclaimable memory availble. The common action of the vm is to reclaim if 
there is a demand for memory. Now we suddenly abandon that approach?
