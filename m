Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbZESOSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbZESOSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZESOSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:18:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50043 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZESOSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:18:00 -0400
Date: Tue, 19 May 2009 16:17:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
Message-ID: <20090519141708.GA6008@elte.hu>
References: <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <4A12B244.8070301@redhat.com> <20090519133138.GA8410@elte.hu> <4A12B97C.9040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A12B97C.9040706@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gerd Hoffmann <kraxel@redhat.com> wrote:

> On 05/19/09 15:31, Ingo Molnar wrote:
>> * Gerd Hoffmann<kraxel@redhat.com>  wrote:
>>
>>> On 05/19/09 14:26, Ingo Molnar wrote:
>>>> * Gerd Hoffmann<kraxel@redhat.com>   wrote:
>>>>
>>>>> On 05/19/09 13:08, Ingo Molnar wrote:
>>>>>> Or, alternatively, the hypervisor can expose its own administrative
>>>>>> interface to manage MTRRs.
>>>>> Guess what?  Xen does exactly that.  And the xen mtrr_ops
>>>>> implementation uses that interface ...
>>>> No, that is not an 'administrative interface' - that is a guest
>>>> kernel level hack that complicates Linux, extends its effective ABI
>>>> dependencies and which has to be maintained there from that point
>>>> on.
>>>>
>>>> There's really just three proper technical solutions here:
>>>>
>>>> - either catch the lowlevel CPU hw ops (the MSR modifications, which
>>>>     isnt really all that different from the mtrr_ops approach so it
>>>>     shouldnt pose undue difficulties to the Xen hypervisor).
>>> Devil is in the details.
>>>
>>> The dom0 kernel might not see all physical cpus on the system.  So
>>> Xen can't leave the job of looping over all cpus to the dom0
>>> kernel, Xen has to apply the changes made by the (priviledged)
>>> guest kernel on any (virtual) cpu to all (physical) cpus in the
>>> machine.
>>
>> Applying MTRR changes to only part of the CPUs is utter madness.
>
> Sure.  Do you read what I'm writing?
>
>>> Which in turn means the "lowlevel cpu hw op" would work in a
>>> slightly different way on Xen and native.  Nasty.
>>>
>>>>     That will
>>>>     be maximally transparent and compatible, with zero changes needed
>>>>     to the Linux kernel.
>>> No, the linux kernel probably should do the wrmsr on one cpu only then.
>>
>> Why?
>
> See above.  Xen has to apply the changes to all cpus anyway.

do _you_ read what i wrote, in the thread you are replying to:

|
| The change of MTRR's on _any_ of the guest CPUs in a dom0 context 
| should immediately be refected on all CPUs. Assymetric MTRR 
| settings are madness.
|


>>> Oops, the third "proper technical solutions" is missing.
>>
>> Yeah, the third one is to not touch MTRRs after bootup and use PAT.
>
> Works only in case the CPU has PAT support.

Which specific CPU without PAT support do you worry about?

	Ingo
