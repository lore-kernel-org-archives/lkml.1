Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZHSOzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZHSOzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 10:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZHSOzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 10:55:45 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38179 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbZHSOzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 10:55:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gCfTRq3VvHIxvWdU/1ph4he+9HODUoctAfXCMJz/GD+pWk5wSeuv5BhJ34viN/iW/U
         CDRimx7FNz39mXUfSeLTvM3v3BY40Nl3wLBTjaTLHdFlIAmcZyAbCmCcWAxK0qGxb+l3
         AeenVk3HyjhvNJfxJQ5LXRI2u2umST/329l04=
Date: Wed, 19 Aug 2009 16:55:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] tracing/syscalls: Add filtering support
Message-ID: <20090819145540.GB4972@nowhere>
References: <4A8BAF16.8040504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8BAF16.8040504@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 03:51:50PM +0800, Li Zefan wrote:
> This patchset adds filtering support for syscall events
> 
> For syscall enter events, we can do filtering on syscall
> parameters, and for exit events, filter on syscall return
> value.
> 
> For example, we set 'mode == 0666' (0666 == 0x1b6) to
> sys_enter_open, and set 'ret == 0' to sys_exit_open,
> and here's the output:
> 
>  # echo 'mode == 0666' > events/syscalls/sys_enter_open
>  # echo 'ret == 0' > events/syscalls/sys_exit_open
>  # echo 1 > events/syscalls/sys_enter_open
>  # echo 1 > events/syscalls/sys_exit_open
>  # cat trace
>  ...
>    modprobe-3084 [001] 117.463140: sys_open(filename: 917d3e8, flags: 0, mode: 1b6) 
>    modprobe-3084 [001] 117.463176: sys_open -> 0x0
>        less-3086 [001] 117.510455: sys_open(filename: 9c6bdb8, flags: 8000, mode: 1b6) 
>    sendmail-2574 [001] 122.145840: sys_open(filename: b807a365, flags: 0, mode: 1b6) 
>  ...



Nice! Thanks!


> 
> [PATCH 1/5] tracing/syscalls: Fix fields format for enter events
> [PATCH 2/5] tracing/syscalls: Add fields format for exit events
> [PATCH 3/5] tracing/events: Add ftrace_event_call param to define_fields()
> [PATCH 4/5] tracing/events: Add trace_define_common_fields()
> [PATCH 5/5] tracing/syscalls: Add filtering support
> ---
>  include/linux/ftrace_event.h  |   15 ++----
>  include/linux/syscalls.h      |   19 +++++--
>  include/trace/ftrace.h        |   11 ++---
>  include/trace/syscall.h       |   13 ++++-
>  kernel/trace/trace_events.c   |   29 +++++++++-
>  kernel/trace/trace_export.c   |   13 ++---
>  kernel/trace/trace_syscalls.c |  120 +++++++++++++++++++++++++++++++----------
>  7 files changed, 156 insertions(+), 64 deletions(-)

