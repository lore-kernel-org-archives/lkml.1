Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbZFWHvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbZFWHvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZFWHvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:51:14 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63977 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbZFWHvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=aO0Ww8WICtaXV9n8c4utJfeHzqzblffEn1frG6Vscd1kmKHDSTkZ2C1FjBSil+k+37
         JnFHMkm6wpfr/gLjqUQSrF6Y4iwB/W9Rl3IhrtqsQwggT/eJDJSuRJiVPPJl4DA3+cqn
         3JxziJAGYyoW5dl3xPzsBpG0L63L3fwTDwyrc=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
Date: Tue, 23 Jun 2009 09:45:03 +0200
Message-ID: <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
Subject: Re: perf_counter Atom patch
From: stephane eranian <eranian@googlemail.com>
To: "Wang, Yong Y" <yong.y.wang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 23, 2009 at 5:38 AM, Wang, Yong Y<yong.y.wang@intel.com> wrote:
>> From: stephane eranian [mailto:eranian@googlemail.com]
>>
>> I would like to better understand what makes you think
>> this is the case.
>>
>
> Because I observed that the output of 'perf stat -e 0:0 -e 0:1 -e 0:6 <cmd>'
> is always like below without the quirk.
>
>  Performance counter stats for '<cmd>':
>
>              0  cycles
>              0  instructions
>              0  bus-cycles
>
>> Perfmon is working on Atom and there, fixed counters work perfectly:
>> $ head -6 /proc/cpuinfo
>> processor     : 0
>> vendor_id     : GenuineIntel
>> cpu family    : 6
>> model         : 28
>> model name    : Intel(R) Atom(TM) CPU  230   @ 1.60GHz
>> stepping      : 2
>> ...
>
> My cpuinfo is below and the only difference I can see is 270 vs 230.
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 28
> model name      : Intel(R) Atom(TM) CPU N270   @ 1.60GHz
> stepping        : 2
>
Unfortunately, I don't have a N270 to compare with your results.
We need to verify whether or not N270 implements the fixed counters.
Does it report architected perfmon v3 or v1?

> The return value of CPUID(0xa) is indeed bogus, too and there is another quirk for that in
> intel_pmu_init() in arch/x86/kernel/cpu/perf_counter.c
>
> x86_pmu.num_counters_fixed      = max((int)edx.split.num_counters_fixed, 3);
>
> Is this what you were talking about?

Not quite, because with the max() you'd have a problem on Intel Core
Duo/Solo processors
as they do implement the first generation of architected perfmon and
that one did not have
fixed counters. So you'd have to special case family=6 model=14.
