Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZBZIoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZBZIoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBZIo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:44:26 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53846 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZBZIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:44:25 -0500
Date: Thu, 26 Feb 2009 17:43:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-Id: <20090226174303.9234fd60.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090226083702.GI11421@balbir.in.ibm.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	<20090226083702.GI11421@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 14:07:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * Li Zefan <lizf@cn.fujitsu.com> [2009-02-26 15:40:15]:
> 
> > cpuacct_charge() is in fast-path, and checking of !cpuacct_susys.active
> > always returns false after cpuacct has been initialized at system boot.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  kernel/sched.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 410eec4..fd2f7fc 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -9589,7 +9589,7 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
> >  	struct cpuacct *ca;
> >  	int cpu;
> > 
> > -	if (!cpuacct_subsys.active)
> > +	if (unlikely(!cpuacct_subsys.active))
> 
> What happens if most distros make cpuacct_subsys active? Can we decide
> on unlikely depending on how the system is configured?
>
"active" just guarantees task_ca(tsk) is not NULL and subsystem is initialized.

Thanks,
-Kame

