Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYKXPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYKXPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYKXPQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:16:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYKXPQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:16:22 -0500
Message-ID: <492AC522.4020202@redhat.com>
Date: Mon, 24 Nov 2008 10:15:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       contact@ksplice.com, jbarnold@ksplice.com, tabbott@ksplice.com,
       wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
References: <200811211720.26394.knikanth@suse.de> <4926C838.8080105@redhat.com> <200811241637.33329.knikanth@suse.de>
In-Reply-To: <200811241637.33329.knikanth@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan wrote:
> On Friday 21 November 2008 20:09:52 Masami Hiramatsu wrote:
>> Hi Nikanth,
>>
>> Nikanth Karthikesan wrote:
> 
>> Hmm,
>> Would you like to replace a function to another function?
>> If so, AFAIK, you can do that with kprobe and below pre_handler.
>> (see booster enabled path in setup_singlestep())
>>
>> pre_handler(...)
>> {
>> 	reset_current_kprobe();	/* this kprobe doesn't need any more */
>> 	regs->ip = new_function;	/* change IP to new function */
>> 	preempt_enable_no_resched();	/* recover preempt count */
>> 	return 1;	/* No need to setup singlestep */
>> }
>>
>>
> 
> So, am I seeing worries to enable something, which is already possible, but 
> just not documented?

Actually, you can do this with kprobes, but not documented,
because the regs->ip setup depends on arch. (above code is only for
x86/x86-64).

I think it's easier to just provide above pre_handler for each arch than
jprobe-based kreplace approach.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

