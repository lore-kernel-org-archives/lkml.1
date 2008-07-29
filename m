Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYG2GlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYG2GlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYG2GlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:41:04 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:53402 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYG2GlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:41:03 -0400
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org,
       pj@sgi.com, menage@google.com, vegard.nossum@gmail.com,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <20080728140748.GB18144@elte.hu>
References: <1216852381-23445-1-git-send-email-maxk@qualcomm.com>
	 <488B7DC5.20302@qualcomm.com>  <20080728140748.GB18144@elte.hu>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 08:40:54 +0200
Message-Id: <1217313654.18049.59.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 16:07 +0200, Ingo Molnar wrote:
> * Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
> > Max Krasnyansky wrote:
> > > This is an updated version of my previous cpuset patch:
> > >   "Make rebuild_sched_domains() usable from any context (take 2)"
> > 
> > Folks,
> > 
> > Any comments on this patch ? We need this to complete sched domain 
> > handling fixes/improvements that we started with the cpu_active_map, 
> > and to avoid circular locking issues in the cpu hotplug -> 
> > rebuild_sched_domains path.
> 
> Paul, Peter, any comments?

I'm really not that at home with all that cgroup fiddling, so I'd like a
word from the two Pauls..

Questions I have at the moment:

 -  do we really need a new workqueue for this? Can't we use the regular
keventd stuff, now that Oleg fixed the get_online_cpus() thing?
(3da1c84c00c7e5fa8348336bd8c342f9128b0f14)

 - aren't there funny races with the async_rebuild_sched_domains()
stuff? 

