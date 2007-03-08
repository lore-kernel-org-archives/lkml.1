Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXCHFkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXCHFkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 00:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932113AbXCHFkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 00:40:23 -0500
Received: from mail22.syd.optusnet.com.au ([211.29.133.160]:45659 "EHLO
	mail22.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbXCHFkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 00:40:22 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Date: Thu, 8 Mar 2007 16:25:05 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <200703071226.43238.kernel@kolivas.org> <20070307185430.31fb48b8.akpm@linux-foundation.org> <20070307201502.4e93c5d5.akpm@linux-foundation.org>
In-Reply-To: <20070307201502.4e93c5d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703081625.06383.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2007 15:15, Andrew Morton wrote:
> On Wed, 7 Mar 2007 18:54:30 -0800 Andrew Morton <akpm@linux-foundation.org> 
wrote:
> > On Wed, 7 Mar 2007 17:43:45 -0800 Andrew Morton 
<akpm@linux-foundation.org> wrote:
> > > On Wed, 7 Mar 2007 12:26:42 +1100
> > >
> > > Con Kolivas <kernel@kolivas.org> wrote:
> > > > What follows is the same patch series that constitutes the RDSL
> > > > "Rotating Staircase DeadLine" cpu scheduler resynced for
> > > > 2.6.21-rc2-mm2.
> > >
> > > Big oops early in boot on x86_64 SMP, in rq_bitmap_error+0x97/0x9f.
> > >
> > > I stubbed it out with a `return MAX_RT_PRIO;' (I think) but it then
> > > oopsed differently.  Before netconsole had come up, no serial console,
> > > no digital camera.
> > >
> > > There's stuff in http://userweb.kernel.org/~akpm/ck/ - you can probably
> > > boot that kernel on your own machine.
> > >
> > > I need to do rc3-mm1 now.  I might find some time to poke at this
> > > further after that, but I have to leave for a week in .jp and it'll be
> > > squeezy, sorry.
> >
> > well it boots os dual pIII and quad powerpc.
>
> It also boots OK on a very similar but somewhat older Nocona machine. 
> Perhaps due to config changes: 
> http://userweb.kernel.org/~akpm/ck/config-ok.txt

Ok I just remembered that not only did I expect the cpu task to never be 
scheduled and it _might_ be scheduled on sched_init, it is actually 
_consciously_ scheduled on hotplug cpu which I have no way of handling at the 
moment. On both your configs I noticed you had hotplug cpu enabled, but 
perhaps it isn't really being used on the more conservative config. So this 
is something I already know I need to handle. Did your ppc that had 
the "bitmap error" have hotplug cpu enabled? It might be an unrelated 
bug^Wphenomenon.

-- 
-ck
