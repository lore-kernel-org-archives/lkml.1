Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZBUKCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZBUKCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 05:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZBUKCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 05:02:39 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:50250 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbZBUKCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 05:02:38 -0500
Date: Sat, 21 Feb 2009 11:02:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Syscall wrappers breaks things.
Message-ID: <20090221110233.1baa9f5d@osiris.boeblingen.de.ibm.com>
In-Reply-To: <499EFB1A.7070801@caviumnetworks.com>
References: <499EFB1A.7070801@caviumnetworks.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 10:48:58 -0800
David Daney <ddaney@caviumnetworks.com> wrote:

> In commit ee6a093222549ac0c72cfd296c69fa5e7d6daa34 the syscall wrappers 
> infrastructure was introduced.
> 
> A typical definition is something like this (from Ralf's patch):
> 
> SYSCALL_DEFINE6(32_ipc, u32, call, long, first, long, second, long, third,
> 	unsigned long, ptr, unsigned long, fifth)
> {
> .
> 
> This creates a symbol sys_32_ipc.  The old name of the symbol is 
> sys32_ipc (note the change in the number of '_').
> 
> For the mips64 kernel the syscall table for o32 ABI executable contains:
> 	PTR	sys32_ipc
> This is now linked to the sys32_ipc function in kernel/sys_ni.c which 
> kindly returns ENOSYS.

Sure, the SYSCALL_DEFINE macros work only for system calls that follow
the sys_[whatever] naming convention. In this case the original system
call should be renamed. E.g. sys_mips_ipc.

> The long and short of the problem is that the is now a kernel wide 
> mismatch in function names between the names created by SYSCALL_DEFINE*, 
> the syscall tables and kernel/sys_ni.c.

Only if the macros are used in a wrong way.

> I am not sure what the best solution is, but something should probably 
> be done to un-break things.

Fix the patch that converts mips to system call wrappers ;)

Ralf's patch isn't in Linus' repository nor is it in linux-next. Or at
least I couldn't find it. So it looks like you're talking about some
private git tree?
