Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZFFXnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZFFXnu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZFFXnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:43:43 -0400
Received: from ozlabs.org ([203.10.76.45]:38015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZFFXnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:43:43 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
Date: Sun, 7 Jun 2009 09:13:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A2835D8.6040903@kernel.org> <200906052311.57762.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906051026030.6847@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070913.38558.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Jun 2009 03:04:35 am Linus Torvalds wrote:
> On Fri, 5 Jun 2009, Rusty Russell wrote:
> > OK, here's what I've got in my tree.  Ingo, I think this should go in the
> > current -rc to avoid nasty bugs.
>
> Why is the fix not to simply clear it in alloc?

Sure.

> and that
> FIXME is bogus. The end of the allocation needs to be cleared regardless.

Under these new semantics, yep.  Before:
	alloc_cpumask_var(&mask, GFP_KERNEL);
	// New operator only goes to nr_cpu_ids bits.
	cpumask_clear(mask);
	// Old operator uses all NR_CPUS bits.
	BUG_ON(cpus_weight(*mask) != 0);

Thanks,
Rusty.
