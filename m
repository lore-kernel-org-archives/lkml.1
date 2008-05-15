Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYEORPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYEORPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYEORPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:15:36 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53478 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750759AbYEORPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:15:35 -0400
Date: Thu, 15 May 2008 10:15:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
In-Reply-To: <1210802095.4093.109.camel@calx>
Message-ID: <Pine.LNX.4.64.0805151006350.18354@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>  <20080510030919.604216074@sgi.com>
 <4825709A.2020407@firstfloor.org>  <20080510221515.3540a6cc@bree.surriel.com>
  <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com> 
 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com> 
 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> 
 <482B2617.5010605@firstfloor.org>  <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
  <1210789112.4093.14.camel@calx>  <Pine.LNX.4.64.0805141220440.16223@schroedinger.engr.sgi.com>
  <1210794563.4093.57.camel@calx>  <Pine.LNX.4.64.0805141333060.18231@schroedinger.engr.sgi.com>
  <1210798978.4093.82.camel@calx>  <Pine.LNX.4.64.0805141405350.19073@schroedinger.engr.sgi.com>
 <1210802095.4093.109.camel@calx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008, Matt Mackall wrote:

> > If we would strip the NUMA stuff out and make it an SMP only allocator for 
> > enterprise apps then the code may become much smaller and simpler. I guess 
> > Arjan suggested something similar in the past. But that would result in 
> > SLAB no longer being a general allocator.
> 
> What does this have to do with anything? I'm not talking about going
> back to SLAB. I'm talking about plugging the use cases where SLUB
> currently loses to SLAB. That's what has to happen before SLAB can be
> obsoleted.

Both allocators have a different design which leads to different behavior. 
I do not think the expectation that one must always best the other is 
reasonable or even possible.

I'd be glad if we had some means of increasing the performance in the 
currently known cases where remote slab free becomes an issue by avoiding 
the atomic op.

AFAICT we so far have been able to compensate for the additional atomic op 
with a reduced cache footprint and less complexity overall on remote frees 
and also through improvements in alloc behavior. I hope that the current 
improvements in 2.6.26 are sufficient to address the concerns with TP-C 
(which I do not have direct access to and frankly I know very little about 
the setup etc). We are still not sure exactly why TP-C has a problem. The 
slab statistics were added to figure that one out. We can get a view of 
what is going on without having access to the system.

I think the current way of compensating for that atomic op is better than 
getting back to the queue mess. Maybe there is a way of limited use of 
queues that avoids the atomic op but so far I have not 
found one. Maybe someone else looking at it will have better ideas.
