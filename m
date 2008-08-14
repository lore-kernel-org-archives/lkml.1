Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYHNXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYHNXln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYHNXld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:41:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbYHNXlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:41:32 -0400
Message-ID: <48A4C25E.2060405@redhat.com>
Date: Thu, 14 Aug 2008 19:40:14 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH v2 3/6] ftrace: enable mcount recording for modules
References: <20080814194506.233473381@goodmis.org> <20080814194859.811269740@goodmis.org> <200808150926.08200.rusty@rustcorp.com.au>
In-Reply-To: <200808150926.08200.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Friday 15 August 2008 05:45:09 Steven Rostedt wrote:
>   
>> This patch enables the loading of the __mcount_section of modules and
>> changing all the callers of mcount into nops.
>>     
> ...
>   
>> +	if (mcountindex) {
>> +		void *mseg = (void *)sechdrs[mcountindex].sh_addr;
>> +		ftrace_init_module(mseg, mseg + sechdrs[mcountindex].sh_size);
>>     
>
> You don't actually need the if.  The size of section 0 is 0.
>   

Thanks,

But I find the if is a bit more clear. It may confuse code reviewers if 
we expect them to know that sechdrs[0].sh_size is zero. This isn't a hot 
path.

-- Steve


