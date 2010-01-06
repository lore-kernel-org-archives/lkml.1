Return-Path: <linux-kernel-owner+w=401wt.eu-S932506Ab0AFXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab0AFXPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932418Ab0AFXO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:14:59 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54147 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0AFXO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:14:59 -0500
Message-ID: <4B45196E.5040005@us.ibm.com>
Date: Wed, 06 Jan 2010 15:14:54 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>,
       "Hansen, Dave" <haveblue@us.ibm.com>
Subject: Re: [PATCH v2] futex: remove rw parameter from get_futex_key()
References: <alpine.LSU.2.00.1001051108150.26884@sister.anvils> <4B43A3FB.9050009@us.ibm.com> <20100106111830.9E34.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100106111830.9E34.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Hugh Dickins wrote:
>>> On Tue, 5 Jan 2010, KOSAKI Motohiro wrote:
>>>> From c3e2dfdff84b9b720e646fd6dd3c38fff293c7e6 Mon Sep 17 00:00:00 2001
>>>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>> Date: Tue, 5 Jan 2010 11:33:00 +0900
>>>> Subject: [PATCH] futex: remove rw parameter from get_futex_key()
>>>>
>>>> Currently, futex have two problem.
>>>>
>>>> A) current futex doesn't handle private file mappings properly.
>>>>
>>>> get_futex_key() use PageAnon() to distinguish file and anon. it can
>>>> makes following bad scenario.
>>>>
>>>>   1) thread-A call futex(private-mapping, FUTEX_WAIT). it makes to
>>>>      sleep on file mapping object.
>>>>   2) thread-B write a variable and it makes cow.
>>>>   3) thread-B call futex(private-mapping, FUTEX_WAKE). it wake up
>>>>      sleeped thread on the anonymous page. (but it's nothing)
>>>>
>> Excellent test case, thank you! Would you consider preparing a patch to 
>> futextest?
>>
>> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary
> 
> Patch attached. you can feel free any modify such file. thanks.

Kosaki,

Thank you for the patch! I've merged your patch into futextest and added 
some logic to detect failure and not hang the box (so the test can be 
run unattended).

Thanks,

--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
