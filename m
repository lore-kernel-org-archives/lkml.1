Return-Path: <linux-kernel-owner+w=401wt.eu-S938084AbXGTWmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938084AbXGTWmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 18:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938284AbXGTWlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 18:41:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44906 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938260AbXGTWlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 18:41:40 -0400
Date: Fri, 20 Jul 2007 15:41:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sukadev@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH 4/5] [V2] Define is_global_init() and
 is_container_init()
Message-Id: <20070720154113.db9fb8a4.akpm@linux-foundation.org>
In-Reply-To: <20070719072158.GD28216@us.ibm.com>
References: <20070719071206.GE10195@us.ibm.com>
	<20070719072158.GD28216@us.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 00:21:58 -0700
sukadev@us.ibm.com wrote:

> --- lx26-22-rc6-mm1a.orig/kernel/pid.c	2007-07-16 12:55:15.000000000 -0700
> +++ lx26-22-rc6-mm1a/kernel/pid.c	2007-07-16 13:10:48.000000000 -0700
> @@ -69,6 +69,13 @@ struct pid_namespace init_pid_ns = {
>  	.last_pid = 0,
>  	.child_reaper = &init_task
>  };
> +EXPORT_SYMBOL(init_pid_ns);
> +
> +int is_global_init(struct task_struct *tsk)
> +{
> +	return tsk == init_pid_ns.child_reaper;
> +}
> +EXPORT_SYMBOL(is_global_init);

I don't immediately see why init_pid_ns was exported to modules.

It would need to be exported if is_global_init() was made static inline in a
header (which seems like a sensible thing to do), but it wasn't.

