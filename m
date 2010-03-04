Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0CDUze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:55:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498Ab0CDUzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:55:32 -0500
Message-ID: <4B901E23.4080701@redhat.com>
Date: Thu, 04 Mar 2010 15:54:59 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 09/14] perf, x86: use LBR for PEBS IP+1 fixup
References: <20100304140046.596569763@chello.nl>	 <20100304140100.619375431@chello.nl>  <4B8FDE16.3050403@redhat.com> <1267725262.25158.206.camel@laptop>
In-Reply-To: <1267725262.25158.206.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2010-03-04 at 11:21 -0500, Masami Hiramatsu wrote:
>> Peter Zijlstra wrote:
> 
>>> +#define perf_misc_flags(regs)				\
>>> +({	int misc = 0;					\
>>> +	if (user_mode(regs))				\
>>> +		misc |= PERF_RECORD_MISC_USER;		\
>>> +	else						\
>>> +		misc |= PERF_RECORD_MISC_KERNEL;	\
>>> +	if (regs->flags & PERF_EFLAGS_EXACT)		\
>>> +		misc |= PERF_RECORD_MISC_EXACT;		\
>>> +	misc; })
>>> +
>>> +#define perf_instruction_pointer(regs)	((regs)->ip)
>>
>> Hmm, why don't you use instruction_pointer() defined in asm/ptrace.h?
>> And I couldn't find any user of this macro in this patch...
> 
> perf_instruction_pointer() is used in kernel/perf_event.c, and yeah I
> could have used instruction_pointer() but that's yet another wrapper.
> 
> Anyway, Yanmin is poking at doing kvm-guest profiling and will likely
> rewrite all of the perf_misc() and perf_instruction_pointer() stuff
> soon.

Hmm, still I can't find where it is used (in your patches).
Anyway, would you mean that perf_instruction_pointer() will
have different implementation by Yanmin?

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
