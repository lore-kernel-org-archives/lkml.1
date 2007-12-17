Return-Path: <linux-kernel-owner+w=401wt.eu-S936309AbXLRAE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309AbXLRAE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760395AbXLRAES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:04:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757240AbXLRAER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:04:17 -0500
Message-ID: <47670CB7.5060303@redhat.com>
Date: Mon, 17 Dec 2007 18:56:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>	 <20071217142235.GA21379@linux.vnet.ibm.com>	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com>	 <1197927385.23402.41.camel@brick>  <4766EFA8.9070907@redhat.com>	 <1197928823.23402.108.camel@brick>  <476702C4.8070205@redhat.com> <1197934053.23402.124.camel@brick>
In-Reply-To: <1197934053.23402.124.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> On Mon, 2007-12-17 at 18:14 -0500, Masami Hiramatsu wrote:
>> Hi Harvey,
>>
>> Harvey Harrison wrote:
>>> On Mon, 2007-12-17 at 16:52 -0500, Masami Hiramatsu wrote:
>>>> Hi Harvey,
>>>> Before porting, could you tell me what differences are important
>>>> to you? We can discuss about it.
>>> I've already ported it and sent it to you.  It's not really important to
>>> me I just think my fine-grained patches may be of some use to see where
>>> the differences between X86_32/64 ended up being.  Your patches end up
>>> being just about entirely removal of ifdefs when rebased onto my
>>> patches, so it's at least a good secondary check of your patches even
>>> if mine don't go in.  Your patches end up being much smaller against
>>> my version too.
>> OK, I'll review that.
>>
>>> I like my version slightly better because the remaining ifdefs (wrmsr,
>>> etc) and others could be done in a few more small patches that are more
>>> easily reviewable than your large final unification patch.
>> I agreed that your patches are including some goodness.
>> So let us merge it into one.
>>
>>
> 
> OK, I'll take the last bits of your patches 5/6 that aren't already
> cleaned up and send out a unified patchset for you to add your
> acked/signed off by/reviewed by as appropriate.

Sure, I'll review it. It is very helpful to me.
Please Cc: or To: the parsons who are listed in this mail.
Jim, if you can review the fixes which you've suggested,
could you give him your signed-off?

> 
> These are:
> 
> -add stack_addr() macro
> -I prefer the table defintion macros in mine as it avoids the need to
> cast the pointer passed to test_bit, but if you want them
> to be u32 as in your patch, I can change it.

 please do so. we'd like to reduce ifdefs as less as possible:-)

> -wrmsr/wrmsrl - use wrmsr() for both
> -call is_IF_modifier with p->ainsn.insn in both
> -check casting of jprobe_saved_sp, I get some compile warnings currently
> with pointer comparisons to signed/unsigned types.

Could you also add below?
- fix some comments (it clarifies the meanings of the code)
- add fix_riprel(). this useful to reduce ifdefs.
- expand reenter_kprobe(). I think it treat above two blocks.
- reassignment of regs->ip in kprobe_handler can be unified
  to "regs->ip = (unsigned long)addr;"

> 
> That will eliminate nearly all of the remaining ifdefs in my version,
> let me work through this and I'll send out a set for review.
> 
> CHeers,
> 
> Harvey
> 
> 

Best Regards,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

