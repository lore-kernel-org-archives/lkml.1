Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZKDLRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZKDLRt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZKDLRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:17:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56546 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbZKDLRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:17:48 -0500
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] update fix X86_64 procfs provide stack information for threads
From: Andi Kleen <andi@firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
Date: Wed, 04 Nov 2009 12:17:52 +0100
In-Reply-To: <1257233486.22553.6.camel@wall-e> (Stefani Seibold's message of "Tue, 03 Nov 2009 08:31:26 +0100")
Message-ID: <874opaa68v.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:
>  
> +#ifdef CONFIG_IA32_EMULATION
> +unsigned long KSTK_ESP(struct task_struct *task)
> +{
> +	return (test_tsk_thread_flag(task, TIF_IA32)) ? \
> +			(task_pt_regs(task)->sp) : \
> +			((task)->thread.usersp);

Usersp is only set for system calls, but not when the process is blocked
in a interrupt.

In general if you really want a reliable implementation of this
you would really need to stop the task and grab the stack pointer;
otherwise it can be arbitarily outdated anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
