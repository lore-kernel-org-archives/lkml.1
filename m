Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZLBBOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZLBBOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 20:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZLBBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 20:14:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754965AbZLBBOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 20:14:48 -0500
Message-ID: <4B15BF4E.2000606@cn.fujitsu.com>
Date: Wed, 02 Dec 2009 09:13:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] trace_syscalls: Remove unused	event_syscall_enter
 and event_syscall_exit
References: <4B14D278.4090209@cn.fujitsu.com> <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org> <20091201175403.GC5080@nowhere>
In-Reply-To: <20091201175403.GC5080@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:

> 
> Except for this patch. The whole series is really nice, thanks
> a lot for this cleanup!
> 
> 
> 

> But I think you fixed it the wrong way.
> 
> Why do we need a copy of this event_syscall_enter
> for each syscall event?
> Can't we actually drop enter_syscall_print_##sname
> and always use event_syscall_enter instead?
> 
> The same applies to exit syscall events.
> 
> Thanks.
> 

64c12e0444fcc6b75eb49144ba46d43dbdc6bc8f is a nice patch from
Jason Baron, this patch introduces enter_syscall_print_##sname.

This patch only forgot to do some cleanups. My patch make up it:

fix event_enter_##sname->event
fix event_exit_##sname->event

remove unused event_syscall_enter and event_syscall_exit

Thanks,
Lai

commit 64c12e0444fcc6b75eb49144ba46d43dbdc6bc8f
Author: Jason Baron <jbaron@redhat.com>
Date:   Mon Aug 10 16:52:53 2009 -0400

    tracing: Add individual syscalls tracepoint id support

    The current state of syscalls tracepoints generates only one event id
    for every syscall events.

    This patch associates an id with each syscall trace event, so that we
    can identify each syscall trace event using the 'perf' too
