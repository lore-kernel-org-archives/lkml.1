Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbYDCXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbYDCXsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYDCXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:48:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57557 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYDCXsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:48:16 -0400
Message-ID: <47F56CBC.4080706@ct.jp.nec.com>
Date: Thu, 03 Apr 2008 16:48:12 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [RESEND][RFC v3 PATCH] RTTIME watchdog timer proc interface
References: <47F55D8D.3060700@ct.jp.nec.com> <20080403161106.fe260fd7.akpm@linux-foundation.org>
In-Reply-To: <20080403161106.fe260fd7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 03 Apr 2008 15:43:25 -0700
> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>
>> Introduce new proc interface for RTTIME watchdog.
>> It makes administrator able to set RTTIME watchdog to exisiting real-time
>> applications without impact. It's useful we don't want to change software
>> stack, but want to use RTTIME watchdog for that software.
> 
> Well you don't really need to change the software stack.  It's a matter of
> setting RLIMIT_RTTIME in the parent process before starting the stack up. 

I think it means all processes have the same RTTIME, I cannot change some
of them, correct?

> This is not much more work than poking at /proc/<pid>/rttime afterwards.
> 
> Although setting RLIMIT_RTTIME via fork() is much less useful than being
> able to alter it at runtime.
> 
>>  fs/proc/base.c |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> And that's rather a lot of new code just for RLIMIT_RTTIME.  And
> RLIMIT_RTTIME is not the only rlimit which has this problem - generally the
> rlimit interface is a rather nasty one.
> 
> 
> I think we should look at creating a general way of modifying and reading a
> running process's rlimits.  If we want to do that, a syscall would be the
> appropriate interface.
> 
I agreed, using /proc is easy but wrong way.
I'll look for other approach for this.


thanks,
Hiroshi Shimamoto
