Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbYAUQSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbYAUQSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYAUQR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:17:57 -0500
Received: from mga07.intel.com ([143.182.124.22]:29656 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755813AbYAUQR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:17:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,227,1199692800"; 
   d="scan'208";a="369636140"
Message-ID: <4794C554.4000200@linux.intel.com>
Date: Mon, 21 Jan 2008 08:16:20 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LatencyTOP infrastructure patch
References: <4790E3A6.7060807@linux.intel.com> <20080118093943.0048d0f7@laptopd505.fenrus.org> <20080121170415.125B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080121170415.125B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi
> 
>> +static void __sched
>> +account_global_scheduler_latency(struct task_struct *tsk, int usecs)
>> +{
>> +	int i;
>> +	int firstnonnull = MAXLR + 1;
>> +
>> +	if (!tsk->latency_reason.reason)
>> +		return;
>> +
>> +	/* skip kernel threads for now */
>> +	if (!tsk->mm)
>> +		return;
> 
> Why do you ignore kernel thread?
> 
> may be, some network filesystem use kernel thread for local I/O.
> What do you think it?

kernel threads (by themselves) don't tend to result in user visible latency...
at least that's my assumption so far... if you think I'm wrong... I'm open to be shown
that we should count them.
