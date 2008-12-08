Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbYLHXIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbYLHXIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYLHXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:08:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbYLHXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:08:27 -0500
Date: Mon, 8 Dec 2008 15:07:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: a.p.zijlstra@chello.nl, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-Id: <20081208150724.37761534.akpm@linux-foundation.org>
In-Reply-To: <20081208230047.GC2501@mit.edu>
References: <4936D287.6090206@cosmosbay.com>
	<4936EB04.8000609@cosmosbay.com>
	<20081206202233.3b74febc.akpm@linux-foundation.org>
	<493BCF60.1080409@cosmosbay.com>
	<20081207092854.f6bcbfae.akpm@linux-foundation.org>
	<493C0F40.7040304@cosmosbay.com>
	<20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	<20081208221241.GA2501@mit.edu>
	<1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
	<20081208230047.GC2501@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008 18:00:47 -0500
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
> > 
> > atomic_t is pretty good on all archs, but you get to keep the cacheline
> > ping-pong.
> > 
> 
> Stupid question --- if you're worried about cacheline ping-pongs, why
> aren't each cpu's delta counter cacheline aligned?

They are allocated with alloc_percpu(), so each CPU's counter lives
in a per-cpu area.  If you chase through seventeen layers of Rustyness
you end up at mm/allocpercpu.c:percpu_populate() which is where that
little s32 ends up getting allocated.
