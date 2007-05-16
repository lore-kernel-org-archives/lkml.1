Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbXEPG7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbXEPG7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXEPG7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:59:37 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:61182 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751581AbXEPG7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:59:37 -0400
Subject: Re: [PATCH 0/5] make slab gfp fair
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <Pine.LNX.4.64.0705151457060.3155@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
	 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com>
	 <20070514161224.GC11115@waste.org>
	 <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
	 <1179164453.2942.26.camel@lappy>
	 <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
	 <1179170912.2942.37.camel@lappy> <1179250036.7173.7.camel@twins>
	 <Pine.LNX.4.64.0705151457060.3155@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 08:59:31 +0200
Message-Id: <1179298771.7173.16.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 15:02 -0700, Christoph Lameter wrote:
> On Tue, 15 May 2007, Peter Zijlstra wrote:
> 
> > How about something like this; it seems to sustain a little stress.
> 
> Argh again mods to kmem_cache.

Hmm, I had not understood you minded that very much; I did stay away
from all the fast paths this time.

The thing is, I wanted to fold all the emergency allocs into a single
slab, not a per cpu thing. And once you loose the per cpu thing, you
need some extra serialization. Currently the top level lock is
slab_lock(page), but that only works because we have interrupts disabled
and work per cpu.

Why is it bad to extend kmem_cache a bit?

