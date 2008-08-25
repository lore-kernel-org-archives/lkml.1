Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbYHYQtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbYHYQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYHYQtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:49:25 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45439 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbYHYQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:49:24 -0400
Date: Mon, 25 Aug 2008 20:54:03 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pierre Morel <pmorel@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with self_ptrace
Message-ID: <20080825165403.GA604@tv-sign.ru>
References: <48B26083.8080506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B26083.8080506@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Pierre Morel wrote:
>
> @@ -550,6 +550,23 @@ asmlinkage long sys_ptrace(long request,
>  		goto out;
>  	}
>
> +	if (request == PTRACE_SELF_ON) {
> +		task_lock(current);
> +		set_thread_flag(TIF_SYSCALL_TRACE);
> +		current->ptrace |= PT_SELF;

I didn't read the whole patch, but this sets PT_SELF without PT_PTRACED
(and without ptrace_attach).

We have some "->ptrace != 0" checks which can misunderstand this. Just
for example, suppose that the task does sys_ptrace(PTRACE_SELF_ON) and
then its parent dies. I guess in that case forget_original_parent()
will hit BUG_ON(p->ptrace), no?

Oleg.

