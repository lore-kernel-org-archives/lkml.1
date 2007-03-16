Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXCPRAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXCPRAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXCPRAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:00:08 -0400
Received: from mail.screens.ru ([213.234.233.54]:36031 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965654AbXCPRAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:00:06 -0400
Date: Fri, 16 Mar 2007 20:02:55 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, containers@lists.osdl.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
Message-ID: <20070316170255.GA194@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:

> @@ -1237,26 +1237,24 @@ static struct task_struct *copy_process(
>  		}
>  	}
>
> -	if (likely(p->pid)) {
> -		add_parent(p);
> -		tracehook_init_task(p);
> -
> -		if (thread_group_leader(p)) {
> -			pid_t pgid = process_group(current);
> -			pid_t sid = process_session(current);
> -
> -			p->signal->tty = current->signal->tty;
> -			p->signal->pgrp = pgid;
> -			set_signal_session(p->signal, process_session(current));
> -			attach_pid(p, PIDTYPE_PGID, find_pid(pgid));
> -			attach_pid(p, PIDTYPE_SID, find_pid(sid));
> +	add_parent(p);

This means that idle threads (except "swapper") are visible to for_each_process()
and do_each_thread(). Looks dangerous and somewhat strange to me.

Could you explain this change?

Oleg.

