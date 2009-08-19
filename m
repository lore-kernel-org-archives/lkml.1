Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZHSDGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZHSDGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZHSDGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:06:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53090 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751826AbZHSDGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:06:17 -0400
Message-ID: <4A8B6C01.1060503@redhat.com>
Date: Tue, 18 Aug 2009 20:05:37 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com> <4A8B5624.9040607@cn.fujitsu.com>
In-Reply-To: <4A8B5624.9040607@cn.fujitsu.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2009 06:32 PM, Li Zefan wrote:
> It would be much better to see a sample output of these TRACE_EVENTs,
> so we'll see the what's the output if a syscall has less than 6 args.
> 
> And I guess it should be "(%lx, %lx, ..., %lx)"? Otherwise I think we'll
> see some negative values.

Thanks, you're right -- the args should be unsigned long.  Whether they
are hex or decimal doesn't matter to me, but I guess that does make
pointers easier to spot.

Here's some output that I get on x86_64:

> # tail trace
>             tail-1106  [000] 113218.474657: syscall_enter: NR 2 (7f2d34dd38f0, 0, 7f2d35009010, 5, 4, ffffffffffffffb0)
> 
>             tail-1106  [000] 113218.474809: syscall_enter: NR 5 (3, 7f2d35009040, 7f2d35009040, 5, 4, ffffffffffffffb0)
> 
>             tail-1106  [000] 113218.474855: syscall_enter: NR 9 (0, 50d3ad0, 1, 2, 3, 0)
> 
>             tail-1106  [000] 113218.474946: syscall_enter: NR 3 (3, 7f2d2f9a0000, 5e22, 2, 3, 0)
> 
>             tail-1106  [000] 113218.475673: syscall_enter: NR 2 (7fff5e42a654, 0, 0, 7fff5e429600, 80, 3)

It's very raw indeed, but that's what Ingo asked for. :)  The extra args
show up as whatever happened to be in those registers.

Josh
