Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZBKOTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZBKOTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 09:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZBKOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 09:19:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:60588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZBKOTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:19:00 -0500
Message-ID: <4992DE21.80706@kernel.org>
Date: Wed, 11 Feb 2009 23:18:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Brian Gerst <brgerst@gmail.com>, hpa@zytor.com, jeremy@goop.org,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH x86#core/percpu] x86: fix x86_32 stack protector bugs
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-12-git-send-email-tj@kernel.org> <73c1f2160902100725w2503d693v5a3d1ae93ada75de@mail.gmail.com> <49919FA2.9050309@kernel.org> <49927EB4.3050507@kernel.org> <20090211103456.GK20518@elte.hu>
In-Reply-To: <20090211103456.GK20518@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 11 Feb 2009 14:18:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
>> Impact: fix x86_32 stack protector
>>
>> Brian Gerst found out that %gs was being initialized to stack_canary
>> instead of stack_canary - 20, which basically gave the same canary
>> value for all threads.  Fixing this also exposed the following bugs.
>>
>> * cpu_idle() didn't call boot_init_stack_canary()
>>
>> * stack canary switching in switch_to() was being done too late making
>>   the initial run of a new thread use the old stack canary value.
>>
>> Fix all of them and while at it update comment in cpu_idle() about
>> calling boot_init_stack_canary().
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Reported-by: Brian Gerst <brgerst@gmail.com>
>> ---
>>  arch/x86/include/asm/stackprotector.h |    2 +-
>>  arch/x86/include/asm/system.h         |    8 +++-----
>>  arch/x86/kernel/head_32.S             |    1 +
>>  arch/x86/kernel/process_32.c          |   10 ++++++++++
>>  arch/x86/kernel/process_64.c          |   11 +++++------
>>  5 files changed, 20 insertions(+), 12 deletions(-)
> 
> Applied to tip:core/percpu, thanks guys!
> 
> I never got around to finding his bug in practice as the latest bits of 
> tip:core/percpu are not in tip/master at the moment, due to that 64-bit
> build failure.

I was kind of waiting for your test result (whether the build issue
can be reproduced without distcc) before going ahead and building a
cross compiler.  I don't see how the cross compiler would pass the
gcc-x86_*-has-stack-protector.sh test which builds a minimalistic c
file and greps for %gs access.

Thanks.

-- 
tejun
