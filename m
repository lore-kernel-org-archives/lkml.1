Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbYFEJ2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbYFEJ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYFEJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:28:11 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49451 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752717AbYFEJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:28:10 -0400
Date: Thu, 5 Jun 2008 14:57:45 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: containers@lists.osdl.org, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] introduce task cgroup (#task restrictioon for
	prevent fork bomb by cgroup)
Message-ID: <20080605092745.GA3734@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080605132512.9C31.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int task_cgroup_max_tasks_write(struct cgroup *cgrp,
> +				       struct cftype *cftype,
> +				       s64 max_tasks)
> +{
> +	struct task_cgroup *taskcg;
> +
> +	if ((max_tasks > INT_MAX) ||
> +	    (max_tasks < INT_MIN))

It should be < -1 I think.

> +		return -EINVAL;
> +
> +	taskcg = task_cgroup_from_cgrp(cgrp);
> +
> +	spin_lock(&taskcg->lock);
> +	if (max_tasks < taskcg->nr_tasks)
> +		return -EBUSY;

Shouldn't you drop the lock here?

> +	taskcg->max_tasks = max_tasks;
> +	spin_unlock(&taskcg->lock);
> +
> +	return 0;
> +}

How does this controller affect performance? Do you have some numbers?

Thanks,
-- 
regards,
Dhaval
