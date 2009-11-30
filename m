Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbZK3PLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbZK3PLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZK3PLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:11:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZK3PLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:11:46 -0500
Date: Mon, 30 Nov 2009 10:11:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Subodh Nijsure <nijsure.subodh@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: ftrace not showing stack trace data during boot processes
Message-ID: <20091130151151.GA1716@goodmis.org>
References: <110c8b2e0911291820t410c2908t90dfc97b340b9725@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <110c8b2e0911291820t410c2908t90dfc97b340b9725@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, please Cc maintainers directly if you want a response. This mailing
list has a traffic of 600 emails a day, and things sent here can easily
be lost.

On Sun, Nov 29, 2009 at 06:20:35PM -0800, Subodh Nijsure wrote:
> I am trying to debug some boot sequences during kernel bootup and
> trying to use ftrace to discover function flow.
> 
> I am booting kernel with following options.
> 
> stacktrace trace_buf_size=30M ftrace=function

Note, the stacktrace is the stack tracer, not the tracing option of "stacktrace"
or the function trace option "func_stack_trace".

The output of the stack tracer just shows the max stack trace and is listed in

debugfs/tracing/stack_trace

> ftrace_filter=do_sync_write,usbfs*,ext2_*,vfs_write,blkdev_*,vfs_write,sys_write
> ftrace_notrace=ext2_permission
> 
> I have compiled kernel with following options
> 
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_RING_BUFFER=y
> CONFIG_TRACING=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_SYSPROF_TRACER=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_BOOT_TRACER=y
> CONFIG_STACK_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> 
> However when I look at  /sys/kernel/debug/tracing/trace
> 
> I see output similar to this and  I don't see the "stack trace"
>             init-1     [000]    65.317499: sys_write <-sysenter_do_call
>             init-1     [000]    65.317504: vfs_write <-sys_write
>             init-1     [000]    65.317617: sys_write <-sysenter_do_call
>             init-1     [000]    65.317619: vfs_write <-sys_write
> 
> Is there option I am missing while compiling kernel or some part of
> kernel parameters is missing? Is there way to explicitly specify
> iter_ctrl on kernel boot cmdline?

Currently there is no way to enable an option from the kernel command line. I could
write something up though.

-- Steve

