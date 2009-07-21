Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZGUBrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZGUBrB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZGUBrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:47:00 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55491 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZGUBq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:46:59 -0400
Date: Tue, 21 Jul 2009 10:46:39 +0900 (JST)
Message-Id: <20090721.104639.746976804375753666.mitake@dcl.info.waseda.ac.jp>
To: a.p.zijlstra@chello.nl
Cc: mingo@elte.hu, fweisbec@gmail.com, linux@brodo.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting
 support to perfcounters
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1247933355.6597.11.camel@laptop>
References: <20090718093115.GB9142@elte.hu>
	<20090718.231137.187581409.mitake@dcl.info.waseda.ac.jp>
	<1247933355.6597.11.camel@laptop>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][RFC] Adding transition of CPU frequency counting support to perfcounters
Date: Sat, 18 Jul 2009 18:09:15 +0200

> On Sat, 2009-07-18 at 23:11 +0900, mitake@dcl.info.waseda.ac.jp wrote:
> > 
> > Oh, my perf could count cpufreq events!
> > Thanks for your nice advice!
> > 
> > % perf stat -a sleep 60
> > 
> >  Performance counter stats for 'sleep 60':
> > 
> >   479088.075595  task-clock-msecs         #      7.984 CPUs
> >          199080  context-switches         #      0.000 M/sec
> >           19584  CPU-migrations           #      0.000 M/sec
> >          322978  page-faults              #      0.001 M/sec
> >              29  cpufreq-up               #      0.000 M/sec
> >              42  cpufreq-down             #      0.000 M/sec
> >     73703367828  cycles                   #    153.841 M/sec
> >     52005203450  instructions             #      0.706 IPC
> >       209762467  cache-references         #      0.438 M/sec
> >        84916856  cache-misses             #      0.177 M/sec
> > 
> >    60.009508200  seconds time elapsed
> > 
> > And I'm using ondemand governor now,
> > so kernel thread [kondemand] context causes freq transition.
> > I didn't notice that...
> > 
> > Could you merge this patch?
> > Can I send this patch with descriptions and Signed-off-by?
> 
> Why, what is the usecase?
> 
> 

Hmm, I considered, and I noticed that this patch makes no sense.
Because my first purpose "collecting CPU freq transitions per process level"
is completely nonsense. CPU freq transitions are global things, not one of processes.

In either case, "up" and "down" are too poor information.
At least freqs of each time should be recorded.

Sorry, please disregard this patch.
