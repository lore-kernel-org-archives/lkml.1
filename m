Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYFJVet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYFJVet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbYFJVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:34:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753812AbYFJVej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:34:39 -0400
Date: Tue, 10 Jun 2008 14:33:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com,
       Paul Mundt <lethal@linux-sh.org>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-Id: <20080610143334.c53d7d8a.akpm@linux-foundation.org>
In-Reply-To: <20080610153702.4019e042@cuia.bos.redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	<20080608173244.0ac4ad9b@bree.surriel.com>
	<20080608162208.a2683a6c.akpm@linux-foundation.org>
	<20080608193420.2a9cc030@bree.surriel.com>
	<20080608165434.67c87e5c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806101214190.17798@schroedinger.engr.sgi.com>
	<20080610153702.4019e042@cuia.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 15:37:02 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Tue, 10 Jun 2008 12:17:23 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Sun, 8 Jun 2008, Andrew Morton wrote:
> > 
> > > And it will take longer to get those problems sorted out if 32-bt
> > > machines aren't even compiing the new code in.
> > 
> > The problem is going to be less if we dependedn on 
> > CONFIG_PAGEFLAGS_EXTENDED instead of 64 bit. This means that only certain 
> > 32bit NUMA/sparsemem configs cannot do this due to lack of page flags.
> > 
> > I did the pageflags rework in part because of Rik's project.
> 
> I think your pageflags work freed up a number of bits on 32
> bit systems, unless someone compiles a 32 bit system with
> support for 4 memory zones (2 bits ZONE_SHIFT) and 64 NUMA
> nodes (6 bits NODE_SHIFT), in which case we should still
> have 24 bits for flags.
> 
> Of course, having 64 NUMA nodes and a ZONE_SHIFT of 2 on
> a 32 bit system is probably total insanity already.  I
> suspect very few people compile 32 bit with NUMA at all,
> except if it is an architecture that uses DISCONTIGMEM
> instead of zones, in which case ZONE_SHIFT is 0, which
> will free up space too :)

Maybe it's time to bite the bullet and kill i386 NUMA support.  afaik
it's just NUMAQ and a 2-node NUMAish machine which IBM made (as400?)

arch/sh uses NUMA for 32-bit, I believe. But I don't know what its
maximum node count is.  The default for sh NODES_SHIFT is 3.  
