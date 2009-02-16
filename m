Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZBPImi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZBPImi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbZBPIma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:42:30 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:55461 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754531AbZBPIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:42:29 -0500
Date: Mon, 16 Feb 2009 09:42:23 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216084223.GA2641@localhost.localdomain>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215193102.GA16873@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ok, I've redone the tests under tip from this morning (Paris time).
Everything is in http://damien.wyart.free.fr/ksoftirqd_pb/

* Ingo Molnar <mingo@elte.hu> [2009-02-15 20:31]:
> Yes, an abstime trace would be useful.

The corresponding file is trace_tip_2009.02.16_ksoftirqd_pb_abstime.txt.gz
and there is also a trace without abstime:
trace_tip_2009.02.16_ksoftirqd_pb.txt.gz

> > checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> > Switched to high resolution mode on CPU 1

> Lets double-check your scheduler clock first. Without being able to
> trust the clock we cannot trust the task stats nor the trace output.

> What does this check display:

>   http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

The file is time-warp-test_result.txt
I've let it run for a few tens of minutes; the first number varies
slightly sometimes. The second one stays at 0.

> Does it find any TSC time warps?

Seems not.

> Also, could you send the output of:

>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh

> Run it while you can see the ksoftirqd anomaly.

In fact I see it all the time when the machine is idle. When something
runs (spamd for example), the running time of ksoftirqd stops
increasing, and it goes back to increasing like crazy when idle state
comes back.

The corresponding file is cfs-debug-info-2009.02.16-08.09.17.gz


Hope this will be useful; do not hesitate to ask for further info. Now
that I have tip, I guess it will be easier.

-- 
Damien
