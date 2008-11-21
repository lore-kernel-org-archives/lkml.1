Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYKUS5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYKUS5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKUS5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:57:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:22087 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbYKUS5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:57:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=Bl6xC4Iz/E3/hti+TU8vO3o0IbvIFrHsK8Qoz1EPEjEcUb/6Qguw06Om39JtlxOw7
	64x+5oaETvEYRSoTXHVAw==
MIME-Version: 1.0
In-Reply-To: <4926762E.9010207@cn.fujitsu.com>
References: <4926762E.9010207@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 10:56:58 -0800
Message-ID: <6599ad830811211056x205f0fc7k6b0472dc34c03c69@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpuset: use cgroup_path() in proc_cpuset_show()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> use cgroup_path() instead of
> task_subsys_state(tsk, cpuset_subsys_id)->cgroup

You mean:

use task_cgroup() instead of task_subsys_state()->cgroup

>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 3e00526..e0e087e 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -2387,7 +2386,7 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
>        struct pid *pid;
>        struct task_struct *tsk;
>        char *buf;
> -       struct cgroup_subsys_state *css;
> +       struct cgroup *cgp;
>        int retval;
>
>        retval = -ENOMEM;
> @@ -2403,8 +2402,8 @@ static int proc_cpuset_show(struct seq_file *m, void *unused_v)
>
>        retval = -EINVAL;
>        cgroup_lock();
> -       css = task_subsys_state(tsk, cpuset_subsys_id);
> -       retval = cgroup_path(css->cgroup, buf, PAGE_SIZE);
> +       cgp = task_cgroup(tsk, cpuset_subsys_id);
> +       retval = cgroup_path(cgp, buf, PAGE_SIZE);
>        if (retval < 0)
>                goto out_unlock;
>        seq_puts(m, buf);
>
>
>
