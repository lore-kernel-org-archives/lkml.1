Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZGATHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZGATHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 15:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZGATHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 15:07:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbZGATH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 15:07:29 -0400
Date: Wed, 1 Jul 2009 12:05:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <teawater@gmail.com>
Cc: xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, dhowells@redhat.com,
       Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, stable@kernel.org
Subject: Re: [PATCH] Fix the multithread program core thread message error
Message-Id: <20090701120519.d5b1ed78.akpm@linux-foundation.org>
In-Reply-To: <daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
	<20090701005437.GA5856@cr0.nay.redhat.com>
	<daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
	<20090701045102.GA6076@cr0.nay.redhat.com>
	<daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 14:21:37 +0800
Hui Zhu <teawater@gmail.com> wrote:

> Thanks for your help, Amerigo.
> 
> Hui
> 
> Fix the multithread program core thread message error.
> This issue just affect arch with neither has CORE_DUMP_USE_REGSET
> nor ELF_CORE_COPY_TASK_REGS, ARM is one of them.
> The thread message of core file is generated in
> elf_dump_thread_status.  The register values is set by
> elf_core_copy_task_regs in this function.
> If a arch doesn't define ELF_CORE_COPY_TASK_REGS, The function
> elf_core_copy_task_regs will do nothing.  Then the core file will
> not have the register message of thread.
> So add elf_core_copy_regs to set regiser values if
> ELF_CORE_COPY_TASK_REGS doesn't define.
> The following is how to reproduce this issue:
>
> ...
>
> Without the patch:
> (gdb) info threads
>  3 process 909  0x00000000 in ?? ()
>  2 process 908  0x00000000 in ?? ()
> * 1 process 907  0x4a6e2238 in raise () from /lib/libc.so.6
> You can found that the pc of 909 and 908 is 0x00000000.
> With the patch:
> (gdb) info threads
>  3 process 885  0x4a749974 in nanosleep () from /lib/libc.so.6
>  2 process 884  0x4a749974 in nanosleep () from /lib/libc.so.6
> * 1 process 883  0x4a6e2238 in raise () from /lib/libc.so.6
> The pc of 885 and 884 is right.

I'm trying to work out if we should backport this fix into earlier
kernels (2.6.30.x, 2.6.29.x, etc).

I'd have though that having gdb produce crap for all the threads would
be fairly irritating to ARM developers and hence we should backport
this.  But perhaps it doens't affect many people, dunno.

What do poeple think?

