Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYH0Cb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYH0Cb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 22:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbYH0Cbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 22:31:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36956 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYH0Cbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 22:31:51 -0400
Date: Tue, 26 Aug 2008 21:31:42 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Robert Rex <robert.rex@exasol.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] pid_ns: de_thread: kill the now unneeded
	->child_reaper change
Message-ID: <20080827023142.GB2320@us.ibm.com>
References: <20080824154912.GA3783@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824154912.GA3783@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@tv-sign.ru):
> de_thread() checks if the old leader was the ->child_reaper, this is not
> possible any longer. With the previous patch ->group_leader itself will
> change ->child_reaper on exit.

Neat.

> >From now find_new_reaper() is the only function (apart from initialization)
> which plays with ->child_reaper.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> 
> --- 2.6.27-rc4/fs/exec.c~3_EXEC	2008-07-30 13:12:47.000000000 +0400
> +++ 2.6.27-rc4/fs/exec.c	2008-08-24 19:20:05.000000000 +0400
> @@ -825,8 +825,6 @@ static int de_thread(struct task_struct 
>  			schedule();
>  		}
> 
> -		if (unlikely(task_child_reaper(tsk) == leader))
> -			task_active_pid_ns(tsk)->child_reaper = tsk;
>  		/*
>  		 * The only record we have of the real-time age of a
>  		 * process, regardless of execs it's done, is start_time.
