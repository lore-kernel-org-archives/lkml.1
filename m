Return-Path: <linux-kernel-owner+w=401wt.eu-S937973AbZAPWLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937973AbZAPWLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765584AbZAPWKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:10:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765457AbZAPWKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:10:22 -0500
Date: Fri, 16 Jan 2009 23:09:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       tj@kernel.org, hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090116220925.GA28917@elte.hu>
References: <20090116001200.GA9137@gondor.apana.org.au> <200901170804.18622.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901170804.18622.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 16 January 2009 10:42:00 Herbert Xu wrote:
> > Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > >> Of course.  But do any architectures actually _need_ that for a single 
> > >> read?
> > > 
> > > not for a read i guess - but for the other ops like add/and/or/xor.
> > 
> > One of the things I'd like to see happen with this work is for
> > us to have a cheap per-cpu atomic counter that we can use for
> > SNMP stats.
> > 
> > If we can make the inc/add variants into a single instruction, then it 
> > won't need to disable preemption or interrupts.
> > 
> > So if you could design the API such that we have a variant of add/inc 
> > that automatically disables/enables preemption then we can optimise 
> > that away on x86.
> 
> Yep, already on it.  It's called local_t; that's what it was originally 
> designed for.
> 
> Unfortunately, to use it efficiently, we need large per-cpu areas.

This makes no sense to me at all. Care to explain?

	Ingo
