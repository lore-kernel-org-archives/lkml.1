Return-Path: <linux-kernel-owner+w=401wt.eu-S932789AbZKZEjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbZKZEjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 23:39:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932331AbZKZEjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 23:39:12 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46984 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbZKZEjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 23:39:10 -0500
Message-ID: <4B0E0670.2000309@in.ibm.com>
Date: Thu, 26 Nov 2009 10:09:12 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: ego@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, maxk <maxk@qualcomm.com>
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
References: <20091112195101.63263490.sfr@canb.auug.org.au> <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop> <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop> <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com> <1258107368.4039.1149.camel@laptop> <1258108281.22655.5.camel@laptop> <4B0A5BA7.8020604@in.ibm.com> <1259156575.4027.514.camel@laptop>
In-Reply-To: <1259156575.4027.514.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Correct, Ingo objected to the fastpath overhead.
>
> Could you please try the below patch which tries to address the issue
> differently.
>   
Works great. Thanks

Tested-by: Sachin Sant <sachinp@in.ibm.com>

Regards
-Sachin

> ---
> Subject: sched: Fix balance vs hotplug race
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Wed Nov 25 13:31:39 CET 2009
>
> Since (e761b77: cpu hotplug, sched: Introduce cpu_active_map and redo
> sched domain managment) we have cpu_active_mask which is suppose to
> rule scheduler migration and load-balancing, except it never did.
>
> The particular problem being solved here is a crash in
> try_to_wake_up() where select_task_rq() ends up selecting an offline
> cpu because select_task_rq_fair() trusts the sched_domain tree to reflect
> the current state of affairs, similarly select_task_rq_rt() trusts the
> root_domain.
>
> However, the sched_domains are updated from CPU_DEAD, which is after
> the cpu is taken offline and after stop_machine is done. Therefore it
> can race perfectly well with code assuming the domains are right.
>
> Cure this by building the domains from cpu_active_mask on
> CPU_DOWN_PREPARE.
>
>   


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

