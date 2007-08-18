Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbXHRTDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbXHRTDg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXHRTD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:03:27 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:39413 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXHRTD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:03:26 -0400
Date: Sat, 18 Aug 2007 23:03:51 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070818190351.GA98@tv-sign.ru>
References: <20070817222228.GA783@tv-sign.ru> <20070818115816.GA23555@hmsreliant.think-freely.org> <20070818125926.GA74@tv-sign.ru> <20070818185529.GA25372@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070818185529.GA25372@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18, Neil Horman wrote:
>
> +static int proc_pid_limits(struct task_struct *task, char *buffer)
> +{
> +	unsigned int i;
> +	int count = 0;
> +	unsigned long flags;
> +	char *bufptr = buffer;
> +
> +	struct rlimit rlim[RLIM_NLIMITS];
> +
> +	read_lock(&tasklist_lock);
> +	lock_task_sighand(task, &flags);
> +	if (task->signal == NULL){
> +		unlock_task_sighand(task, &flags);
> +		read_unlock(&tasklist_lock);

Neil, please, don't add tasklist_lock again. It was not easy to wipe it from
fs/proc/ :) Just change this code to use rcu_read_lock().

Oleg.

