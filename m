Return-Path: <linux-kernel-owner+w=401wt.eu-S936649AbXLQVx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936649AbXLQVx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbXLQVxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:53:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761518AbXLQVxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:53:11 -0500
Message-ID: <4766EFA8.9070907@redhat.com>
Date: Mon, 17 Dec 2007 16:52:40 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>	 <20071217142235.GA21379@linux.vnet.ibm.com>	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com> <1197927385.23402.41.camel@brick>
In-Reply-To: <1197927385.23402.41.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> On Mon, 2007-12-17 at 16:28 -0500, Masami Hiramatsu wrote:
>> Hi Harvey,
>> If you mention about a relative jump which is inserted by
>> resume_execution(), I think you might misunderstand that relative jump.
>>
>> The size of that relative jump, which will be embedded by kprobe-booster, is
>> 5-bytes(not 1 byte). So it needs 5 bytes space.
>> And we decided not to expand MAX_INSN_SIZE when we developed the booster.
>> The reasons are:
>>  - it is supplemental feature(just accelerating kprobes), if we have no space,
>>    we can disable it.
>>  - 5 bytes are big enough compared with 15(=MAX_INSN_SIZE)
>>  - the lengths of most of instructions are less than 10 bytes.
>>
>> Additionally, MAX_INSN_SIZE is used in kernel/kprobes.c to allocate an
>> instruction buffer which will be assigned to p->ainsn.insn. Since the
>> instruction buffer size is MAX_INSN_SIZE, you can not copy instructions
>> more than MAX_INSN_SIZE.
>>
>> BTW, in my patch, I unified MAX_INSN_SIZE to bigger one(16).
>> I think it is enough for us.
>>
> 
> I went with 15 in mine, I thought it made the code a little more
> readable, but I will defer if you think 16 is better.  If you want me
> to send the whole series to you, let me know.

Before porting, could you tell me what differences are important
to you? We can discuss about it.

> I just sent out a series of 4 patches equivalent to your patches 1-4/6
> but based on my already unified kprobes.c/h, You may want to check your
> handling of restored registers in trampoline_probe_handler which I found
> when rebasing yours on top of my cleanups.  Not sure if this is
> important, but it was a difference I found.
> 
> X86_32:
> regs->cs = __KERNEL_CS | get_kernel_rpl();
> 
> yours:
> regs->cs = __KERNEL_CS;

Because of kretprobe's compatibility, on x86-32 cs should be set rpl().
But get_kernel_rpl() does not exist on x86-64.

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

