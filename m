Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYFQAZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYFQAZQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYFQAZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:25:01 -0400
Received: from ozlabs.org ([203.10.76.45]:45724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbYFQAZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:25:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Tue, 17 Jun 2008 10:24:40 +1000
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Martin Peschke <mp3@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>
References: <20080530035620.587204923@sgi.com> <200806152033.02891.rusty@rustcorp.com.au> <Pine.LNX.4.64.0806160748050.19276@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0806160748050.19276@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806171024.40662.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 June 2008 00:52:08 Christoph Lameter wrote:
> On Sun, 15 Jun 2008, Rusty Russell wrote:
> > > 3. Some hooks for arches to override particular behavior as needed.
> > >    F.e. IA64 allocates percpu structures in a special way. x86_64
> > >    needs to do some tricks for the pda etc etc.
> >
> > IA64 is going to need some work, since dynamic percpu addresses won't be
> > able to use their pinned TLB trick to get the local version.
>
> The ia64 hook could simply return the address of percpu area that
> was reserved when the per node memory layout was generated (which happens
> very early during node bootstrap).

Apologies, this time I read the code.  I thought IA64 used the pinned TLB area 
to access per-cpu vars under some circumstances, but they only do that via an 
arch-specific macro.

So creating new congruent mappings to expand the percpu area(s) is our main 
concern now?

Rusty.
