Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbZATKhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbZATKhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:37:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZATKhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:37:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbZATKhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:37:14 -0500
Date: Tue, 20 Jan 2009 11:36:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, ebiederm@xmission.com,
       cl@linux-foundation.org, travis@sgi.com, linux-kernel@vger.kernel.org,
       steiner@sgi.com, hugh@veritas.com,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-ID: <20090120103606.GA29346@elte.hu>
References: <20090115183942.GA6325@elte.hu> <200901170827.33729.rusty@rustcorp.com.au> <20090116220832.GB20653@elte.hu> <200901201328.24605.rusty@rustcorp.com.au> <49756E6E.2060409@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49756E6E.2060409@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Rusty Russell wrote:
> > The generic versions Tejun posted are not softirq safe, so not
> > suitable for network counters. To figure out what semantics we
> > really want we need to we must audit the users; I'm sorry I haven't
> > finished that task (and won't until after the conference).
> 
> No, they're not.  They're preempt safe as mentioned in the comment and 
> is basically just generalization of the original x86 versions used by 
> x86_64 on SMP before pda and percpu areas were merged.  I agree that 
> it's something very close to local_t and it would be nice to see those 
> somehow unified (and I have patches which make use of local_t in my 
> queue waiting for dynamic percpu allocation).
> 
> Another question to ask is whether to keep using separate interfaces for 
> static and dynamic percpu variables or migrate to something which can 
> take both.

Also, there's over 400 PER_CPU variable definitions in the kernel, while 
only about 40 dynamic percpu allocation usage sites. (in that i included 
the percpu_counter bits used by networking)

So our percpu code usage is on the static side, by a large margin.

	Ingo
