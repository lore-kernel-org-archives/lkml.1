Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYDQWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYDQWGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYDQWGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 18:06:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYDQWGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 18:06:02 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
References: <20080415115058.GA6788@in.ibm.com>
	<20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	<20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 17 Apr 2008 18:02:21 -0400
In-Reply-To: <1208361092.6395.81.camel@twins> (Peter Zijlstra's message of "Wed, 16 Apr 2008 17:51:32 +0200")
Message-ID: <y0m1w54cf82.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> [...]
>> If we were to log just the futex_ops, just as you had suggested,
>> "Just log:
>>  
>>   futex: <uaddr> wait
>>   futex: <uaddr> wakeup"
>> [...]
>> If you can specifically point me to information you think would be
>> absolutely unnecessary, I can get them out of the trace_mark().
>
> I'm thinking everything is superflous; you're basically logging what
> strace already gives you

But we don't want to run strace just for this stuff.  As you probably
know, strace involves invasive user-space context-switching between
the target and the tracer.

> except worse by encoding local variable names and exposing kernel
> pointers.

The pointers are probably excessive, the and the names don't really
matter.  What does matter is providing enough information for a
problem diagnosis tool & person to reconstruct what the kernel must
have been thinking when it did something noteworthy.


- FChE
