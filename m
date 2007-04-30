Return-Path: <linux-kernel-owner+w=401wt.eu-S1422969AbXD3EoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422969AbXD3EoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 00:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422974AbXD3EoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 00:44:08 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52644 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422969AbXD3EoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 00:44:06 -0400
Date: Sun, 29 Apr 2007 21:44:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: vmstat: use our own timer events
In-Reply-To: <20070429011518.259448ba.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704292138480.1737@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704282206530.29468@schroedinger.engr.sgi.com>
 <20070429011518.259448ba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007, Andrew Morton wrote:

> > on each node at the second and then each of the other processor on a
> > node on a subsequent tick. That may be useful to keep a large amount
> > of the second free of timer activity. Maybe the timer folks will have
> > some feedback on this one?
> 
> The one-per-second timer interrupt will upset the people who are really
> aggressive about power consumption (eg, OLPC).  Perhaps there isn't (yet)
> an intersection between those people and SMP.

Well the cache_reaper of SLAB hits hard todays anyways. This will help
if they switch to slub because the counter consolidation is much lighter 
weight.

> However a knob to set the frequency would be nice, if it's not too
> expensive to implement.  Presumably anyone who cares enough will come along
> and add one, but then they have to wait for a long period for that change
> to propagate out to their users, which is a bit sad for something which we
> already knew about.

Ok will do.
 
> Having each CPU touch every zone looks a bit expensive - I'd have thought
> that it would be showing up a little on your monster NUMA machines?

Vmstat updates only touch cachelines that are node local. Data from
remote zones may be updated but pcps of those remote zones are for
this processor and have been placed local to the processor accessing them.

Thus no problem for monster NUMA.

> Oh dear.  Some of these new notifier types are added by a patch which is a
> few hundred patches later than slub.  I can park this patch after that one,
> but that introduces a risk that later slub patches will also get
> disconnected.

I am fine with delaying this. I just wanted the timer guys to have a 
chance to shape this a bit. Not sure what they want. What they did to the 
cache_reaper in 2.6.20/21 is bad.

