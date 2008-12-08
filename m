Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYLHXBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYLHXBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYLHXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:01:03 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:50779 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbYLHXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:01:02 -0500
Date: Mon, 8 Dec 2008 18:00:47 -0500
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-ID: <20081208230047.GC2501@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>,
	linux kernel <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
References: <4936D287.6090206@cosmosbay.com> <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org> <20081208221241.GA2501@mit.edu> <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 11:20:35PM +0100, Peter Zijlstra wrote:
> 
> atomic_t is pretty good on all archs, but you get to keep the cacheline
> ping-pong.
> 

Stupid question --- if you're worried about cacheline ping-pongs, why
aren't each cpu's delta counter cacheline aligned?  With a 64-byte
cache-line, and a 32-bit counters entry, with less than 16 CPU's we're
going to be getting cache ping-pong effects with percpu_counter's,
right?  Or am I missing something?

						- Ted

