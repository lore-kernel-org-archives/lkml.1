Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab0BQBHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:07:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48705 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab0BQBHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:07:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 10:03:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217100322.9af8f46d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
	<20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161623190.11952@chino.kir.corp.google.com>
	<20100217094137.a0d26fbb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 16:54:31 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:

> > > >  2. Second, I'll add OOM-notifier and freeze_at_oom to memcg.
> > > >     and don't call memcg_out_of_memory in oom_kill.c in this case. Because
> > > >     we don't kill anything. Taking coredumps of all procs in memcg is not
> > > >     very difficult.
> > > > 
> > > 
> > > The oom notifier would be at a higher level than the oom killer, the oom 
> > > killer's job is simply to kill a task when it is called. 
> > > So for these particular cases, you would never even call into out_of_memory() to panic 
> > > the machine in the first place. 
> > 
> > That's my point. 
> > 
> 
> Great, are you planning on implementing a cgroup that is based on roughly 
> on the /dev/mem_notify patchset so userspace can poll() a file and be 
> notified of oom events?  It would help beyond just memcg, it has an 
> application to cpusets (adding more mems on large systems) as well.  It 
> can also be used purely to preempt the kernel oom killer and move all the 
> policy to userspace even though it would be sacrificing TIF_MEMDIE.
> 

I start from memcg because that gives us simple and clean, no heulistics
operation and we will not have ugly corner cases. And we can _expect_
that memcg has management daemon of OOM in other cgroup. Because memcg's memory
shortage never means "memory is exhausted", we can expect that daemon can work well.
Now, memcg has memory-usage-notifier file. oom-notifier will not be far differnet
from that.

cpuset should have its own if necessary. cpuset's difficulty is that
the memory on its nodes are _really_ exhausted and we're not sure
it can affecet management daemon at el...hang up.

BTW, concept of /dev/mem_notify is notify before OOM, not notify when OOM.
Now, memcg has memory-usage-notifier and that's implemented in some meaning.

Thanks,
-Kame

