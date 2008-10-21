Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYJUVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYJUVjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYJUVjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:39:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48857 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbYJUVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:39:17 -0400
Subject: Re: [PATCH 1/4] freezer_cg: fix improper BUG_ON() causing oops
From: Matt Helsley <matthltc@us.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Cedric Le Goater <clg@fr.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <48FD26F5.1070809@cn.fujitsu.com>
References: <48FD26F5.1070809@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 14:39:31 -0700
Message-Id: <1224625171.2991.86.camel@enoch>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 08:48 +0800, Li Zefan wrote:
> The BUG_ON() should be protected by freezer->lock, otherwise it
> can be triggered easily when a task has been unfreezed but the
> corresponding cgroup hasn't been changed to FROZEN state.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Matt Helsley <matthltc@us.ibm.com>

> ---
>  kernel/cgroup_freezer.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> index e950569..7f54d1c 100644
> --- a/kernel/cgroup_freezer.c
> +++ b/kernel/cgroup_freezer.c
> @@ -190,8 +190,9 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
>  	freezer = task_freezer(task);
>  	task_unlock(task);
> 
> -	BUG_ON(freezer->state == CGROUP_FROZEN);
>  	spin_lock_irq(&freezer->lock);
> +	BUG_ON(freezer->state == CGROUP_FROZEN);
> +
>  	/* Locking avoids race with FREEZING -> THAWED transitions. */
>  	if (freezer->state == CGROUP_FREEZING)
>  		freeze_task(task, true);

