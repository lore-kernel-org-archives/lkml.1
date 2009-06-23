Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZFWJUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZFWJUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZFWJT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:19:59 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40994 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbZFWJT6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FnM0Vd+EoNCoWjQBhaw6s+fMTkfdyOdjYHyRbcdIQS7EQirDstiUMHUOohp0jNOvN0
         yoLcvUOJuPNRSKd2axPSNSbFigZXzQJlTbGBlDMgEsevp1Y96Fp3hSA+WA/8lgHJOtVb
         Xzw8SFhKPjnDSs3tKZHzHnBh+EqziZXUhk2XE=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090623085321.GC23534@ywang-moblin2.bj.intel.com>
References: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
	 <9F0C1DB20AFA954FA1DA05309350433D7B2584D1@pdsmsx503.ccr.corp.intel.com>
	 <7c86c4470906230045k578bc146wa0e09e4094d937a5@mail.gmail.com>
	 <20090623075959.GA23534@ywang-moblin2.bj.intel.com>
	 <7c86c4470906230127g4f574b61p24f109c7a94c6e39@mail.gmail.com>
	 <7c86c4470906230140p35ce043fw24e0c20651568f31@mail.gmail.com>
	 <20090623085321.GC23534@ywang-moblin2.bj.intel.com>
Date: Tue, 23 Jun 2009 11:19:59 +0200
Message-ID: <7c86c4470906230219o23e1b85u7111cc0f527ab906@mail.gmail.com>
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

On Tue, Jun 23, 2009 at 10:53 AM, Yong Wang<yong.y.wang@linux.intel.com> wrote:
> On Tue, Jun 23, 2009 at 10:40:45AM +0200, stephane eranian wrote:
>> Yong,
>>
>> On Tue, Jun 23, 2009 at 10:27 AM, stephane
>> eranian<eranian@googlemail.com> wrote:
>> > Hi,
>> >
>> > On Tue, Jun 23, 2009 at 9:59 AM, Yong Wang<yong.y.wang@linux.intel.com> wrote:
>> >> On Tue, Jun 23, 2009 at 09:45:03AM +0200, stephane eranian wrote:
>> >>>
>> >>> Unfortunately, I don't have a N270 to compare with your results.
>> >>> We need to verify whether or not N270 implements the fixed counters.
>> >>> Does it report architected perfmon v3 or v1?
>> >>>
>> >>
>> >> All Atom processors report perfmon v3 as specified in SDM. N270 is no
>> >> exception.
>> >>
>> > V3 does not set a minimal number of fixed counters, could be zero. But
>> > that seems
>> > odd. Let me ask around.
>> >
>> Second thought on this:
>>        x86_pmu.num_counters_fixed      =
>> max((int)edx.split.num_counters_fixed, 3);
>>
>>         rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
>>
>>
>> Forcing num_counter_fixed is not enough, you need to make sure they are actually
>> activated in GLOBAL_CTRL, i.e., make sure bits 32-34 are set in intel_ctrl.
>> Depending on which machine you're on, the power on value for GLOBAL_CTRL
>> changes. The correct value for it should be that ONLY generic counters are on
>> by default.
>>
>
> Oh, this might be why fixed counter do not work on my Atom box. I will
> look into it. BTW, why should ONLY generic counters be on by default?
>
Glad you asked.
I think, it's for backward compatibility with processors such as Core Duo with
architected perfmon v1 which did not have the GLOBAL_* controls.
