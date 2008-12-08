Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYLHXty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYLHXty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 18:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbYLHXtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 18:49:42 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37386 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134AbYLHXtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 18:49:41 -0500
Date: Mon, 8 Dec 2008 18:49:27 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, cmm@us.ibm.com, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
Message-ID: <20081208234927.GF2501@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, a.p.zijlstra@chello.nl,
	dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
	davem@davemloft.net, cmm@us.ibm.com, linux-ext4@vger.kernel.org
References: <4936EB04.8000609@cosmosbay.com> <20081206202233.3b74febc.akpm@linux-foundation.org> <493BCF60.1080409@cosmosbay.com> <20081207092854.f6bcbfae.akpm@linux-foundation.org> <493C0F40.7040304@cosmosbay.com> <20081207205250.dbb7fe4b.akpm@linux-foundation.org> <20081208221241.GA2501@mit.edu> <1228774836.16244.22.camel@lappy.programming.kicks-ass.net> <20081208230047.GC2501@mit.edu> <20081208150724.37761534.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208150724.37761534.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 03:07:24PM -0800, Andrew Morton wrote:
> > Stupid question --- if you're worried about cacheline ping-pongs, why
> > aren't each cpu's delta counter cacheline aligned?
> 
> They are allocated with alloc_percpu(), so each CPU's counter lives
> in a per-cpu area.  If you chase through seventeen layers of Rustyness
> you end up at mm/allocpercpu.c:percpu_populate() which is where that
> little s32 ends up getting allocated.

Ah, OK.  So the answer is "Ted was stupid and didn't understand n
layers of percpu abstractions".... whoever wrote that code seems to
have been a great believer of the saying, "if the code was hard to
*write*, it should be hard to *understand*".  :-)

						- Ted
