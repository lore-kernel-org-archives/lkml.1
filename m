Return-Path: <linux-kernel-owner+w=401wt.eu-S965196AbXBTUG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196AbXBTUG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 15:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965242AbXBTUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 15:06:28 -0500
Received: from mail.screens.ru ([213.234.233.54]:44972 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965196AbXBTUG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 15:06:28 -0500
Date: Tue, 20 Feb 2007 23:05:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
Message-ID: <20070220200550.GA85@tv-sign.ru>
References: <20070129011301.GA844@tv-sign.ru> <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com> <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com> <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com> <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Christoph Lameter wrote:
>
> On Tue, 20 Feb 2007, Max Krasnyansky wrote:
> 
> > > > Well seems that we have a set of unresolved issues with workqueues and cpu
> > > > hotplug.
> > 
> > How about storing 'cpu' explicitly in the work queue instead of relying on the
> > smp_processor_id() and friends ? That way there is no ambiguity when
> > threads/timers get
> > moved around.
> 
> The slab functionality is designed to work on the processor with the 
> queue. These tricks will only cause more trouble in the future. The 
> cache_reaper needs to be either disabled or run on the right processor. It 
> should never run on the wrong processor.

I personally agree. Besides, cache_reaper is not alone. Note the comment
in debug_smp_processor_id() about cpu-bound processes. The slab does correct
thing right now, stops the timer on CPU_DEAD. Other problems imho should be
solved by fixing cpu-hotplug. Gautham and Srivatsa are working on that.

Oleg.

