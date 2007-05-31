Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbXEaPtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbXEaPtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXEaPtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:49:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56247 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbXEaPtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:49:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robert Hancock <hancockr@shaw.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
References: <fa.tUMR7tAB+jMgtfyl/LJ7U9QMgBs@ifi.uio.no>
	<465EDCF4.7010700@shaw.ca>
Date: Thu, 31 May 2007 09:47:22 -0600
In-Reply-To: <465EDCF4.7010700@shaw.ca> (Robert Hancock's message of "Thu, 31
	May 2007 08:34:28 -0600")
Message-ID: <m1abvl3shh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:

> Eric W. Biederman wrote:
>> I just realized that except for doing the code review and noticing
>> that the current cpu hotplug code is fundamentally incompatible
>> with x86 I haven't done anything about it.  So here is my patch
>> to document what is wrong.
>>
>> The current cpu hotplug code requires irqs to be migrated from a cpu
>> outside of irq context.  On x86 ioapics simply do not support this,
>> making the code unfixable without major redesign of the generic cpu
>> hotplug code.
>>
>> So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
>> and adds a WARN_ON so people that do enable it are not in doubt about
>> which part of the code is broken, even if it does work for them.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> I don't think this is useful, though the code may be problematic, this patch
> will break suspend on all SMP machines with an existing config, which is a major
> regression..


Cool.

My patch does not change the functionality of the code just complains
very loudly that it is broken.

Further the code is broken at a design level.  The code isn't
problematic the code is impossible.  The cpu hotplug code can not be
fixed on x86 without a redesign of the generic cpu hotplug code.

Suspend does not need to use cpu hotplug because it already gets in
deep with the drivers, and can stop interrupts at the source.  I know
there was some talk about this doing this earlier, but I don't know if
anything came of that discussion.

Regardless if you care about this being a problem feel free to fix the
relevant code so it attempts to do something that the hardware
actually supports.

But if the suspend needs this code for smp support it is also broken.

Eric
