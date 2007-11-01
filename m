Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbXKAW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbXKAW6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXKAW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:58:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56247
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754322AbXKAW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:58:06 -0400
Date: Thu, 01 Nov 2007 15:58:05 -0700 (PDT)
Message-Id: <20071101.155805.65012933.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711011511450.22508@schroedinger.engr.sgi.com>
	<20071101.153824.91808126.davem@davemloft.net>
	<Pine.LNX.4.64.0711011545370.23379@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 1 Nov 2007 15:48:00 -0700 (PDT)

> On Thu, 1 Nov 2007, David Miller wrote:
> 
> > From: Christoph Lameter <clameter@sgi.com>
> > Date: Thu, 1 Nov 2007 15:15:39 -0700 (PDT)
> > 
> > > After boot is complete we allow the reduction of the size of the per cpu 
> > > areas . Lets say we only need 128k per cpu. Then the remaining pages will
> > > be returned to the page allocator.
> > 
> > You don't know how much you will need.  I exhausted the limit on
> > sparc64 very late in the boot process when the last few userland
> > services were starting up.
> 
> Well you would be able to specify how much will remain. If not it will 
> just keep the 2M reserve around.
> 
> > And if I subsequently bring up 100,000 IP tunnels, it will exhaust the
> > per-cpu allocation area.
> 
> Each tunnel needs 4 bytes per cpu?

Each IP compression tunnel instance does an alloc_percpu().

Since you're the one who wants to change the semantics and guarentees
of this interface, perhaps it might help if you did some greps around
the tree to see how alloc_percpu() is actually used.  That's what
I did when I started running into trouble with your patches.

You cannot put limits of the amount of alloc_percpu() memory available
to clients, please let's proceed with that basic understanding in
mind.  We're wasting a ton of time discussing this fundamental issue.
