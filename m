Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYLSWja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYLSWja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYLSWjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:39:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754580AbYLSWjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:39:16 -0500
Date: Fri, 19 Dec 2008 14:38:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yinghai@kernel.org, svaidy@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, a.p.zijlstra@chello.nl,
       dipankar@in.ibm.com, balbir@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, ego@in.ibm.com, andi@firstfloor.org,
       davecb@sun.com, tconnors@astro.swin.edu.au, maxk@qualcomm.com,
       gregory.haskins@gmail.com, pavel@suse.cz, rusty@rustcorp.com.au
Subject: Re: [PATCH v7 4/8] sched: nominate preferred wakeup cpu
Message-Id: <20081219143832.f2e2c4d1.akpm@linux-foundation.org>
In-Reply-To: <20081219223130.GA13172@elte.hu>
References: <20081218175313.29812.4781.stgit@drishya.in.ibm.com>
	<20081218175622.29812.69201.stgit@drishya.in.ibm.com>
	<20081219135508.9c6217ba.akpm@linux-foundation.org>
	<20081219141928.3c2939ef.akpm@linux-foundation.org>
	<20081219222709.GN2351@elte.hu>
	<20081219223130.GA13172@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 23:31:30 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > [   74.013893]  <EOI> <0>Code: 8b 47 08 4a 8b 0c 00 48 85 c9 0f 84 c3 00 00 00 49 8b 47 10 4a 8b 04 00 48 8b 80 a8 00 00 00 48 85 c0 74 13 48 0f af 45 c8 31 d2 <48> f7 75 c0 49 89 c6 48 89 c6 eb 16 48 63 55 d0 48 8b 45 c8 45 
> > > [   74.013893] RIP  [<ffffffff802375d8>] tg_shares_up+0x113/0x1f1
> > > [   74.013893]  RSP <ffff88025e057d88>
> > > [   74.020022] ---[ end trace 2fc4046e394f2312 ]---
> > > [   74.020188] Kernel panic - not syncing: Fatal exception in interrupt
> > > 
> > > config: http://userweb.kernel.org/~akpm/config-akpm2.txt
> > > 
> > > I'll try hacking some div-by-zero avoidance into update_group_shares_cpu().
> > 
> > hm, weird - Yinghai noticed this crash in -tip and we have that patch 
> > zapped from all -*-next branches already.
> 
> I guess you applied Ken's patch from email and had it in -mm?

Nope.

> We have a 
> new version of that patch from Ken now based on Yinghai's bugreport - only 
> lightly tested for now.
> 
> 	Ingo
> 
> ----------->
> >From d71f5a7c8bf9cd7c74159a53e522e363f2eddaf5 Mon Sep 17 00:00:00 2001
> From: Ken Chen <kenchen@google.com>
> Date: Fri, 19 Dec 2008 10:11:50 -0800
> Subject: [PATCH] sched: fix uneven per-cpu task_group share distribution

linux-next has:

commit 6eed5aaacae0ced9a43a923633befd2c695d6620
Author: Ken Chen <kenchen@google.com>
Date:   Mon Dec 15 23:37:50 2008 -0800

    sched: fix uneven per-cpu task_group share distribution

so I guess we have a latency problem.
