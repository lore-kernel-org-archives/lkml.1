Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbYCCV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbYCCV0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763472AbYCCVXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:23:51 -0500
Received: from relay2.sgi.com ([192.48.171.30]:39419 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763358AbYCCVXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:23:50 -0500
Date: Mon, 3 Mar 2008 13:23:48 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <npiggin@suse.de>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <84144f020803031241l277aa3b8h2fe0714f5765cb49@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803031318310.4131@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de>  <20080303093529.GB15091@wotan.suse.de>
  <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com> 
 <20080303200355.GB8974@wotan.suse.de>  <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
  <20080303201211.GE8974@wotan.suse.de>  <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
  <20080303202411.GH8974@wotan.suse.de> <84144f020803031241l277aa3b8h2fe0714f5765cb49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Pekka Enberg wrote:

> Hmm... Can't we just fix SLAB_HWCACHE_ALIGN in SLUB to follow the
> semantics of SLAB?

AFAICT it follows SLAB semantics. The only small difference is for objects 
small than cache_line_size() / 2 where SLUB does not bother to align to a 
fraction of a cacheline since we are already placing multile object into a 
cacheline. We effectively have made the decision to give up the 
organization of objects in separatate cache lines.

Lets say you have a 64 byte cache line size. Then the alignment can be 
as follows. (8 byte alignment is the basic alignment requirement).

Objsize	[C	SLAB	SLUB
-----------------------------
> 64		X	X
33 .. 64	64	64
32		32	32
24		32	24	-> 3 object per cacheline sizes = 72 so overlap.
16		16	16
8		8	8

So there is only one difference for 24 byte sizes slabs.


