Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284Ab0ARRLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0ARRLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ARRLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:11:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45014 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0ARRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:11:09 -0500
Date: Mon, 18 Jan 2010 22:40:38 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
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
Message-ID: <20100118171038.GB4424@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4B53661A.9090907@redhat.com> <1263800752.4283.19.camel@laptop> <4B543F93.3060509@redhat.com> <1263815072.4283.305.camel@laptop> <4B544D7C.2060708@redhat.com> <1263816396.4283.361.camel@laptop> <4B544F8E.1080603@redhat.com> <84144f021001180413w76a8ca2axb0b9f07ee4dea67e@mail.gmail.com> <20100118154323.GA4424@in.ibm.com> <4B5491D0.20501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5491D0.20501@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:52:32PM +0200, Avi Kivity wrote:
> On 01/18/2010 05:43 PM, Ananth N Mavinakayanahalli wrote:
>>>
>>>> Well, the alternatives are very unappealing.  Emulation and single-stepping
>>>> are going to be very slow compared to a couple of jumps.
>>>>        
>>> So how big chunks of the address space are we talking here for uprobes?
>>>      
>> As Srikar mentioned, the least we start with is 1 page. Though you can
>> have as many probes as you want, there are certain optimizations we can
>> do, depending on the most common usecases.
>>
>> For eg., if you'd consider the start of a routine to be the most
>> commonly traced location, most routines in a binary would generally
>> start with the same instruction (say push %ebp), and we can refcount a
>> slot with that instruction to be used for all probes of the same
>> instruction.
>>    
>
> But then you can't follow the instruction with a jump back to the code...

Right. This will work only for the non boosted case where single-stepping
is mandatory. I guess the tradeoff is vma space and speed.

Ananth
