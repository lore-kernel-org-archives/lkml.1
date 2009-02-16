Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZBPNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZBPNCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755182AbZBPNCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:02:25 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:53645 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754954AbZBPNCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:02:25 -0500
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with 2.6.29-rc2-git1
References: <20090215090026.GA31147@elte.hu>
	<20090215095128.GA3234@localhost.localdomain>
	<20090215101351.GA23274@elte.hu>
	<20090215103445.GA2335@localhost.localdomain>
	<20090215110104.GB31351@elte.hu>
	<20090215180355.GA2273@localhost.localdomain>
	<20090215193102.GA16873@elte.hu>
	<20090216084223.GA2641@localhost.localdomain>
	<20090216095059.GL6182@elte.hu> <87hc2u61e9.fsf@free.fr>
	<20090216122632.GA3158@elte.hu>
Date: Mon, 16 Feb 2009 14:02:23 +0100
Message-ID: <87ljs6pmao.fsf@free.fr>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.90
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [090216 13:26]:
> We do get 0x100 which is 1 << RCU_SOFTIRQ, i.e. the RCU softirq. Paul, 
> this indeed seems to be a CONFIG_TREE_RCU=y bug.

> What is weird is that RCU_SOFTIRQ gets set again and again - but there's 
> no raise_softirq() calls. Could you please do a two-CPU trace too via:

>    echo 3 > /debug/tracing/tracing_cpumask

> So that we can see what's happening on the other CPU?

> Also, could you please apply the debug patch below (or update to the 
> very latest -tip tree), so that we get trace entries of softirq triggers 
> too?

Ok, the new trace with these additional modifications is here:
http://damien.wyart.free.fr/ksoftirqd_pb/trace_tip_2009.02.16_1300_ksoftirqd_pb_abstime_proc_mask3.txt.gz

-- 
Damien
