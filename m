Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973Ab0ARQxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0ARQxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748Ab0ARQxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:53:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0ARQxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:53:02 -0500
Message-ID: <4B5491D0.20501@redhat.com>
Date: Mon, 18 Jan 2010 18:52:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: ananth@in.ibm.com
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
References: <4B5325CF.5000001@redhat.com> <1263740593.557.20967.camel@twins> <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com> <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com> <20100118154323.GA4424@in.ibm.com>
In-Reply-To: <20100118154323.GA4424@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 05:43 PM, Ananth N Mavinakayanahalli wrote:
>>
>>> Well, the alternatives are very unappealing.  Emulation and single-stepping
>>> are going to be very slow compared to a couple of jumps.
>>>        
>> So how big chunks of the address space are we talking here for uprobes?
>>      
> As Srikar mentioned, the least we start with is 1 page. Though you can
> have as many probes as you want, there are certain optimizations we can
> do, depending on the most common usecases.
>
> For eg., if you'd consider the start of a routine to be the most
> commonly traced location, most routines in a binary would generally
> start with the same instruction (say push %ebp), and we can refcount a
> slot with that instruction to be used for all probes of the same
> instruction.
>    

But then you can't follow the instruction with a jump back to the code...

-- 
error compiling committee.c: too many arguments to function

