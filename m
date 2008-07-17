Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYGQIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYGQIvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 04:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbYGQIvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 04:51:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:21879 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbYGQIvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VYBqVNdicyQDDxuhQjEu/uyD39dkQf8mYBHJ/0tiHRe811mEYvCWiShQKVC+MYEOps
         mjukLq1wS8BQ8GEhOF3W6ELZb8Vuz0D8ze62oumDqoPWM+JfW0BxHCxSy4O/Ea1iFh2C
         abpeWF2ctO3+l27MgpFPb3nLg8RQr68Z9YBXg=
Date: Thu, 17 Jul 2008 12:48:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH 01/23] tracehook: add linux/tracehook.h
Message-ID: <20080717084818.GA5637@martell.zuzino.mipt.ru>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717072755.E2FBC15411D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717072755.E2FBC15411D@magilla.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:27:55AM -0700, Roland McGrath wrote:
> The aim is to formalize and consolidate all the places that the core
> kernel code and the arch code now ties into the ptrace implementation.
> 
> These patches mostly don't cause any functional change.  They just
> move the details of ptrace logic out of core code into tracehook.h
> inlines, where they are mostly compiled away to the same as before.

> All that changes is that everything is thoroughly documented

This is fine.

> and any future reworking of ptrace, or addition of something new,
> would not have to touch core code all over, just change the tracehook.h
> inlines.

And this is suprising wish given one can't predict how exactly those
"future reworking" will look like.

> The new linux/ptrace.h inlines are used by the following patches in the
> new tracehook_*() inlines.  Using these helpers for the ptrace event
> stops makes it simple to change or disable the old ptrace implementation
> of these stops conditionally later.

Call them "utrace_*" from the start?

> --- a/include/linux/ptrace.h
> +++ b/include/linux/ptrace.h
> @@ -121,6 +121,39 @@ static inline void ptrace_unlink(struct task_struct *child)
>  int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
>  int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
>  
> +/**
> + * task_ptrace - return %PT_* flags that apply to a task
> + * @task:	pointer to &task_struct in question
> + *
> + * Returns the %PT_* flags that apply to @task.
> + */
> +static inline int task_ptrace(struct task_struct *task)
> +{
> +	return task->ptrace;
> +}

Pointless 1:1 wrapper unless you're going to #ifdef ->ptrace later.

