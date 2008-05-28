Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYE1POH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYE1POH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYE1PN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:13:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbYE1PNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:13:55 -0400
Message-ID: <483D76AF.8000402@redhat.com>
Date: Wed, 28 May 2008 10:13:51 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Mike Snitzer <snitzer@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: 4KSTACKS + DEBUG_STACKOVERFLOW harmful
References: <46D5F462.9010401@redhat.com> <170fa0d20805280736hfe19c3m790c435ff3949441@mail.gmail.com>
In-Reply-To: <170fa0d20805280736hfe19c3m790c435ff3949441@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer wrote:

> Hi Eric,
> 
> Did you happen to get a patch together that reduces the stack usage of
> dump_stack?

Nope... but Andi Kleen sent a patch to put the warning on the irq stack
rather than the main process stack, so it avoids the original problem
with DEBUG_STACKOVERFLOW at least.

> Also, what did you use to print your (above) indented callchain stack
> usage of dump_stack?

That was just hand-edited... :)

> I'd like to be able to audit the worst case stack usage of _all_ call
> chains that originate from a given thread. This would effectively be
> like DEBUG_STACK_USAGE except with finer grained (per call-chain)
> statistics.  One crude way of doing this is to dump_stack() whenever a
> task's call-chain is the new "winner" as the biggest stack hog.

When will you test for the new winner?

> To do this safely it would seem to me that a leaner dump_stack() is needed...

It depends, I guess; if you have 8k stacks it'd probably fit ok in
almost all cases, I think.

> Lastly, would it be reasonable to utilize systemtap to implement what
> I described above?  I'm actually looking to debug 4KSTACKS as
> unobtrusively as possible so as to not alter the underlying kernel (in
> this case it happens to be a RHEL5 kernel but this could apply to any
> kernel).

I don't actually know if systemtap can do what you want (not saying it
can't; just saying I don't know...)

-Eric
