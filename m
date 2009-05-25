Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZEYWDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZEYWDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZEYWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:03:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57533 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbZEYWDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:03:39 -0400
Date: Mon, 25 May 2009 23:59:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090525215903.GA9113@redhat.com>
References: <20090525000016.GA2239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525000016.GA2239@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Oleg Nesterov wrote:
>
> Move task_struct->parent into ptrace_task->pt_tracer and change the users
> accordingly.
>
> ...
>
> @@ -1773,8 +1779,8 @@ static int ptrace_signal(int signr, sigi
>  		info->si_signo = signr;
>  		info->si_errno = 0;
>  		info->si_code = SI_USER;
> -		info->si_pid = task_pid_vnr(current->parent);
> -		info->si_uid = task_uid(current->parent);
> +		info->si_pid = task_pid_vnr(current->ptrace_task->pt_tracer);
> +		info->si_uid = task_uid(current->ptrace_task->pt_tracer);

This change is wrong, will re-do. The task can be already untraced
after ptrace_stop().

But is the current code correct? If we are not traced any longer
si_pid/si_uid are not necessary right either, we should calculate them
before ptrace_stop(), no?

Oleg.

