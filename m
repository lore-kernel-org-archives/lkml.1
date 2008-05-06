Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbYEFUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbYEFUww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYEFUwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 16:52:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbYEFUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 16:52:41 -0400
Message-ID: <4820C4F1.4000107@redhat.com>
Date: Tue, 06 May 2008 16:52:01 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal> <20080505111029.GA9948@elte.hu> <20080505113057.GA28070@Krystal> <20080505122835.GA1523@elte.hu>
In-Reply-To: <20080505122835.GA1523@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Mathieu,

Ingo Molnar wrote:
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
>> Ideally, I'd like to have this kind of high-level information :
>>
>> event name : kernel syscall
>> syscall name : open
>> arg1 (%s) : "somefile"    <-----
>> arg2 (%d) : flags
>> arg3 (%d) : mode
>>
>> However, "somefile" has to be read from userspace. With the protection 
>> involved, it would cause a performance impact to read it a second time 
>> rather than tracing the string once it's been copied to kernel-space.
> 
> performance is a secondary issue here, and copies are fast anyway _if_ 
> someone wants to trace a syscall. (because the first copy brings the 
> cacheline into the cache, subsequent copies are almost for free compared 
> to the first copy)

I think that the code duplication is also an issue.
If we introduce functions which copy userspace strings same as
original syscall functions, we have to maintain similar codes.
So, I think Mathieu's approach (separating syscall parameters from
syscall entering event) is enough reasonable.

BTW, it seems that using KERNEL_TRACE per thread flag might be a bit
tricky to trace all threads. Out of curiosity:-), why did not you use a
global percpu flag to do it?

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


