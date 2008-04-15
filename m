Return-Path: <linux-kernel-owner+w=401wt.eu-S932822AbYDOVVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbYDOVVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762015AbYDOVUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:20:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764435AbYDOVUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:20:16 -0400
Date: Tue, 15 Apr 2008 23:19:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       travis@sgi.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415211953.GA4243@elte.hu>
References: <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <20080415202805.GA26880@elte.hu> <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu> <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com> <20080415205820.GC31645@elte.hu> <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 15 Apr 2008, Ingo Molnar wrote:
> 
> > and the bug pattern seems to be memory corruption - not memory 
> > exhaustion.
> 
> SLUB does not do a memory allocation where it fails here but simply 
> accesses per cpu information that is expected to be already zeroed.
> 
> > i.e. we allocated RAM but it got corrupted after allocation.
> 
> In some situations we are screwing up the per cpu data handling on 32 
> bit x86? Adding Mike. This looks like the per cpu area overlaps with 
> something else?

yep, that was my other theory - and i doubled CONFIG_NR_CPUS to reduce 
that chance.

in hindsight ... that wont save us from any overlap, right?

what's the best way to artificially increase the size of the allocated 
per cpu area? (say double it)

	Ingo
