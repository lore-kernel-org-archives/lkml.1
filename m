Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZEZVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZEZVWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbZEZVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:22:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197AbZEZVWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:22:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/X] ptrace: mv task_struct->ptrace
	ptrace_task->pt_flags, kill ptrace_link()
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 02:00:08 +0200 <20090525000008.GA2228@redhat.com>
References: <20090525000008.GA2228@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090526205537.C5101FC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 13:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline int task_ptrace(struct task_struct *task)
>  {
> -	return task->ptrace;
> +	return unlikely(task->ptrace_task) ?
> +		task->ptrace_task->pt_flags : 0;

This merits a short comment reminding the reader that once ->ptrace_task is
allocated, it is never freed until @task is freed, so this access is always
safe.


Thanks,
Roland
