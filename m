Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbYDOVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbYDOVI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYDOVIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:08:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:32937 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753855AbYDOVIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:08:17 -0400
Date: Tue, 15 Apr 2008 14:08:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       travis@sgi.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
In-Reply-To: <20080415205820.GC31645@elte.hu>
Message-ID: <Pine.LNX.4.64.0804151405120.3252@schroedinger.engr.sgi.com>
References: <20080415161532.GA15088@elte.hu>
 <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org>
 <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com>
 <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com>
 <20080415201734.GA25628@elte.hu> <20080415202805.GA26880@elte.hu>
 <20080415203405.GA27958@elte.hu> <20080415204208.GA30432@elte.hu>
 <Pine.LNX.4.64.0804151344340.1785@schroedinger.engr.sgi.com>
 <20080415205820.GC31645@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Apr 2008, Ingo Molnar wrote:

> and the bug pattern seems to be memory corruption - not memory 
> exhaustion.

SLUB does not do a memory allocation where it fails here but simply 
accesses per cpu information that is expected to be already zeroed.

> i.e. we allocated RAM but it got corrupted after allocation.

In some situations we are screwing up the per cpu data handling on 
32 bit x86? Adding Mike. This looks like the per cpu area overlaps with 
something else?



