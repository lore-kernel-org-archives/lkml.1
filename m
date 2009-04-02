Return-Path: <linux-kernel-owner+w=401wt.eu-S935649AbZDBLOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935649AbZDBLOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbZDBLO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:14:28 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:45694 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZDBLO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:14:27 -0400
Date: Thu, 2 Apr 2009 13:13:41 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090402131341.08ef4184@skybase>
In-Reply-To: <20090402072418.GA14071@jurassic.park.msu.ru>
References: <20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<49D2B04D.4070604@kernel.org>
	<20090401101054.0a4b187d@skybase>
	<49D3231D.2040403@kernel.org>
	<20090401103257.12c2517e@skybase>
	<49D32B96.3060102@kernel.org>
	<20090401130731.785714c5@skybase>
	<49D41B79.60708@kernel.org>
	<20090402072418.GA14071@jurassic.park.msu.ru>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 11:24:18 +0400
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On the other hand, some tricks with DEFINE_PER_CPU() are indeed possible -
> for instance, using weak references we could force the compiler to
> generate proper addressing mode. So DEFINE_PER_CPU(int, foo) in module
> would expand to something like this:
> 
> 	extern int per_cpu__foo;
> 	asm(".weakref per_cpu__foo, per_cpu_mod__foo");
> 	__attribute__((__section__(".data.percpu"))) int per_cpu_mod__foo
> 
> The main problem is that our DEFINE_PER_CPU() macro consists of more
> than one definition, so it won't be possible to specify both storage class
> and initializer with it.
> 
> If it's acceptable to change the semantics from
> 
> static DEFINE_PER_CPU(int, foo) = 1
> 
> to
> 
> DEFINE_PER_CPU(static, int, foo) = 1
> 
> then we're ok.
> 
> Or maybe just add STATIC_DEFINE_PER_CPU_xx() variants?

That is what I'm after as well. Just drop the "static" from the
DEFINE_PER_CPU statement found inside modules and it works.

My experiments with the weak and visibility attribute failed because
the static storage class specifier together with the attribute either
causes a compile error or static just overrides the attribute.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

