Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZANTty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZANTty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZANTtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:49:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:41766 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbZANTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:49:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l6AoPBfdxN1FvNY0S0rp5x1vBz1XVrjf1LlR53bHQAsxS4D1ZgwbFbL2jGroOM/Vgb
         tKZ2n4O9BABJgVVmCk1EMtAJHoPMypOHSnDQoI0l7gBHY2A6p0kGPVegMxLzAoflf85d
         qa8h+LcIEDzZgOrs7FfnE+eG7ClGtcF8+eHPM=
Date: Wed, 14 Jan 2009 22:49:33 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090114194933.GA8178@localhost>
References: <20090113183456.GA14470@localhost> <496E4040.9080701@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496E4040.9080701@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Jan 14, 2009 at 11:42:56AM -0800]
> Cyrill Gorcunov wrote:
>> Impact: cleanup
>>
>> 'make headers_check' warn us about leaking of kernel private
>> (mostly compile time vars) data to userspace in headers. Fix it.
>>
>> More detailed report for easier reviewing:
>>
>> 1) boot.h - neither BOOT_HEAP_SIZE, BOOT_STACK_SIZE refs
>>    was found by searching thru net (ie in user-space area).
>>
>> 2) prctl.h - sys_arch_prctl is completely removed from
>>    header since frankly I don't even understand why we
>>    describe it here. It is described like
>>     __SYSCALL(__NR_arch_prctl, sys_arch_prctl) in unistd_64.h
>>    and implemented in process_64.c. User-mode linux involved?
>>    So this one in fact is suspicious.
>>
>> 3) ptrace-abi.h - ptrace_bts_config struct is wrapped
>>    by __KERNEL__ -- not sure if it was ever proposed for
>>    userland.
>>
>> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
>>    could use it.
>>
>> 5) sigcontext32.h - we really need linux/types.h here
>>    since we use __u... types.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>
> Hi Cyrill; in addition to nonexporting COMMAND_LINE_SIZE, could you  
> submit this as a patchset to make post-integration bisect easier?
>
> 	-hpa
>

Hi Peter, to be sure -- you mean to make patchset with 5 patches?

		- Cyrill -
