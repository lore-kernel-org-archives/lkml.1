Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZKLEQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZKLEQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 23:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZKLEQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 23:16:45 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33953 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbZKLEQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 23:16:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFB8C21.6080404@jp.fujitsu.com>
Date: Thu, 12 Nov 2009 13:16:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fix granularity of task_u/stime()
References: <4AF0C97F.7000603@bluehost.com> <4AF123F5.50407@jp.fujitsu.com>	 <4AF26176.4080307@jp.fujitsu.com> <1257778154.4108.341.camel@laptop>	 <4AF8FD3C.2090008@jp.fujitsu.com> <4AF8FE76.406@jp.fujitsu.com>	 <20091111121150.GA2549@dhcp-lab-161.englab.brq.redhat.com>	 <4AFB5019.7030901@jp.fujitsu.com> <4AFB77C2.8080705@jp.fujitsu.com> <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
In-Reply-To: <2375c9f90911111855w20491a1er8d3400cf4e027855@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
>>>> kernel/built-in.o: In function `task_utime':
>>>> /usr/src/rhel5/linux-2.6/kernel/sched.c:5187: undefined reference to
>>>> `__udivdi3'
>>>> kernel/built-in.o: In function `task_stime':
>>>> /usr/src/rhel5/linux-2.6/kernel/sched.c:5208: undefined reference to
>>>> `__udivdi3'
>>>> make: *** [.tmp_vmlinux1] Error 1

>> Oh, I found I can hit this error on x86_32 (but not on x86_64).
>> Maybe something on dividing u64...
>>
>> I'll try to find fix/workaround for this, but would appreciate if someone
>> could tell me what is happening here.
> 
> Yeah, this is because on 32-bit gcc tries to use libgcc to do 64-bit
> integer computing. You can insert inline asm to force gcc not to
> optimize this code. ;)

Thank you for the information.

According to the following commit which I found that is against "__udivdi3"
error, use of div_u64() will fix this problem, right?

 commit 956dba3caaf66b84fe5f6180e0e4dd03902c7980
 Author: Andy Whitcroft <apw@canonical.com>
 Date:   Wed Jul 1 15:20:59 2009 +0100

I'm now testing modified patch...


Thanks,
H.Seto

