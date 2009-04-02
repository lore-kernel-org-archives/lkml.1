Return-Path: <linux-kernel-owner+w=401wt.eu-S1751369AbZDBEGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbZDBEGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbZDBEGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:06:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46542 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZDBEF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:05:59 -0400
Date: Thu, 2 Apr 2009 06:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Joe Perches <joe@perches.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC] percpu: convert SNMP mibs to new infra
Message-ID: <20090402040537.GB30442@elte.hu>
References: <49D32212.80607@cosmosbay.com> <49D32DC2.9010003@goop.org> <49D33E80.70802@cosmosbay.com> <20090401161218.GB3859@elte.hu> <49D3A0C2.9000403@cosmosbay.com> <49D3B61F.8010507@cosmosbay.com> <49D40323.2020406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D40323.2020406@gmail.com>
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


* Tejun Heo <htejun@gmail.com> wrote:

> Hello, Eric, Ingo.
> 
> Eric Dumazet wrote:
> > diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
> > index aee103b..6b82f6b 100644
> > --- a/arch/x86/include/asm/percpu.h
> > +++ b/arch/x86/include/asm/percpu.h
> > @@ -135,6 +135,9 @@ do {							\
> >  #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
> >  #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
> >  #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
> > +#define indir_percpu_add(var, val)	percpu_to_op("add", *(var), val)
> > +#define indir_percpu_inc(var)       percpu_to_op("add", *(var), 1)
> > +#define indir_percpu_dec(var)       percpu_to_op("add", *(var), -1)
> >  #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
> >  #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
> >  #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
> 
> The final goal is to unify static and dynamic accesses but we 
> aren't there yet, so, for the time being, we'll need some interim 
> solutions. I would prefer percpu_ptr_add() tho.

Yep, that's the standard naming scheme for new APIs: generic to 
specific, left to right.

	Ingo
