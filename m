Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZIXXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZIXXKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIXXKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 19:10:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbZIXXKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 19:10:22 -0400
Date: Thu, 24 Sep 2009 16:09:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Heffner <mikeh@fesnel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: HR timers prevent an itimer from generating EINTR?
Message-Id: <20090924160946.f54aa215.akpm@linux-foundation.org>
In-Reply-To: <4AA1860B.4030409@fesnel.com>
References: <4AA1860B.4030409@fesnel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc's added)

(it's a regression)

(it has a testcase!)

On Fri, 04 Sep 2009 17:26:35 -0400
Mike Heffner <mikeh@fesnel.com> wrote:

> Summary:
> 
> Mixing HR timers with itimers occasionally hides an EINTR from a 
> blocking syscall.
> 
> 
> Description:
> 
> In my test program I have a High Resolution timer firing every one 
> second (with SA_RESTART) and I set an itimer (without SA_RESTART) to 
> fire after three seconds. I then execute a blocking system call (flock 
> in this case) and expect the three second itimer to interrupt the system 
> call with EINTR. However, I frequently notice that the itimer will fire 
> but it will not interrupt the blocking system call. There appears to be 
> a race between the HR timer firing and the itimer firing. If I offset 
> the HR timer frequency by a half second, the itimer always interrupts 
> the system call.
> 
> Kernel version:
> 
> These kernels both demonstrate the condition:
> 
> 2.6.29.6-217.2.16.fc11.x86_64
> 	and
> 2.6.30.5-43.fc11.x86_64
> 
> 
> I do not see this condition on:
> 
> 2.6.18-53.el5
> 
> 
> Test program:
> 
> The following program illustrates this condition:
> 
> http://github.com/mheffner/scripts/commits/master/hrtimer_vs_itimer.c
> 
> 
> Is this behavior expected?
> 
> 

