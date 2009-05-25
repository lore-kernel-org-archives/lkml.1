Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZEYDd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZEYDd3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 23:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZEYDdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 23:33:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZEYDdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 23:33:21 -0400
Date: Mon, 25 May 2009 05:33:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/X] ptrace: mv task_struct->ptrace
	ptrace_task->pt_flags, kill ptrace_link()
Message-ID: <20090525033303.GB20687@elte.hu>
References: <20090525000008.GA2228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525000008.GA2228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

>  struct ptrace_task {
> +	unsigned long	pt_flags;
>  };

> -	return task->ptrace;
> +	return unlikely(task->ptrace_task) ?
> +		task->ptrace_task->pt_flags : 0;

Please no pt_ prefixes. It is abundantly clear from the 
'->ptrace_ctx' portion already that it's about ptrace - the rest 
should be a straightforward minimalistic naming - i.e. 
->ptrace_ctx->flags.

Also, is the conditional necessary? We should not be calling ptrace 
methods on tasks with no ptrace context.

Thanks,

	Ingo
