Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYBAW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYBAW2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYBAW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:28:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754697AbYBAW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:28:28 -0500
Date: Fri, 1 Feb 2008 14:27:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org, oleg@tv-sign.ru,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 12/12] Deprecate the find_task_by_pid
Message-Id: <20080201142750.8f92d8c8.akpm@linux-foundation.org>
In-Reply-To: <479F33B3.1030301@openvz.org>
References: <479F2C5C.1050303@openvz.org>
	<479F33B3.1030301@openvz.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008 17:09:55 +0300
Pavel Emelyanov <xemul@openvz.org> wrote:

> diff --git a/kernel/kgdb.c b/kernel/kgdb.c
> index 87b0463..6de0fd0 100644
> --- a/kernel/kgdb.c
> +++ b/kernel/kgdb.c
> @@ -621,7 +621,7 @@ static struct task_struct *getthread(struct pt_regs *regs, int tid)
>  	if (!tid)
>  		return NULL;
>  
> -	return find_task_by_pid(tid);
> +	return find_task_by_pid_ns(tid, &init_pid_ns);
>  }
>  
>  #ifdef CONFIG_SMP

The code I currently have here has changed.  Is has grown a nice comment:

	/*
	 * find_task_by_pid() does not take the tasklist lock anymore
	 * but is nicely RCU locked - hence is a pretty resilient
	 * thing to use:
	 */
	return find_task_by_pid(tid);

I updated the comment appropriately
(s/find_task_by_pid/find_task_by_pid_ns/).  Please check that this was
true.
