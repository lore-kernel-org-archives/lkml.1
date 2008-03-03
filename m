Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYCCR6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYCCR6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYCCR6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:58:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYCCR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:58:39 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080303113621.1dfdda87.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 18:57:32 +0100
Message-Id: <1204567052.6241.4.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 11:36 -0600, Paul Jackson wrote:
> Peter wrote:
> > The system group can overlap with anything that does need system services.
> 
> I suppose IRQs need to overlap like this, but cpusets often can't
> overlap like this.

Due to CS_CPU_EXCLUSIVE usage?

I had hoped system would be allowed to overlap.

> If a system has the cgroup hierarchy you draw:
> 
>   /cgroup
>   /cgroup/system
>   /cgroup/system/boot
> 
>   /cgroup/big_honking_app
>   /cgroup/rt_domain
> 
> this must not force the cpuset hierarchy to be:
> 
>   /dev/cpuset
>   /dev/cpuset/system
>   /dev/cpuset/system/boot
> 
>   /dev/cpuset/big_honking_app
>   /dev/cpuset/rt_domain
> 
> I guess this means IRQs cannot be added to the cpuset subsystem
> of cgroups.  Rather they have to be added to some other cgroup
> subsystem, perhaps a new one just for IRQs.

The trouble is, cgroups are primarily about tasks, whereas IRQs are not.
So we would create a cgroup that does not manage tasks, but rather
associates irqs with sets of cpus - which are not cpusets.

See how that would be awkward?

> In perhaps the most common sort of cpuset hierarchy:
> 
>   /dev/cpuset
>   /dev/cpuset/boot
>   /dev/cpuset/batch_sched
>   /dev/cpuset/big_honking_app
>   /dev/cpuset/rt_domain
> 
> none of boot or its siblings overlap.

But as long as nobody does CS_CPU_EXCLUSIVE they may overlap, right?

