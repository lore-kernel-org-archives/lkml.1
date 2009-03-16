Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbZCPW5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbZCPW5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZCPW5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:57:09 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:35015 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbZCPW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:57:08 -0400
Message-ID: <49BED93B.1090700@nortel.com>
Date: Mon, 16 Mar 2009 16:56:59 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: =?ISO-8859-1?Q?G=E1bor_Melis?= <mega@retes.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Signal delivery order
References: <200903141750.37238.mega@retes.hu> <200903152306.53031.mega@retes.hu> <20090316002833.GA17615@redhat.com> <200903160934.03700.mega@retes.hu> <20090316211316.GA6270@redhat.com>
In-Reply-To: <20090316211316.GA6270@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Mar 2009 22:57:01.0600 (UTC) FILETIME=[84886A00:01C9A68A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/16, Gábor Melis wrote:
>> In a nutshell, the context argument is wrong.
> 
> I strongly disagree. This all is correct and works as expected.
> Yes, it doesn't match your expectations/needs, but this doesn't
> mean it is wrong.

It would appear that standard may allow this, depending on interpretation.

 From SUSv3, regarding sigaction():

"...the third argument can be cast to a pointer to an object of type 
ucontext_t to refer to the receiving thread's context that was 
interrupted when the signal was delivered."

 From the "signal concepts" section, "A signal is said to be 
``delivered'' to a process when the appropriate action for the process 
and signal is taken."

Given that the SIGSEGV isn't "delivered" until it's handler runs, it 
could possibly be valid for the instruction pointer in the SIGSEGV 
handler to reference test_handler, if the system was set up in such a 
way that the context was set to test_handler() at the time the SIGSEGV 
handler was run.

However, there are quality-of-implementation issues here--being able to 
handle SIGSEGV is pretty useless if the instruction pointer being passed 
to the handler doesn't actually match the instruction that caused the 
segfault.

> I dunno. I am not sure your problem is common enough to do these
> changes, but I can't judge.

What he's trying to do isn't all that unusual.  Certainly any 
application wanting to do something smart (log the instruction pointer, 
for instance) on a segfault could run into the same problem.

Chris
