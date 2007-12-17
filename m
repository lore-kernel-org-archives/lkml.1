Return-Path: <linux-kernel-owner+w=401wt.eu-S936271AbXLQXUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936271AbXLQXUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762629AbXLQXUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:20:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLQXUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:20:18 -0500
Message-ID: <476702C4.8070205@redhat.com>
Date: Mon, 17 Dec 2007 18:14:12 -0500
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
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>	 <20071217142235.GA21379@linux.vnet.ibm.com>	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com>	 <1197927385.23402.41.camel@brick>  <4766EFA8.9070907@redhat.com> <1197928823.23402.108.camel@brick>
In-Reply-To: <1197928823.23402.108.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> On Mon, 2007-12-17 at 16:52 -0500, Masami Hiramatsu wrote:
>> Hi Harvey,
>> Before porting, could you tell me what differences are important
>> to you? We can discuss about it.
>>
>>> I just sent out a series of 4 patches equivalent to your patches 1-4/6
>>> but based on my already unified kprobes.c/h, You may want to check your
>>> handling of restored registers in trampoline_probe_handler which I found
>>> when rebasing yours on top of my cleanups.  Not sure if this is
>>> important, but it was a difference I found.
>>>
>>> X86_32:
>>> regs->cs = __KERNEL_CS | get_kernel_rpl();
>>>
>>> yours:
>>> regs->cs = __KERNEL_CS;
>> Because of kretprobe's compatibility, on x86-32 cs should be set rpl().
>> But get_kernel_rpl() does not exist on x86-64.
>>
> 
> I've already ported it and sent it to you.  It's not really important to
> me I just think my fine-grained patches may be of some use to see where
> the differences between X86_32/64 ended up being.  Your patches end up
> being just about entirely removal of ifdefs when rebased onto my
> patches, so it's at least a good secondary check of your patches even
> if mine don't go in.  Your patches end up being much smaller against
> my version too.

OK, I'll review that.

>
> I like my version slightly better because the remaining ifdefs (wrmsr,
> etc) and others could be done in a few more small patches that are more
> easily reviewable than your large final unification patch.

I agreed that your patches are including some goodness.
So let us merge it into one.


> 
> But, you know the code better than I....
> 
> Harvey
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

