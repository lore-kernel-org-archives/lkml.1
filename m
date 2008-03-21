Return-Path: <linux-kernel-owner+w=401wt.eu-S1765435AbYCUXTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765435AbYCUXTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbYCUXS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:18:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763077AbYCUXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:18:56 -0400
Message-ID: <47E4424B.4060802@redhat.com>
Date: Fri, 21 Mar 2008 19:18:35 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yakov Lerner <iler.ml@gmail.com>, prasanna@in.ibm.com, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in	post_hander()
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080321110804.GY20420@elte.hu>
In-Reply-To: <20080321110804.GY20420@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yakov Lerner <iler.ml@gmail.com> wrote:
> 
>> I was trying to get the address of instruction to be executed next 
>> after the kprobed instruction.  But regs->eip in post_handler() 
>> contains value which is useless to the user. It's pre-corrected value. 
>> This value is difficult to use without access to resume_execution(), 
>> which is not exported anyway. I moved the invocation of post_handler() 
>> to *after* resume_execution(). Now regs->eip contains meaningful value 
>> in post_handler().
>>
>> I do not think this change breaks any backward-compatibility. To make 
>> meaning of the old value, post_handler() would need access to 
>> resume_execution() which is not exported.  I have difficulty to 
>> believe that previous, uncorrected, regs->eip can be meaningfully used 
>> in post_handler().
> 
> thanks, i've added your patch to the .26 bucket of x86.git, but it would 
> be nice to get an Ack/Nack from a kprobes person as well.
> 
> 	Ingo

Ingo, I also tested this on x86-64/x86/ia64.

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

