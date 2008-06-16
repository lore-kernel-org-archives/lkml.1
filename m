Return-Path: <linux-kernel-owner+w=401wt.eu-S1758722AbYFPHDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722AbYFPHDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYFPHDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:03:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49616 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYFPHDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:03:24 -0400
Message-ID: <48560FDB.9070206@cn.fujitsu.com>
Date: Mon, 16 Jun 2008 15:01:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] introduce task cgroup v2
References: <20080607195733.9C77.KOSAKI.MOTOHIRO@jp.fujitsu.com> <484E0F7F.3000606@cn.fujitsu.com> <20080616111410.7896.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080616111410.7896.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess you didn't notice this comment ? :)

>> --- a/kernel/fork.c
>> > +++ b/kernel/fork.c
>> > @@ -54,6 +54,7 @@
>> >  #include <linux/tty.h>
>> >  #include <linux/proc_fs.h>
>> >  #include <linux/blkdev.h>
>> > +#include <linux/cgroup_task.h>
>> >  
>> >  #include <asm/pgtable.h>
>> >  #include <asm/pgalloc.h>
>> > @@ -920,6 +921,8 @@ static struct task_struct *copy_process(
>> >  		    p->user != current->nsproxy->user_ns->root_user)
>> >  			goto bad_fork_free;
>> >  	}
>> > +	if (task_cgroup_can_fork(p))
>> > +		goto bad_fork_free;
> 
> If task_cgroup_can_fork() returns 0, but copy_process() fails afterwords,
> taskcg->nr_tasks will be in a wrong state.
> 

