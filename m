Return-Path: <linux-kernel-owner+w=401wt.eu-S1751209AbXAaH6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbXAaH6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 02:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXAaH6C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 02:58:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbXAaH6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 02:58:00 -0500
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
From: Andi Kleen <ak@suse.de>
Date: 31 Jan 2007 09:58:38 +0100
In-Reply-To: <5bdda0f7bef20427f7e1.1170193185@tetsuo.zabbo.net>
Message-ID: <p73abzzpo75.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown <zach.brown@oracle.com> writes:

> This finally does something useful with the notion of being able to schedule
> stacks as fibrils under a task_struct.  Again, i386-specific and in need of
> proper layering with archs.
> 
> sys_asys_submit() is added to let userspace submit asynchronous system calls.
> It specifies the system call number and arguments.  A fibril is constructed for
> each call.  Each starts with a stack which executes the given system call
> handler and then returns to a function which records the return code of the
> system call handler.  sys_asys_await_completion() then lets userspace collect
> these results.

Do you have any numbers how this compares cycle wise to just doing
clone+syscall+exit in user space? 

If the difference is not too big might it be easier to fix
clone+syscall to be more efficient than teach all the rest
of the kernel about fibrils? 

-Andi
