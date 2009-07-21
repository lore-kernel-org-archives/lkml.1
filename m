Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZGUGAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZGUGAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:00:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZGUGAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:00:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56413 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZGUGAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:00:19 -0400
Message-ID: <4A65598D.7020808@cn.fujitsu.com>
Date: Tue, 21 Jul 2009 14:00:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Neil Horman <nhorman@tuxdriver.com>, Vivek Goyal <vgoyal@redhat.com>,
       Brayan Arraes <brayan@yack.com.br>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <m1d47vnoq6.fsf@fess.ebiederm.org>
In-Reply-To: <m1d47vnoq6.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Lai Jiangshan <laijs@cn.fujitsu.com> writes:
> 
>> 1) This fix breaks our tools.
>>       This fix changes the ABI. panic_on_oops is default 0,
>>    and a lots system do not specify the boot option "panic",
>>    thus, Sysrq-c will not cause CrashDump(Kdump) as expected.
> 
> How does it break your tools?

Sysrq-c is known for causing a CrashDump.
This fix make Sysrq-c just causing an oops.
An oops in process context just kills current task and
does nothing. (panic_on_oops=0)

Why we let a cleanup patch changes the kernel behavior so much?

> 
>> 2) When CONFIG_KEXEC=n, Sysrq-c should become an invalid
>>    command like Sysrq-D(CONFIG_LOCKDEP, show-all-locks).
>>    But this fix makes it a valid command and let it do a
>>    hazard thing: cause a page fault(NULL dereference) in kernel.
>>
>> So, we revert this fix.
> 
> The idea was to extend sysrq-d to also be a way of testing NULL
> pointer dereferences.  How is that a bad idea?
> 

When CONFIG_KEXEC=n, Crashdump is not available,
Sysrq-c should become an invalid command.


