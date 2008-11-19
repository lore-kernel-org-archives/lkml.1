Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbYKSXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbYKSXaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 18:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYKSXae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 18:30:34 -0500
Received: from ozlabs.org ([203.10.76.45]:35867 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYKSXad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 18:30:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] cpumask: centralize cpu_online_map and cpu_possible_map
Date: Thu, 20 Nov 2008 10:00:29 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       ink@jurassic.park.msu.ru, starvik@axis.com, tony.luck@intel.com,
       takata@linux-m32r.org, ralf@linux-mips.org, grundler@parisc-linux.org,
       paulus@samba.org, schwidefsky@de.ibm.com, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net, jdike@addtoit.com,
       mingo@redhat.com
References: <200811200107.18162.rusty@rustcorp.com.au> <20081119181743.GA31357@flint.arm.linux.org.uk>
In-Reply-To: <20081119181743.GA31357@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811201000.30862.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 04:47:44 Russell King wrote:
> On Thu, Nov 20, 2008 at 01:07:16AM +1030, Rusty Russell wrote:
> > diff -r c8ab7f6fc5e8 kernel/cpu.c
> > --- a/kernel/cpu.c	Fri Oct 31 10:48:30 2008 +1100
> > +++ b/kernel/cpu.c	Fri Oct 31 11:22:29 2008 +1100
> > @@ -24,19 +24,20 @@ cpumask_t cpu_present_map __read_mostly;
> >  cpumask_t cpu_present_map __read_mostly;
> >  EXPORT_SYMBOL(cpu_present_map);
> >
> > -#ifndef CONFIG_SMP
> > -
> >  /*
> >   * Represents all cpu's that are currently online.
> >   */
> > -cpumask_t cpu_online_map __read_mostly = CPU_MASK_ALL;
> > +cpumask_t cpu_online_map __read_mostly;
>
> Just a question: in the uniprocessor case, does this mean that
> cpu_online_map becomes zero or do we mark cpu0 as online somewhere?
> I couldn't see it in this patch.
>
> I'm just wondering from a review point of view whether this change
> of initialization could have undesirable side effects.

Just checked; we actually set it in boot_cpu_init() already (init/main.c).
Note that all the cpu iterators on UP ignore the mask anyway.

So I think a worthwhile cleanup.

Thanks,
Rusty.
