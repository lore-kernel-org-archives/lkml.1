Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYFEFIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYFEFIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 01:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYFEFIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 01:08:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35412 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYFEFIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 01:08:23 -0400
Date: Thu, 5 Jun 2008 14:13:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for
 prevent fork bomb by cgroup)
Message-Id: <20080605141318.ee9ec8a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 13:43:06 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> +static int task_cgroup_max_tasks_write(struct cgroup *cgrp,
> +				       struct cftype *cftype,
> +				       s64 max_tasks)
> +{
> +	struct task_cgroup *taskcg;
> +
> +	if ((max_tasks > INT_MAX) ||
> +	    (max_tasks < INT_MIN))
> +		return -EINVAL;

should be (max_tasks > INT_MAX) || (max_tasks < -1)) ?

> +
> +	taskcg = task_cgroup_from_cgrp(cgrp);
> +
> +	spin_lock(&taskcg->lock);
> +	if (max_tasks < taskcg->nr_tasks)
> +		return -EBUSY;
> +	taskcg->max_tasks = max_tasks;
> +	spin_unlock(&taskcg->lock);
This will cause dead lock.

And it seems this doesn't handle "attach failure".

It will be helpful Documentation somewhere.

Thanks,
-Kame

