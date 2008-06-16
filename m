Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbYFPHIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbYFPHIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYFPHIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:08:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYFPHII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:08:08 -0400
Date: Mon, 16 Jun 2008 16:06:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] introduce task cgroup v2
Cc: kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <48560FDB.9070206@cn.fujitsu.com>
References: <20080616111410.7896.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48560FDB.9070206@cn.fujitsu.com>
Message-Id: <20080616160520.78AC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess you didn't notice this comment ? :)

Agghhh, you are right.
sorry.

> >> --- a/kernel/fork.c
> >> > +++ b/kernel/fork.c
> >> > @@ -54,6 +54,7 @@
> >> >  #include <linux/tty.h>
> >> >  #include <linux/proc_fs.h>
> >> >  #include <linux/blkdev.h>
> >> > +#include <linux/cgroup_task.h>
> >> >  
> >> >  #include <asm/pgtable.h>
> >> >  #include <asm/pgalloc.h>
> >> > @@ -920,6 +921,8 @@ static struct task_struct *copy_process(
> >> >  		    p->user != current->nsproxy->user_ns->root_user)
> >> >  			goto bad_fork_free;
> >> >  	}
> >> > +	if (task_cgroup_can_fork(p))
> >> > +		goto bad_fork_free;
> > 
> > If task_cgroup_can_fork() returns 0, but copy_process() fails afterwords,
> > taskcg->nr_tasks will be in a wrong state.

Sure.
I'll fix it, of cource.

Thanks!



