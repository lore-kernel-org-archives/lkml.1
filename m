Return-Path: <linux-kernel-owner+w=401wt.eu-S1030340AbXBTSqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030340AbXBTSqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030344AbXBTSqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:46:00 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39746 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030340AbXBTSp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:45:59 -0500
Date: Tue, 20 Feb 2007 10:45:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Gautham shenoy <ego@in.ibm.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: slab: start_cpu_timer/cache_reap CONFIG_HOTPLUG_CPU problems
In-Reply-To: <45DB404C.4070305@qualcomm.com>
Message-ID: <Pine.LNX.4.64.0702201041340.14643@schroedinger.engr.sgi.com>
References: <20070129011301.GA844@tv-sign.ru>
 <Pine.LNX.4.64.0701290852390.28200@schroedinger.engr.sgi.com>
 <20070129171923.GA138@tv-sign.ru> <Pine.LNX.4.64.0701290922390.28330@schroedinger.engr.sgi.com>
 <20070129182742.GA158@tv-sign.ru> <45DB404C.4070305@qualcomm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Max Krasnyansky wrote:

> > > Well seems that we have a set of unresolved issues with workqueues and cpu
> > > hotplug.
> 
> How about storing 'cpu' explicitly in the work queue instead of relying on the
> smp_processor_id() and friends ? That way there is no ambiguity when
> threads/timers get
> moved around.

The slab functionality is designed to work on the processor with the 
queue. These tricks will only cause more trouble in the future. The 
cache_reaper needs to be either disabled or run on the right processor. It 
should never run on the wrong processor.

The cache_reaper() is of no importance to hotplug. You just need to make 
sure that it is not in the way (disable it and if its running wait 
until the cache_reaper has finished).

