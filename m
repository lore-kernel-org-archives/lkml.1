Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZCaUT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZCaUT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757365AbZCaUTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:19:47 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:52773 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbZCaUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:19:45 -0400
Date: Tue, 31 Mar 2009 22:19:37 +0200
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
Message-ID: <20090331221937.1cf4e29a@skybase>
In-Reply-To: <20090331191703.GA8250@jurassic.park.msu.ru>
References: <49C8FAC4.6060508@kernel.org>
	<20090325122738.42d105b7@skybase>
	<49CA1AC3.9080908@kernel.org>
	<20090325122241.GE11571@elte.hu>
	<49CA2345.70204@kernel.org>
	<20090325141330.2717dc97@skybase>
	<49CA2FBF.9000207@kernel.org>
	<20090325142525.2d31c522@skybase>
	<49CA32F6.2030408@kernel.org>
	<20090331185431.72ff1707@skybase>
	<20090331191703.GA8250@jurassic.park.msu.ru>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 23:17:03 +0400
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:

> On Tue, Mar 31, 2009 at 06:54:31PM +0200, Martin Schwidefsky wrote:
> > I got the dynamic cpu allocator to work with the patch below. Anybody
> > with an objection against the SHIFT_PERCPU_VAR macro ?
> 
> That's fine with me.
> 
> > --- linux-next/arch/alpha/include/asm/percpu.h	2009-03-31 15:55:03.000000000 +0200
> > +++ linux-s390/arch/alpha/include/asm/percpu.h	2009-03-31 15:55:46.000000000 +0200
> > @@ -47,6 +47,8 @@ extern unsigned long __per_cpu_offset[NR
> >  		: "=&r"(__ptr), "=&r"(tmp_gp));		\
> >  	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
> >  
> > +#define SHIFT_PERCPU_VAR(var, offset) SHIFT_PERCPU_PTR(var, offset)
> > +
> 
> No, just do s/SHIFT_PERCPU_PTR/SHIFT_PERCPU_VAR/ in
> arch/alpha/include/asm/percpu.h and the rest of your patch would
> fix alpha as well.

Ok, cool. May I add an Acked-by?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

