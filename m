Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYFEFXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYFEFXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 01:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYFEFXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 01:23:43 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58799 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYFEFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 01:23:43 -0400
Date: Thu, 5 Jun 2008 14:23:20 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for
 prevent fork bomb by cgroup)
Message-Id: <20080605142320.cdc8b21a.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I think this would be usefull.

On Thu, 05 Jun 2008 13:43:06 +0900, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> Index: b/kernel/cgroup_task.c
> ===================================================================
> --- /dev/null
> +++ b/kernel/cgroup_task.c
> @@ -0,0 +1,185 @@
> +/* cgroup_task.c - #task control group
> + *
> + * Copyright: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/res_counter.h>
I don't think it's needed.
Or, are you planning to implement this feature by using res_counter?

> +static int task_cgroup_max_tasks_write(struct cgroup *cgrp,
> +				       struct cftype *cftype,
> +				       s64 max_tasks)
> +{
> +	struct task_cgroup *taskcg;
> +
> +	if ((max_tasks > INT_MAX) ||
> +	    (max_tasks < INT_MIN))
> +		return -EINVAL;
> +
> +	taskcg = task_cgroup_from_cgrp(cgrp);
> +
> +	spin_lock(&taskcg->lock);
> +	if (max_tasks < taskcg->nr_tasks)
> +		return -EBUSY;
need spin_unlock().


Thanks,
Daisuke Nishimura.
