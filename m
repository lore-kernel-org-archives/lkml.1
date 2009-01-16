Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbZAPAQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbZAPAQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbZAPAQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:16:32 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33470 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353AbZAPAQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:16:31 -0500
Date: Fri, 16 Jan 2009 01:15:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: akpm@linux-foundation.org, tj@kernel.org, hpa@zytor.com, brgerst@gmail.com,
       ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       travis@sgi.com, linux-kernel@vger.kernel.org, steiner@sgi.com,
       hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090116001544.GA11073@elte.hu>
References: <20090115183942.GA6325@elte.hu> <20090116001200.GA9137@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116001200.GA9137@gondor.apana.org.au>
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


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> Of course.  But do any architectures actually _need_ that for a single 
> >> read?
> > 
> > not for a read i guess - but for the other ops like add/and/or/xor.
> 
> One of the things I'd like to see happen with this work is for us to 
> have a cheap per-cpu atomic counter that we can use for SNMP stats.
> 
> If we can make the inc/add variants into a single instruction, then it 
> won't need to disable preemption or interrupts.
> 
> So if you could design the API such that we have a variant of add/inc 
> that automatically disables/enables preemption then we can optimise that 
> away on x86.

Yeah. percpu_add(var, 1) does exactly that on x86.

	Ingo
