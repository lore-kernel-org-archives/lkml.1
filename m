Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbZFWI2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbZFWI2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbZFWI1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:27:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:6444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbZFWI1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=fdo14qx6uWgpVL1gMkhtpBPovJ2lkGVxkDt/0aaj/zaz2A7Sr3w5N3EkvEUuYMqTXv
         cYeEnhAnjr3cQND5UobGzV9EmYnL6APgHbJSlLlzLlWu41JgC+Z4vkvl+7GgE8IWwioW
         slUwE+lmtiwmjH/64EKG8Nb+1NVnrTb27VPk8=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
	 <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
	 <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
Date: Tue, 23 Jun 2009 10:27:47 +0200
Message-ID: <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
Subject: Re: perf_counter Atom patch
From: stephane eranian <eranian@googlemail.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 23, 2009 at 9:59 AM, Yong Wang<yong.y.wang@linux.intel.com> wrote:
> On Tue, Jun 23, 2009 at 09:45:03AM +0200, stephane eranian wrote:
>>
>> Unfortunately, I don't have a N270 to compare with your results.
>> We need to verify whether or not N270 implements the fixed counters.
>> Does it report architected perfmon v3 or v1?
>>
>
> All Atom processors report perfmon v3 as specified in SDM. N270 is no
> exception.
>
V3 does not set a minimal number of fixed counters, could be zero. But
that seems
odd. Let me ask around.

>> > The return value of CPUID(0xa) is indeed bogus, too and there is another quirk for that in
>> > intel_pmu_init() in arch/x86/kernel/cpu/perf_counter.c
>> >
>> > x86_pmu.num_counters_fixed ?? ?? ??= max((int)edx.split.num_counters_fixed, 3);
>> >
>> > Is this what you were talking about?
>>
>> Not quite, because with the max() you'd have a problem on Intel Core
>> Duo/Solo processors
>> as they do implement the first generation of architected perfmon and
>> that one did not have
>> fixed counters. So you'd have to special case family=6 model=14.
>
> That has been taken into account actually. Only perfmon v2 and above are
> supported as you see in intel_pmu_init().
>
>        if (version < 2)
>                return -ENODEV;
>
I assume this is a current limitation of the implementation. If you
see version <  2
you could simply consider having 0 fixed counters and everything else would work
as expected. But there is a catch, unfortunately, in that there is erratum AE49
which says that there is only one enable bit to control the two generic counters
on Core Duo/Solo.
