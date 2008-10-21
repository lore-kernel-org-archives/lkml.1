Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbYJUHQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbYJUHQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 03:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYJUHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 03:16:36 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:59391 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYJUHQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 03:16:34 -0400
Message-ID: <48FD81CD.7080103@fr.ibm.com>
Date: Tue, 21 Oct 2008 09:16:29 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] freezer_cg: fix improper BUG_ON() causing oops
References: <48FD26F5.1070809@cn.fujitsu.com>
In-Reply-To: <48FD26F5.1070809@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> The BUG_ON() should be protected by freezer->lock, otherwise it
> can be triggered easily when a task has been unfreezed but the
> corresponding cgroup hasn't been changed to FROZEN state.

yes. thanks,

Acked-by: Cedric Le Goater <clg@fr.ibm.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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

