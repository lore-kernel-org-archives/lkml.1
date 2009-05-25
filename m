Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZEYQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZEYQIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZEYQI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:08:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZEYQI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:08:26 -0400
Date: Mon, 25 May 2009 18:03:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/X] ptrace: mv task_struct->ptrace
	ptrace_task->pt_flags, kill ptrace_link()
Message-ID: <20090525160351.GB10431@redhat.com>
References: <20090525000008.GA2228@redhat.com> <20090525033303.GB20687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525033303.GB20687@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> >  struct ptrace_task {
> > +	unsigned long	pt_flags;
> >  };
>
> > -	return task->ptrace;
> > +	return unlikely(task->ptrace_task) ?
> > +		task->ptrace_task->pt_flags : 0;
>
> Please no pt_ prefixes. It is abundantly clear from the
> '->ptrace_ctx' portion already that it's about ptrace - the rest
> should be a straightforward minimalistic naming - i.e.
> ->ptrace_ctx->flags.

OK, will rename.

But note that you can't use cscope to find the usage of ->flags. Even
grep is not reliable, unless the code always adds 'ptrace' to the name
of the pointer.

> Also, is the conditional necessary? We should not be calling ptrace
> methods on tasks with no ptrace context.

It is mostly used as is_task_ptraced() actually, that is why ptrace context
can be NULL.

This in turn needs cleanups, will be addressed further.

Oleg.

