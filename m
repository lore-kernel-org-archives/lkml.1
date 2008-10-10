Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbYJJKW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbYJJKW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYJJKWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:22:17 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:44200 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbYJJKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:22:16 -0400
Message-ID: <48EF2CB3.9040900@fr.ibm.com>
Date: Fri, 10 Oct 2008 12:21:39 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC v6][PATCH 3/9] x86 support for checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu> <1223461197-11513-4-git-send-email-orenl@cs.columbia.edu>
In-Reply-To: <1223461197-11513-4-git-send-email-orenl@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +int cr_read_cpu_fpu(struct cr_hdr_cpu *hh, struct task_struct *t)
> +{
> +	struct thread_struct *thread = &t->thread;
> +
> +	/* i387 + MMU + SSE */
> +
> +	preempt_disable();
> +
> +	__clear_fpu(t);		/* in case we used FPU in user mode */
> +
> +	if (!hh->used_math)
> +		clear_used_math();
> +	else {
> +		if (hh->has_fxsr != cpu_has_fxsr) {
> +			force_sig(SIGFPE, t);
> +			return -EINVAL;
> +		}

don't you need an init_fpu() around here ? because the task you restart might 
not have used FPU yet.

> +		memcpy(&thread->xstate, &hh->xstate, sizeof(thread->xstate));

also i'd used 'xstate_size' instead of sizeof(thread->xstate)


thanks,

C.
