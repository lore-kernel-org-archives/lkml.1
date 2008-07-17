Return-Path: <linux-kernel-owner+w=401wt.eu-S932782AbYGQVQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbYGQVQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757890AbYGQVQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:16:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755222AbYGQVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:16:23 -0400
Date: Thu, 17 Jul 2008 14:10:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Daniel Hokka Zakrisson" <daniel@hozac.com>
Cc: ebiederm@xmission.com, xemul@openvz.org, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       oleg@tv-sign.ru
Subject: Re: [PATCH 1/1] signal: Introduce kill_pid_ns_info
Message-Id: <20080717141005.5534fbc2.akpm@linux-foundation.org>
In-Reply-To: <58550.192.168.102.6.1216323456.squirrel@intranet>
References: <58550.192.168.102.6.1216323456.squirrel@intranet>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 21:37:36 +0200 (CEST)
"Daniel Hokka Zakrisson" <daniel@hozac.com> wrote:

> Author: Eric W. Biederman <ebiederm@xmission.com>
> 
> Implement the basic helper function that walks all of the processes in a
> pid namespace and sends them all a signal.
> 
> Both locations that could use this functions are also updated to use this
> function.
> 
> I use find_ge_pid instead of for_each_process because it has a chance of
> not touching every process in the system.
> 
> [daniel@hozac.com: Optimize away nr <= 1 check, against latest Linus tree]
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ba2f859..83597f8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1778,6 +1778,8 @@ extern void release_task(struct task_struct * p);
>  extern int send_sig_info(int, struct siginfo *, struct task_struct *);
> extern int force_sigsegv(int, struct task_struct *);

Space-stuffed

>  extern int force_sig_info(int, struct siginfo *, struct task_struct *);
> +extern int __kill_pid_ns_info(int sig, struct siginfo *info, struct
> pid_namespace *ns);

word-wrapped

> +extern int kill_pid_ns_info(int sig, struct siginfo *info, struct
> pid_namespace *ns);
>  extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid
> *pgrp);
>  extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
> extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *,
> uid_t, uid_t, u32);
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 98702b4..9226423 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -153,29 +153,14 @@ void free_pid_ns(struct kref *kref)
> 
>  void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  {
> -	int nr;
>  	int rc;

but at least the tabs weren't replaced with spaces!

Fix and resend, please.
