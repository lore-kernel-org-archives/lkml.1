Return-Path: <linux-kernel-owner+w=401wt.eu-S1753125AbZGANL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbZGANL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGANLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:11:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45062 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbZGANLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:11:47 -0400
Date: Wed, 1 Jul 2009 15:11:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090701131146.GR6760@one.firstfloor.org>
References: <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <4A4A9DC6.6020003@kernel.org> <20090701064250.GM6760@one.firstfloor.org> <4A4B38C5.1070504@kernel.org> <20090701122312.GP6760@one.firstfloor.org> <4A4B5C32.1010009@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4B5C32.1010009@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 09:53:06PM +0900, Tejun Heo wrote:
> It would be nice to have something to test cpu on/offlining
> automatically.  Something which keeps bringing cpus up and down as the
> system goes through stress testing.

That's an trivial shell script using echo into sysfs files. It doesn't
seem to be widely done (the last time I tried it I promptly ran
into some RCU bug). You need a large enough machine for it.

But most stress testing does not actually have good code coverage 
in my experience. It just runs the same small set of core code all over 
(you can check now, kernel gcov is finally in)

The tricky part is to actually test the code you want to test.

> > ending up with lots of badly tested code is to:
> 
> But I don't think it would be that drastic.  Most users are quite
> simple.

But how do you test them properly?  And educate
the driver writers?  Also it would likely increase code sizes drastically.

Philosophically I think code like that should be a simple
operation and turning all the per cpu init code into
callbacks is not simple. That makes everything more error prone.

And it's imho unclear if that is all worth it just to avoid 
wasting some memory in the "256 possible CPUs" case (which 
I doubt is particularly realistic anyways, at least I don't
know of any Hypervisor today that scales to 256 CPUs)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
