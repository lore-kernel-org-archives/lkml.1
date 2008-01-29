Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYA2SIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYA2SIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYA2SIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:08:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45055 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYA2SIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:08:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oVKR30YS/5OemfYFe+L5v1EnjynRBvla0Zr1Oc9ttPhtIjSuRdBmKwDp5vOSFR04y
	t6eQvZvFNzARmFKOuiN1g==
Message-ID: <6599ad830801291008w673f6f71x502b0444c4f726c6@mail.gmail.com>
Date: Tue, 29 Jan 2008 10:08:12 -0800
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH 5/12] Handle pid namespaces in cgroups code
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       devel@openvz.org, "Oleg Nesterov" <oleg@tv-sign.ru>
In-Reply-To: <479F2F99.5080509@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479F2C5C.1050303@openvz.org> <479F2F99.5080509@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 29, 2008 5:52 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
> There's one place that works with task pids - its the "tasks" file
> in cgroups. The read/write handlers assume, that the pid values
> go to/come from the user space and thus it is a virtual pid, i.e.
> the pid as it is seen from inside a namespace.
>
> Tune the code accordingly.
>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Paul Menage <menage@google.com>

>
> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2c5cccb..4766bb6 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1269,7 +1269,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
>
>         if (pid) {
>                 rcu_read_lock();
> -               tsk = find_task_by_pid(pid);
> +               tsk = find_task_by_vpid(pid);
>                 if (!tsk || tsk->flags & PF_EXITING) {
>                         rcu_read_unlock();
>                         return -ESRCH;
> @@ -1955,7 +1955,7 @@ static int pid_array_load(pid_t *pidarray, int npids, struct cgroup *cgrp)
>         while ((tsk = cgroup_iter_next(cgrp, &it))) {
>                 if (unlikely(n == npids))
>                         break;
> -               pidarray[n++] = task_pid_nr(tsk);
> +               pidarray[n++] = task_pid_vnr(tsk);
>         }
>         cgroup_iter_end(cgrp, &it);
>         return n;
> --
> 1.5.3.4
>
>
