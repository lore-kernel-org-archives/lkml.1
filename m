Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782Ab0AESFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0AESFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:05:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570Ab0AESFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:05:07 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40208 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab0AESFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:05:06 -0500
Message-ID: <4B437F4A.6030808@us.ibm.com>
Date: Tue, 05 Jan 2010 10:04:58 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH] futex: Fix ZERO_PAGE cause infinite loop
References: <20091224182630.3DCB.A69D9226@jp.fujitsu.com> <1261647565.4937.177.camel@laptop> <20091225083305.AA78.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091225083305.AA78.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

> I don't know any library except glibc use futex directly, or not. 
> but we don't have any reason to assume futex is used only glibc.
> (plus, glibc might change its implementation in future release, perhaps)

I only know of 3 off-hand. The checkpoint restart guys have test suites 
that use the futex syscalls. The futextest test suite obviously does. 
There is also the userspace RCU library that Mathieu Desnoyers has been 
workingon. None of these make use off the zero page as far as I know. 
However, once we sort this out, I shall have to add such a test to 
futextest, perhaps something similar to the test in this thread.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
