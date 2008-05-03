Return-Path: <linux-kernel-owner+w=401wt.eu-S1765168AbYECRO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765168AbYECRO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760557AbYECROt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:14:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760332AbYECROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:14:48 -0400
Date: Sat, 3 May 2008 10:13:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] unify sys_pipe implementation
In-Reply-To: <200805030403.m4343j5u014868@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0805031012580.5994@woody.linux-foundation.org>
References: <200805030403.m4343j5u014868@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 May 2008, Ulrich Drepper wrote:
> 
> +#ifdef __ARCH_WANT_SYS_PIPE
> +/*
> + * sys_pipe() is the normal C calling standard for creating
> + * a pipe. It's not the way Unix traditionally does this, though.
> + */
> +asmlinkage long sys_pipe(unsigned long __user *fildes)

Gaah. If you do this, at least clean it up and use "int *fildes", rather 
than copying the uglier old "unsigned long" ones that only exist because 
originally we had lots of odd int/long things that didn't matter on x86.

Yeah, yeah, the thing that matters is actually

> +	int fd[2];
>	...
> +		if (copy_to_user(fildes, fd, sizeof(fd)))

so it happens to work on all architectures anyway, but..

Also, we shouldn't need __ARCH_WANT_SYS_PIPE for this. Just make it 
unconditional, and then any architecture that wants somethign else can do 
their own "myarch_sys_pipe()" or whatever.

		Linus
