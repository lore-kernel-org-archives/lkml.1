Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZHLLdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZHLLdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbZHLLdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:33:13 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:20059 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZHLLdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GwEWs6bo+rfijO9SpvUNpyhnq9v68/IJUpIWsmp8xMF47o+ni7u+9lhfVZFu6MjtQm
         We4+cuaXEN1PUGL2qB9Grw/NBnFtF8itd05jn+/SOxxkdGNc2hUCupNHuhz5LRsmU66+
         iMFJh7twjBrk5EaP/3XaeHMwLqEUzjGSgWksM=
Date: Wed, 12 Aug 2009 13:33:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812113308.GD6081@nowhere>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090812110307.GA806@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812110307.GA806@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 01:03:07PM +0200, Ingo Molnar wrote:
> 
> one thing i noticed is that we dont seem to be catching 
> compat syscalls properly:


Oh right. While looking at fs/compat.c, it seems most of the
compat syscalls haven't been defined through the SYSCALL_DEFINE
macro.

Grr...

Frederic.


 
> phoenix:~/linux/linux/tools/perf> perf stat -e 
> syscalls:sys_enter_read -e syscalls:sys_enter_write -e 
> syscalls:sys_enter_mmap ~/hackbench 10
> Time: 0.236
> 
>  Performance counter stats for '/home/mingo/hackbench 10':
> 
>               0  syscalls:sys_enter_read 
>               0  syscalls:sys_enter_write
>               0  syscalls:sys_enter_mmap 
> 
>     0.270062020  seconds time elapsed
> 
> phoenix:~/linux/linux/tools/perf> file ~/hackbench 
> /home/mingo/hackbench: ELF 32-bit LSB executable, Intel 
> 80386, version 1 (SYSV), dynamically linked (uses shared 
> libs), for GNU/Linux 2.2.5, not stripped
> phoenix:~/linux/linux/tools/perf> uname -a
> Linux phoenix 2.6.31-rc5-tip #3 SMP Wed Aug 12 12:50:38 CEST 
> 2009 x86_64 x86_64 x86_64 GNU/Linux
> 
> 
> phoenix:~> perf stat -e syscalls:sys_enter_read -e 
> syscalls:sys_enter_write -e syscalls:sys_enter_mmap 
> ~/hackbench64 10
> Running with 10*40 (== 400) tasks.
> Time: 0.199
> 
>  Performance counter stats for '/home/mingo/hackbench64 10':
> 
>          400402  syscalls:sys_enter_read 
>          400403  syscalls:sys_enter_write
>              12  syscalls:sys_enter_mmap 
> 
>     0.247919263  seconds time elapsed
> 
> phoenix:~> file hackbench64 
> hackbench64: ELF 64-bit LSB executable, x86-64, version 1 
> (SYSV), dynamically linked (uses shared libs), for GNU/Linux 
> 2.6.9, not stripped
> 
> 	Ingo

