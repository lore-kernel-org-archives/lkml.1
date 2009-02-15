Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbZBOKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbZBOKmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZBOKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 05:42:47 -0500
Received: from smtp-114-sunday.nerim.net ([62.4.16.114]:55362 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157AbZBOKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 05:42:46 -0500
Date: Sun, 15 Feb 2009 11:42:45 +0100
From: Damien Wyart <damien.wyart@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090215104245.GA2320@localhost.localdomain>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215103445.GA2335@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Note that if the box you test this on is multi-core or HT, then interpreting
> > traces is easier if there's just a single CPU to look at. In that case i'd 
> > suggest to reproduce with just a single core, by turning the second one off:

> >    echo 0 > /sys/devices/system/cpu/cpu1/online

> > Or, if the problem only occurs with two cpus, restrict tracing to CPU#1:

> >    echo 2 > /debug/tracing/tracing_cpumask 

> The box I test on is HT, so I tried the first suggestion and it made the
> problem much less visible (but not completely absent).

> So I used "echo 1 > /sys/devices/system/cpu/cpu1/online" to go back to
> HT mode and then it made the problem much more visible on CPU#1:
> ksoftirqd/1 is running a lot and ksoftirqd/0 is almost normal. The load
> average is about 0.80 and the total running time for ksoftirqd/1 is
> almost one minute (and I booted on rc5 ten minutes ago)!

> So I followed the tracing steps in the tutorial (with the 1 sec sleep),
> which gave me this:
> http://damien.wyart.free.fr/trace_2.6.29-rc5_ksoftirqd_prob.txt.gz

Of course, I used your first suggestion (tracing on CPU#1) to get this
trace.

-- 
Damien
