Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYKEDt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYKEDt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYKEDtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:49:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37054 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYKEDte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:49:34 -0500
Date: Wed, 5 Nov 2008 12:48:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add hierarchical accounting to cpu accounting
 controller
Message-Id: <20081105124854.aa0e6271.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49111394.1070304@cn.fujitsu.com>
References: <20081023054335.GC3280@in.ibm.com>
	<6599ad830810230849x71961a0asd7f00d3baa2f2271@mail.gmail.com>
	<20081024050830.GA4387@in.ibm.com>
	<6599ad830810241037h575ec17bgb43f750d99bd1518@mail.gmail.com>
	<20081025060157.GA4614@in.ibm.com>
	<6599ad830810250838q3f96644bm6dfee8ba9f35dfa3@mail.gmail.com>
	<20081027101703.e954071d.kamezawa.hiroyu@jp.fujitsu.com>
	<20081027044319.GA4386@in.ibm.com>
	<661de9470810262357y6c560facl87dcaea3ce35e3ac@mail.gmail.com>
	<49057ADD.1050705@cn.fujitsu.com>
	<20081030171622.GA19872@linux.vnet.ibm.com>
	<49111394.1070304@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008 11:31:32 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> cpuacct was designed to count cpu usage of a group of tasks, and now some people
> >> want it to also take child group's usage into account, so I think this is a feature
> >> request but not a bug fix.
> >>
> > 
> > I disagree. The child is a part of the parent's hierarchy, and therefore
> > its usage should reflect in the parent's usage.
> > 
> 
> In memcg the child's usage doesn't reflect in its parent's usage. ;)
> 
> Balbir just posted a patchset to add hierarchy support in memcg, and added memory.feature
> to disable/enable this feature. Is it for performance only or also for keeping the user
> interface/behavior unchanged?

The main reason is performance.

And one of memcg's purpose is isolating resource usage of groups. Sum of usage
is not very important sometimes. (we have /proc/meminfo ;)
Sum of usage can be easily calculcated by user land and we don't have to pay
the cost for it in the kernel.

Thanks,
-Kame

