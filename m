Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbYAOVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbYAOVRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYAOVQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:16:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:32971 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYAOVQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:16:57 -0500
Date: Tue, 15 Jan 2008 15:16:56 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #6 retry 02/21] Add struct vfsmount to struct
	task_struct.
Message-ID: <20080115211656.GA10644@sergelap.austin.ibm.com>
References: <20080109005320.323184643@nttdata.co.jp> <20080109005418.469053691@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109005418.469053691@nttdata.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I must say I personally prefer the apparmor approach.  But I'd recommend
you get together and get this piece pushed on its own, whichever version
you can agree on.  Yes it needs a user, but at this point I would think
both tomoyo and apparmor have had enough visibility that everyone knows
the intended users.

It seems to me you're both being held up by this piece, and getting
another full posting of either tomoyo or apparmor isn't going to help,
so hopefully you can combine your efforts to get this solved.

thanks,
-serge

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> This patch allows VFS wrapper functions associate "struct vfsmount"
> with "struct task_struct" so that LSM hooks can calculate
> pathname of given "struct dentry".
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/init_task.h |    1 +
>  include/linux/sched.h     |    2 ++
>  2 files changed, 3 insertions(+)
> 
> --- linux-2.6-mm.orig/include/linux/init_task.h
> +++ linux-2.6-mm/include/linux/init_task.h
> @@ -187,6 +187,7 @@ extern struct group_info init_groups;
>  	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
>  	INIT_TRACE_IRQFLAGS						\
>  	INIT_LOCKDEP							\
> +	.last_vfsmount  = NULL,                                         \
>  }
> 
> 
> --- linux-2.6-mm.orig/include/linux/sched.h
> +++ linux-2.6-mm/include/linux/sched.h
> @@ -1238,6 +1238,8 @@ struct task_struct {
>  	int make_it_fail;
>  #endif
>  	struct prop_local_single dirties;
> +	/* vfsmount info for LSM hooks. */
> +	struct vfsmount *last_vfsmount;
>  };
> 
>  /*
> 
> -- 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
