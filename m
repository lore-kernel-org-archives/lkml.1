Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbYJTUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbYJTUvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYJTUuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:50:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:60554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYJTUuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:50:54 -0400
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 16:50:54 EDT
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=BVwcnFf/Pqo3L4yjlLT90/LN4+JzY2fpyEj+Wn9mSq+gOEcgO6nz0hBwz+R7UsM56
	Y5/E/HJFKZq7NqfUAjd0Q==
Message-ID: <6599ad830810201331t639dbd55h5f17c382ca3a7fbd@mail.gmail.com>
Date: Mon, 20 Oct 2008 13:31:37 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: tiny cleanups
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48FC1784.70108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FC1784.70108@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 10:30 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> - remove 'private' field from struct subsys
> - remove cgroup_init_smp()
> - remove unused 'i' in cgroup_tasks_start()
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks. The cgroup_subsys.private field was originally for some
experiments for automatically emulating CKRM/BeanCounters over early
versions of cgroups, but I don't think anything is using it currently.

Paul

> ---
>  include/linux/cgroup.h |    4 ----
>  kernel/cgroup.c        |    1 -
>  2 files changed, 5 deletions(-)
>
> --- linux-mm/include/linux/cgroup.h.orig        2008-10-20 13:25:39.000000000 +0800
> +++ linux-mm/include/linux/cgroup.h     2008-10-20 13:26:08.000000000 +0800
> @@ -25,7 +25,6 @@ struct cgroup;
>
>  extern int cgroup_init_early(void);
>  extern int cgroup_init(void);
> -extern void cgroup_init_smp(void);
>  extern void cgroup_lock(void);
>  extern bool cgroup_lock_live_group(struct cgroup *cgrp);
>  extern void cgroup_unlock(void);
> @@ -348,8 +347,6 @@ struct cgroup_subsys {
>        struct cgroupfs_root *root;
>
>        struct list_head sibling;
> -
> -       void *private;
>  };
>
>  #define SUBSYS(_x) extern struct cgroup_subsys _x ## _subsys;
> @@ -410,7 +407,6 @@ void cgroup_mm_owner_callbacks(struct ta
>
>  static inline int cgroup_init_early(void) { return 0; }
>  static inline int cgroup_init(void) { return 0; }
> -static inline void cgroup_init_smp(void) {}
>  static inline void cgroup_fork(struct task_struct *p) {}
>  static inline void cgroup_fork_callbacks(struct task_struct *p) {}
>  static inline void cgroup_post_fork(struct task_struct *p) {}
> --- linux-mm/kernel/cgroup.c.orig       2008-10-20 13:25:56.000000000 +0800
> +++ linux-mm/kernel/cgroup.c    2008-10-20 13:26:08.000000000 +0800
> @@ -2104,7 +2104,6 @@ static void *cgroup_tasks_start(struct s
>        down_read(&cgrp->pids_mutex);
>        if (pid) {
>                int end = cgrp->pids_length;
> -               int i;
>                while (index < end) {
>                        int mid = (index + end) / 2;
>                        if (cgrp->tasks_pids[mid] == pid) {
>
