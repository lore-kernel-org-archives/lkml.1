Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344Ab0AZLRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0AZLRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 06:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712Ab0AZLRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 06:17:10 -0500
Received: from www.tglx.de ([62.245.132.106]:59722 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0AZLRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 06:17:09 -0500
Date: Tue, 26 Jan 2010 12:16:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dongdong Deng <libfetion@gmail.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel
 debugger
In-Reply-To: <alpine.LFD.2.00.1001261108410.5926@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001261204100.5926@localhost.localdomain>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>  <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>  <20100126092234.77b363d4@mschwide.boeblingen.de.ibm.com>  <alpine.LFD.2.00.1001260946530.5926@localhost.localdomain>
 <ce2c83091001260201j62a770d2r2379a9293f909d87@mail.gmail.com> <alpine.LFD.2.00.1001261108410.5926@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010, Thomas Gleixner wrote:
> There is no sane way to reliably prevent TSC from becoming unstable
> when kgdb stops the kernel inside the watchdog code. And I do not care
> about that at all.
> 
> I'm not going to clutter code with crazy workarounds just because some
> people believe that using a kernel debugger is a good idea. If people
> insist on using kgdb then the possible "TSC becomes unstable" side
> effect is the least of their problems.

Btw, if the kernel uses tick based timekeeping or a clock source which
wraps in rather short intervals (e.g. pm-timer wraps after ~4.6
seconds), stopping the kernel with kgdb will inevitably screw up time
keeping anyway.

So there is really no reason to worry about TSC becoming unstable.

There is only one real sensible solution for this:

 Do _not_ use kgdb - which is the modus operandi of every sane kernel
 developer on the planet.

Thanks,

	tglx
