Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYIIQnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYIIQnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYIIQnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:43:04 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:52552 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYIIQnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:43:01 -0400
Message-ID: <48C6A78A.8090401@nortel.com>
Date: Tue, 09 Sep 2008 10:42:50 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD
 extension
References: <1220278355.3866.21.camel@localhost.localdomain> <517f3f820809090845o5dc772f8r2308a6c010f69561@mail.gmail.com>
In-Reply-To: <517f3f820809090845o5dc772f8r2308a6c010f69561@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2008 16:42:54.0070 (UTC) FILETIME=[1B1A2960:01C9129B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk wrote:

> On 9/1/08, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> Since there may be programs which use the fact that
>>
>> setpriority(PRIO_PROCESS, tid, value)
>>
>> prior to this patch was setting priority for selected thread,
>> this behavior is retained in case when tid != pid.
>>
>> IOW: with PRIO_PROCESS, if pid specifies a thread group leader,
>> all threads' prios are set. Otherwise, only selected thread's priority
>> is set. (Alternative can be to just fail with ESRCH).


> I would expect
> setpriority(PRIO_PROCESS, getpid())
> and
> setpriority(PRIO_PROCESS, 0)
> to have the same affect (because: which == PRIO_PRCESS, who == 0
> conventionally means "the calling process").
> 
> But they do not: the latter call only changes the priority of the
> calling thread.  Is this intended?

The patch interprets 0 as the current pid rather than the current tgid.

It's up for discussion whether we should preserve old behaviour when 
specifying 0, or use a new and arguably more logical behaviour but 
possibly break old apps.

Chris
