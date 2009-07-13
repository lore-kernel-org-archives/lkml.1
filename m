Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZGMGGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZGMGGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 02:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZGMGG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 02:06:27 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59340 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZGMGG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 02:06:26 -0400
Date: Mon, 13 Jul 2009 15:06:12 +0900 (JST)
Message-Id: <20090713.150612.886429910823138064.mitake@dcl.info.waseda.ac.jp>
To: a.p.zijlstra@chello.nl
Cc: andi@firstfloor.org, fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
       linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired
 how many spinlocks to schedstat
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1247405045.6733.2.camel@laptop>
References: <1247230336.7529.34.camel@twins>
	<20090712.162337.287595819039280884.mitake@dcl.info.waseda.ac.jp>
	<1247405045.6733.2.camel@laptop>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Date: Sun, 12 Jul 2009 15:24:05 +0200

> On Sun, 2009-07-12 at 16:23 +0900, Hitoshi Mitake wrote:
> 
> > Thanks, I understood your advice. Using infrastructure of ftrace is good idea, so I'll use it.
> > 
> > But I have a question.
> > I can't enable CONFIG_EVENT_PROFILE because it depends on CONFIG_EVENT_TRACER.
> > And CONFIG_EVENT_TRACER seems something never enabled.
> > 
> > % git grep EVENT_TRACER
> > arch/arm/configs/cm_x300_defconfig:# CONFIG_EVENT_TRACER is not set
> > arch/arm/configs/davinci_all_defconfig:# CONFIG_EVENT_TRACER is not set
> > arch/arm/configs/ep93xx_defconfig:# CONFIG_EVENT_TRACER is not set
> > ....
> > arch/x86/configs/i386_defconfig:# CONFIG_EVENT_TRACER is not set
> > arch/x86/configs/x86_64_defconfig:# CONFIG_EVENT_TRACER is not set
> > init/Kconfig:   depends on PERF_COUNTERS && EVENT_TRACER
> > 
> > In addition, this is the output of searching this on menuconfig
> >     Symbol: EVENT_TRACER [=EVENT_TRACER]          
> > and, there is a log in git
> > 
> > commit a7abe97fd8e7a6ccabba5a04a9f17be9211d418c
> > Author: Steven Rostedt <srostedt@redhat.com>
> > Date:   Mon Apr 20 10:59:34 2009 -0400
> > 
> >     tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING
> > 
> >     Currently we have two configs: EVENT_TRACING and EVENT_TRACER.
> >     All tracers enable EVENT_TRACING. The EVENT_TRACER is only a
> >     convenience to enable the EVENT_TRACING when no other tracers
> >     are enabled.
> > 
> > Does EVENT_TRACER make any sense?
> > If doesn't, can I remove dependency of CONFIG_EVENT_PROFILE?
> 
> Yeah, steve broke it, but then Jason fixed it again, but his patches
> might not have made it in yet.
> 
>   http://lkml.org/lkml/2009/7/6/313
> 
> 

Wow! I can obtain lock_acquire with Jason's patch,

% perf stat -e lockdep:lock_acquire sleep 1

 Performance counter stats for 'sleep 1':

           1420  lockdep:lock_acquire

    1.004953591  seconds time elapsed

I wanted this.
So I don't have nothing to do.., but thanks Jason!
