Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632Ab0AMTmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab0AMTmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412Ab0AMTmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:42:15 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12204 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0AMTmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:42:15 -0500
Message-ID: <4B4E2208.4030307@caviumnetworks.com>
Date: Wed, 13 Jan 2010 11:42:00 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Nicholas Miell <nmiell@comcast.net>, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory	barrier
 (v5)
References: <20100113013757.GA29314@Krystal> <1263358823.3874.10.camel@entropy> <20100113053126.GC6781@linux.vnet.ibm.com> <1263361196.3874.12.camel@entropy> <20100113143805.GC30875@Krystal> <1263406071.3874.16.camel@entropy> <20100113182442.GA20704@Krystal> <1263408098.3874.19.camel@entropy> <20100113191727.GA24742@Krystal>
In-Reply-To: <20100113191727.GA24742@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2010 19:42:04.0739 (UTC) FILETIME=[7BD35130:01CA9488]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Nicholas Miell (nmiell@comcast.net) wrote:
>> On Wed, 2010-01-13 at 13:24 -0500, Mathieu Desnoyers wrote:
>>> * Nicholas Miell (nmiell@comcast.net) wrote:
>>>
>>>> The whole point of compat and incompat flags is that it allows new
>>>> applications to run on old kernels and either work or fail as
>>>> appropriate, depending on whether the new features they're using must be
>>>> implemented or can be silently ignored.
>>> I see. Thanks for the explanation. Then the expedited flag should
>>> clearly be part of the mandatory flags.
>>>
>>> Can you point me to other system calls that are doing this ?
>>>
>>> Thanks,
>>>
>>> Mathieu
>> Not off the top of my head, but I did steal the idea from the ext2/3/4
>> disk format.
> 
> Sounds a bit over-engineered to me for system calls, but who knows if we
> eventually have to extend sys_membarrier(). This involves that, right
> now, I'd have to add a header to include/linux to define these flags.
> Also, "int expedited" is a bit clearer, but less flexible, than "int
> flags". Anyone else have comments about this ?
> 

It doesn't bother me that you have to do extra work to add the flag 
definitions to a header file. :-)

As I understand it, the proposal is to have the option to extend the ABI 
based on as yet undefined flag bits.  This doesn't seem like a bad thing.

The runtime overhead of testing a single bit vs. non-zero in the 
parameter shouldn't be an issue.

David Daney
