Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbZANTmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbZANTmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZANTml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:42:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZANTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:42:40 -0500
Message-ID: <496E4040.9080701@zytor.com>
Date: Wed, 14 Jan 2009 11:42:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to userspace
References: <20090113183456.GA14470@localhost>
In-Reply-To: <20090113183456.GA14470@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> Impact: cleanup
> 
> 'make headers_check' warn us about leaking of kernel private
> (mostly compile time vars) data to userspace in headers. Fix it.
> 
> More detailed report for easier reviewing:
> 
> 1) boot.h - neither BOOT_HEAP_SIZE, BOOT_STACK_SIZE refs
>    was found by searching thru net (ie in user-space area).
> 
> 2) prctl.h - sys_arch_prctl is completely removed from
>    header since frankly I don't even understand why we
>    describe it here. It is described like
>     __SYSCALL(__NR_arch_prctl, sys_arch_prctl) in unistd_64.h
>    and implemented in process_64.c. User-mode linux involved?
>    So this one in fact is suspicious.
> 
> 3) ptrace-abi.h - ptrace_bts_config struct is wrapped
>    by __KERNEL__ -- not sure if it was ever proposed for
>    userland.
> 
> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
>    could use it.
> 
> 5) sigcontext32.h - we really need linux/types.h here
>    since we use __u... types.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Hi Cyrill; in addition to nonexporting COMMAND_LINE_SIZE, could you 
submit this as a patchset to make post-integration bisect easier?

	-hpa
