Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZHFBiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZHFBiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 21:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750857AbZHFBiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 21:38:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbZHFBiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 21:38:15 -0400
Date: Thu, 6 Aug 2009 03:34:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/4] oom: move oom_adj to signal_struct
Message-ID: <20090806013444.GA22095@redhat.com>
References: <20090804191031.6A3D.A69D9226@jp.fujitsu.com> <20090804192514.6A40.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090804192514.6A40.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late reply. And sorry, I didn't read these patches carefully yet,
probably missed something...

On 08/04, KOSAKI Motohiro wrote:
>
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -34,6 +34,31 @@ int sysctl_oom_dump_tasks;
>  static DEFINE_SPINLOCK(zone_scan_lock);
>  /* #define DEBUG */
>
> +int get_oom_adj(struct task_struct *tsk)

is it used outside oom_kill.c ?

> +{
> +	unsigned long flags;
> +	int oom_adj = OOM_DISABLE;
> +
> +	if (tsk->mm && lock_task_sighand(tsk, &flags)) {

Minor nit. _Afaics_, unlike proc, oom_kill.c never needs lock_task_sighand()
to access ->signal->oom_adj.

If the task was found under tasklist_lock by for_each_process/do_each_thread
it must have the valid ->signal != NULL and it can't go away.


With these patches I think mm-introduce-proc-pid-oom_adj_child.patch should
be dropped. This is good ;)

Oleg.

