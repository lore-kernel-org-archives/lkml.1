Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZHLLDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZHLLDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 07:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932530AbZHLLD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 07:03:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32832 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbZHLLD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 07:03:28 -0400
Date: Wed, 12 Aug 2009 13:03:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812110307.GA806@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812091133.GA21655@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


one thing i noticed is that we dont seem to be catching 
compat syscalls properly:

phoenix:~/linux/linux/tools/perf> perf stat -e 
syscalls:sys_enter_read -e syscalls:sys_enter_write -e 
syscalls:sys_enter_mmap ~/hackbench 10
Time: 0.236

 Performance counter stats for '/home/mingo/hackbench 10':

              0  syscalls:sys_enter_read 
              0  syscalls:sys_enter_write
              0  syscalls:sys_enter_mmap 

    0.270062020  seconds time elapsed

phoenix:~/linux/linux/tools/perf> file ~/hackbench 
/home/mingo/hackbench: ELF 32-bit LSB executable, Intel 
80386, version 1 (SYSV), dynamically linked (uses shared 
libs), for GNU/Linux 2.2.5, not stripped
phoenix:~/linux/linux/tools/perf> uname -a
Linux phoenix 2.6.31-rc5-tip #3 SMP Wed Aug 12 12:50:38 CEST 
2009 x86_64 x86_64 x86_64 GNU/Linux


phoenix:~> perf stat -e syscalls:sys_enter_read -e 
syscalls:sys_enter_write -e syscalls:sys_enter_mmap 
~/hackbench64 10
Running with 10*40 (== 400) tasks.
Time: 0.199

 Performance counter stats for '/home/mingo/hackbench64 10':

         400402  syscalls:sys_enter_read 
         400403  syscalls:sys_enter_write
             12  syscalls:sys_enter_mmap 

    0.247919263  seconds time elapsed

phoenix:~> file hackbench64 
hackbench64: ELF 64-bit LSB executable, x86-64, version 1 
(SYSV), dynamically linked (uses shared libs), for GNU/Linux 
2.6.9, not stripped

	Ingo
