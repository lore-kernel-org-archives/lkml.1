Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYFPHEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYFPHEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYFPHEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:04:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYFPHEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:04:43 -0400
Subject: Re: [PATCH] introduce task cgroup v2
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080616155630.78A9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1213598394.16944.85.camel@twins>
	 <20080616155630.78A9.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 09:04:42 +0200
Message-Id: <1213599882.16944.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 15:59 +0900, KOSAKI Motohiro wrote:
> Hi Peter,
> 
> > > # mount -t cgroup -o task none /dev/cgroup
> > > # mkdir /dev/cgroup/foo
> > > # cd /dev/cgroup/foo
> > > # ls 
> > > notify_on_release  task.max_tasks  task.nr_tasks  tasks
> > > # echo 100 > task.max_tasks
> > > # echo $$ > tasks
> > > # fork_bomb 1000 &  <- try create 1000 process
> > > # pgrep fork_bomb | wc -l
> > > 98
> > 
> > fwiw I think the name sucks!
> > cgroups are about grouping tasks, so what's a task cgroup?
> 
> Sorry, my english skill is very low.
> I hope restrict number of tasks.
> 
> Do you have any name idea?

Sadly I suck at naming too ;-(

perhaps task_limit controller, or nr_tasks controller.

We should preferably pick one that transfers to most other rlimit like
controls.

