Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYKGJSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYKGJSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKGJRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:17:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52522 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbYKGJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:17:45 -0500
Date: Fri, 7 Nov 2008 01:16:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] add /proc/pid/stack to dump task's stack trace
Message-Id: <20081107011659.98d3788a.akpm@linux-foundation.org>
In-Reply-To: <20081107090304.GA30540@elte.hu>
References: <20081106203520.GD3578@elte.hu>
	<20081107003021.GA18666@google.com>
	<20081107004824.GA28780@x200.localdomain>
	<20081107074147.GA26607@elte.hu>
	<20081107075925.GA1825@elte.hu>
	<20081107082003.GA15800@x200.localdomain>
	<20081107083249.GD4435@elte.hu>
	<20081107084943.GA16147@x200.localdomain>
	<20081107085352.GA27245@elte.hu>
	<20081107090304.GA30540@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 10:03:04 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> task running on this CPU:
> 
>  # cat /proc/self/stack
>  [<ffffffff80216f79>] save_stack_trace_tsk+0x26/0x44
>  [<ffffffff802f59a5>] proc_pid_stack+0x6e/0xd3
>  [<ffffffff802f6da3>] proc_info_read+0x68/0xba
>  [<ffffffff802b2f17>] vfs_read+0xa9/0xe3
>  [<ffffffff802b301f>] sys_read+0x4c/0x73
>  [<ffffffff8020c23b>] system_call_fastpath+0x16/0x1b
>  [<ffffffffffffffff>] 0xffffffffffffffff

So we provide a means by which process A can sample process B's
instruction pointer?  Even if it's in random.c or crypto code?  There's
a little project for someone.

I guess the 0400 mode on that file will suffice...

