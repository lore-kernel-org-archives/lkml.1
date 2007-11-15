Return-Path: <linux-kernel-owner+w=401wt.eu-S1764702AbXKOLjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764702AbXKOLjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 06:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXKOLjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 06:39:23 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:46447 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751519AbXKOLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 06:39:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=H+Ma/LQWu0IK4f8iEwDmtA45df7sZ9mxrp4CbxrizvrapuP3CLczDmj0elMzvoglFg/fBjwWaKF4v/Pf0SRBUlgiepH1OiquXz9yvnsPQiIhmINE5ZuxwhtgHnZoUSeKpV5UAtlS05y3YHEcH0xdJ6r/Oy8EdcPJZp8kM4ZLp8I=  ;
X-YMail-OSG: s4mFBqcVM1mZJQoUK12xPfZvWvAUkI62ZWfvygwj3kGceKYyCKRn.1AjI526Z4jnK7P_HmXZHw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] SLOB crash, 2.6.24-rc2
Date: Thu, 15 Nov 2007 22:39:14 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
References: <20071114225335.GV19691@waste.org> <200711152157.59409.nickpiggin@yahoo.com.au> <20071115112820.GA18228@elte.hu>
In-Reply-To: <20071115112820.GA18228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152239.14707.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 22:28, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Anyway, I'm really happy to see you're testing and using SLOB upstream
> >
> > :) Is there any particular reason that you're using it?
>
> i sometimes test SLOB for -rt, but this time it's the result of my
> "automated random QA" effort, as part of arch/x86 maintainance/QA.
>
> the main trick is to build and booting random "make randconfig"
> bzImages. That finds build bugs and a good deal of boot hang and crash
> bugs as well. (it also found a compiler bug already) I can build and
> boot about 1000 random kernels in 24 hours, and it's all fully
> automated. I usually run it overnight - when a kernel does not come up
> due to a bootup hang or crash (or the kernel log signals any exception
> condition) then the script stops and i can fix it in the morning.
>
> The first step towards this was to get allyesconfig bzImage kernels to
> build and boot fine. That effort took months (we had many problems in
> this area) - i think you saw bugreports and fixes from me about that on
> lkml.
>
> Once that worked reasonably well i made a small Kconfig patch that
> forcibly selects a "minimum set" of drivers and kernel subsystems that
> are needed to boot up a testsystem. Once a "make allnoconfig" and a
> "make allyesconfig" bzImage kernel boots up fine on the testbox all
> randconfig configs "inbetween" are supposed to build and boot fine as
> well.
>
> I also have a patch that adds all the x86 boot options like nosmp,
> maxcpus=1, nohz=off, hpet=disable to be selectable as .config options -
> so those boot options are randomized as well.
>
> I also have a small patch that disables half a dozen drivers/features
> that are not expected to work out of box in a bzImage kernel. (such as
> ISA drivers that assume the presence of hardware, or root filesystem
> features such as NFSROOT)
>
> the resulting make randconfig kernel still has 99% of the degrees of
> freedom that a stock make randconfig kernel has, so by all practical
> purposes it's a fully random kernel - it just happens to boot on my
> testsystem all the time.
>
> A successful bootup means the test system is able to boot up into a
> stock Fedora 8 userspace and is able to bring up its network interfaces
> and ssh out (automatically) to the build box to signal the completion of
> a successful test cycle. The logs are also analyzed for lockdep
> assertions (if lockdep is enabled - which it is in about 20% of the
> randconfig kernels) and other kernel bugs.
>
> (just in case you were wondering about one of the reasons why the
> arch/x86 unification merge went so smoothly, with nary a regression ;-)
> Thomas is doing other types of automated QA of the x86 queue as well.)

Well, my hat's off to you. Actually I was more wondering how it is
that you're catching SLOB bugs ;) so it seems your test setup is much
more useful than just to test the x86 arch code...
