Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbZCJPzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbZCJPzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbZCJPyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:54:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47499 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753821AbZCJPyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:54:50 -0400
Date: Tue, 10 Mar 2009 11:54:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ingo Molnar <mingo@elte.hu>
cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 08/11] Modify Ptrace routines to access breakpoint
 registers
In-Reply-To: <20090310144002.GF3850@elte.hu>
Message-ID: <Pine.LNX.4.44L0.0903101153520.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009, Ingo Molnar wrote:

> 
> * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> 
> > -static unsigned long debugreg_addr_limit(struct task_struct *task)
> > -{
> > -#ifdef CONFIG_IA32_EMULATION
> > -	if (test_tsk_thread_flag(task, TIF_IA32))
> > -		return IA32_PAGE_OFFSET - 3;
> > -#endif
> > -	return TASK_SIZE_MAX - 7;
> > -}
> > -
> 
> I dont see where this security check has been carried over into 
> the generic code. The new code has:

Probably the IA32_EMULATION stuff was added after the hw-breakpoint 
patch was written.

>  +int arch_check_va_in_userspace(unsigned long va, struct task_struct *tsk)
>  +{
>  +       return (va < TASK_SIZE);
>  +}
> 
> but i think that misses the detail that it's not just the start 
> address of an x86 breakpoint that has to be considered, but also 
> the end addess of it.
> 
> For example a hardware breakpoint can be at 0xbfffffff with a 
> length of 4 bytes - thus overlapping into kernel-space by 3 
> bytes. It is important to not let that happen.

Quite correct.

Alan Stern

