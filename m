Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZESNxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZESNxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZESNxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:53:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56216 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZESNxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:53:43 -0400
Message-ID: <4A12B97C.9040706@redhat.com>
Date: Tue, 19 May 2009 15:51:56 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org> <20090519095918.GA11790@elte.hu> <4A12A46A02000078000017E1@vpn.id2.novell.com> <20090519110837.GA10548@elte.hu> <4A12A05C.6050004@redhat.com> <20090519122623.GD14305@elte.hu> <4A12B244.8070301@redhat.com> <20090519133138.GA8410@elte.hu>
In-Reply-To: <20090519133138.GA8410@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/09 15:31, Ingo Molnar wrote:
> * Gerd Hoffmann<kraxel@redhat.com>  wrote:
>
>> On 05/19/09 14:26, Ingo Molnar wrote:
>>> * Gerd Hoffmann<kraxel@redhat.com>   wrote:
>>>
>>>> On 05/19/09 13:08, Ingo Molnar wrote:
>>>>> Or, alternatively, the hypervisor can expose its own administrative
>>>>> interface to manage MTRRs.
>>>> Guess what?  Xen does exactly that.  And the xen mtrr_ops
>>>> implementation uses that interface ...
>>> No, that is not an 'administrative interface' - that is a guest
>>> kernel level hack that complicates Linux, extends its effective ABI
>>> dependencies and which has to be maintained there from that point
>>> on.
>>>
>>> There's really just three proper technical solutions here:
>>>
>>> - either catch the lowlevel CPU hw ops (the MSR modifications, which
>>>     isnt really all that different from the mtrr_ops approach so it
>>>     shouldnt pose undue difficulties to the Xen hypervisor).
>> Devil is in the details.
>>
>> The dom0 kernel might not see all physical cpus on the system.  So
>> Xen can't leave the job of looping over all cpus to the dom0
>> kernel, Xen has to apply the changes made by the (priviledged)
>> guest kernel on any (virtual) cpu to all (physical) cpus in the
>> machine.
>
> Applying MTRR changes to only part of the CPUs is utter madness.

Sure.  Do you read what I'm writing?

>> Which in turn means the "lowlevel cpu hw op" would work in a
>> slightly different way on Xen and native.  Nasty.
>>
>>>     That will
>>>     be maximally transparent and compatible, with zero changes needed
>>>     to the Linux kernel.
>> No, the linux kernel probably should do the wrmsr on one cpu only then.
>
> Why?

See above.  Xen has to apply the changes to all cpus anyway.

>> Oops, the third "proper technical solutions" is missing.
>
> Yeah, the third one is to not touch MTRRs after bootup and use PAT.

Works only in case the CPU has PAT support.

cheers,
   Gerd

