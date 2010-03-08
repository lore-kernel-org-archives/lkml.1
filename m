Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0CIAAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 19:00:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46920 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763Ab0CIAAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 19:00:48 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Mar 2010 08:57:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2]  memcg: oom notifier and handling oom by user
Message-Id: <20100309085711.f9158491.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100308172609.GS3073@balbir.in.ibm.com>
References: <20100308162414.faaa9c5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308172609.GS3073@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 22:56:09 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-03-08 16:24:14]:
> 
> > This 2 patches is for memcg's oom handling.
> > 
> > At first, memcg's oom doesn't mean "no more resource" but means "we hit limit."
> > Then, daemons/user shells out of a memcg can work even if it's under oom.
> > So, if we have notifier and some more features, we can do something moderate
> > rather than killing at oom. 
> > 
> > This patch includes
> > [1/2] oom notifier for memcg (using evetfd framework of cgroups.)
> > [2/2] oom killer disalibing and hooks for waitq and wake-up.
> > 
> > When memcg's oom-killer is disabled, all tasks which request accountable memory
> > will sleep in waitq. It will be waken up by user's action as
> >  - enlarge limit. (memory or memsw)
> >  - kill some tasks
> >  - move some tasks (account migration is enabled.)
> > 
> 
> Hmm... I've not seen the waitq and wake-up patches, but does that mean
> user space will control resumtion of tasks?
> 
Yes. And what's useful in this behavior rathar than oom-kill(SIGKILL) by
the kernel is that users can take coredump (by gcore at el.) and snapshot of
all tasks's resource usage (by ps at el.) even if he has to kill a task.


Thanks,
-Kame

