Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYJ0QQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYJ0QQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0QQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:16:42 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:5776 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYJ0QQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:16:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=P3tnTFgbcu8aE6+tXb/SQ9n6N4XWef9f+imH2n3sLi7mc/Cx6KITHYlzELWZsEjUal
         Lt+qmNaQs+AHmQFgHQrHrOKLehDrsiKHpn7nEim8//w9jdXrKPejFsq9TwfCpE8dHRWq
         G5zwXx2qV3VW5a0CuqHlFRTPUsXCxHD3TMc5k=
Message-ID: <4905E961.3090400@gmail.com>
Date: Mon, 27 Oct 2008 18:16:33 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com> <1223817124-27239-3-git-send-email-edwintorok@gmail.com> <20081027160348.GT5704@elte.hu>
In-Reply-To: <20081027160348.GT5704@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-27 18:03, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> Usage example:
>> mount -t debugfs nodev /sys/kernel/debug
>> cd /sys/kernel/debug/tracing
>> echo userstacktrace >iter_ctrl
>> echo sched_switch >current_tracer
>> echo 1 >tracing_enabled
>> .... run application ...
>> echo 0 >tracing_enabled
>>
>> Then read one of 'trace','latency_trace','trace_pipe'
>>     
>
> okay, this makes quite a bit of sense - and sysprof already kind of 
> walks down into the user-space stack. (and so does oprofile, if asked)
>
> Could you send this independently of the lock contention tracing 
> patches perhaps?

Sure, and "[PATCH 2/4] Identify which executable object the userspace
address belongs to" is independent of the lock tracing part too.

Perhaps I should send these 2 patches as 3 separate patches:
- introduce save_stack_trace_user in arch/
- the ftrace parts for user stack tracing (userstacktrace >iter_ctrl)
- the sym-userobj part (which is useful if you got ASLR, otherwise you
don't have a chance to resolve the symbols later after the app is gone)

I promised the lock contention tracepoints for this weekend, I'll send
out these patches at the same time too.

Best regards,
--Edwin
