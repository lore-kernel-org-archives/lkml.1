Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYCCSSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYCCSSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYCCSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:18:44 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:52513 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750826AbYCCSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:18:43 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080303121033.c8c9651c.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:18:36 +0100
Message-Id: <1204568316.8514.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 12:10 -0600, Paul Jackson wrote:
> > But as long as nobody does CS_CPU_EXCLUSIVE they may overlap, right?
> 
> It's a bit stronger than that:
> 
>  1) They need non-overlapping cpusets at this level to control
>     the sched_domain setup, if they want to avoid load balancing
>     across almost all CPUs in the system.  Depending on the kernel
>     version, sched_domain partitioning is controlled either by the
>     cpuset flag cpu_exclusive, or the cpuset flag sched_load_balance.
> 
>  2) They need non-overlapping cpusets at this level to control
>     memory placement of some kernel allocations, which are allowed
>     outside the current tasks cpuset, to be confined by the nearest
>     ancestor cpuset marked 'mem_exclusive'
> 
>  3) Some sysadmin tools are likely coded to expect a /dev/cpuset/boot
>     cpuset, not a /dev/cpuset/system/boot cpuset, as that has been
>     customary for a long time.
> 
> (1) and (2) would break the major batch schedulers.  They typically
> mark their top cpuset, /dev/cpuset/pbs or /dev/cpuset/lfs or whatever
> batch scheduler it is, as cpu_exclusive and mem_exclusive, by way of
> expressing their intention to pretty much own those CPUs and memory
> nodes.  If we fired them up on a system where that wasn't allowed due
> to overlap with /dev/cpuset/system, they'd croak.  Such changes as that
> are costly and unappreciated.

OK, understood, I'll try and come up with yet another scheme :-)

