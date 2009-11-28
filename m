Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZK1Jvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZK1Jvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 04:51:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZK1Jvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 04:51:51 -0500
Received: from ozlabs.org ([203.10.76.45]:52899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZK1Jvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 04:51:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: percpu tree build warning
Date: Sat, 28 Nov 2009 20:21:50 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-15-generic; KDE/4.3.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <200911270846.02717.rusty@rustcorp.com.au> <20091127054128.GC13914@elte.hu>
In-Reply-To: <20091127054128.GC13914@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911282021.50315.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009 04:11:28 pm Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Thu, 26 Nov 2009 12:10:58 am Ingo Molnar wrote:
> > > While a percpu variable is defined and used in completely different 
> > > ways:
> > > 
> > >   DEFINE_PER_CPU(unsigned long, dr7);
> > > 
> > > and is used via:
> > > 
> > >   __get_cpu_var(dr7);  [[Fixed -- RR]]
> > 
> > The entire point of Tejun's per-cpu work is that &dr7 is now valid. A 
> > per-cpu pointer as if it were allocated by the dynamic per-cpu 
> > allocator.
> >
> > Your arguments are fine, but out-of-date.
> 
> But allowing &dr7 is outright dangerous - and not particularly clean 
> either.

That's foolish.  We can now have generic per-cpu function for counters
and the like.

> Nothing tells us that it's a percpu variable

__percpu.  Again, I'm explaining what you should already know before sending
email about this stuff.

> and it blends into the 
> regular namespace while most of the operators on it are special 
> (__get_cpu_var(), per_cpu(), __this_cpu(), etc.).

OK, you convince Linus to change __user vars to use a prefix.  Then I'll
agree that per_cpu_## is more kernely.

Stupidest debate ever.
Rusty.
