Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYFKAEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYFKAEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYFKAED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:04:03 -0400
Received: from ozlabs.org ([203.10.76.45]:33677 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYFKAEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:04:02 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Wed, 11 Jun 2008 10:03:36 +1000
User-Agent: KMail/1.9.9
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <20080530035620.587204923@sgi.com> <200806101256.31615.rusty@rustcorp.com.au> <Pine.LNX.4.64.0806092012240.13024@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806092012240.13024@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806111003.37167.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008 13:18:25 Christoph Lameter wrote:
> On Tue, 10 Jun 2008, Rusty Russell wrote:
> > > Right that is what the cpu alloc patches do. So you could implement
> > > cpu_local_inc on top of some of the cpu alloc patches.
> >
> > Or you could just implement it today as a standalone patch.
>
> You need at least the zero basing to enable the use of the segment
> register on x86_64.

Indeed.  Works for i386 as is, but 64 bit will need that patch.

> > > But then the whole point of local_t is gone. Why not use atomic_t in
> > > the first place?
> >
> > Because some archs can do better.
>
> The argument does not make any sense. First you want to use atomic_t then
> not?

You're being obtuse.  See previous mail about the three possible 
implementations of local_t, and the comment in asm-generic/local.h.

The paths forward are clear:
1) Improve x86 local_t (mostly orthogonal to the others, but useful).
2) Implement extensible per-cpu areas.
3) Generalize per-cpu accessors.
4) Extend or replace the module.c per-cpu allocator to alloc from the other
   areas.
5) Convert alloc_percpu et al. to use the new code.

Hope that clarifies,
Rusty.
