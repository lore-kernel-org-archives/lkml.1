Return-Path: <linux-kernel-owner+w=401wt.eu-S1764191AbXK3C62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191AbXK3C62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763038AbXK3C6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:58:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51514 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758190AbXK3C6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:58:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ben Woodard <woodard@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, hbabu@us.ibm.com,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <m1y7cjkec2.fsf@ebiederm.dsl.xmission.com>
	<200711271445.56792.ak@suse.de>
	<m1lk8jka8j.fsf@ebiederm.dsl.xmission.com>
	<474C64CB.7080004@redhat.com>
	<20071127194220.GG14887@hmsendeavour.rdu.redhat.com>
	<20071127200011.GA3703@redhat.com>
	<20071127222408.GH24223@one.firstfloor.org>
	<474CA733.9050908@redhat.com> <20071128153649.GC3192@redhat.com>
	<20071128160206.GA21286@hmsendeavour.rdu.redhat.com>
	<20071128190525.GD3192@redhat.com>
	<m1d4tudun5.fsf@ebiederm.dsl.xmission.com>
	<474F7290.8010504@redhat.com>
Date: Thu, 29 Nov 2007 19:54:16 -0700
In-Reply-To: <474F7290.8010504@redhat.com> (Ben Woodard's message of "Thu, 29
	Nov 2007 18:16:48 -0800")
Message-ID: <m1sl2oa1ev.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Woodard <woodard@redhat.com> writes:

> Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>>
>>> Ok. Got it. So in this case we route the interrupts directly through LAPIC
>>> and put LVT0 in ExtInt mode and IOAPIC is bypassed.
>>>
>>> I am looking at Intel Multiprocessor specification v1.4 and as per figure
>>> 3-3 on page 3-9, 8259 is connected to LINTIN0 line, which in turn is
>>> connected to LINTIN0 pin on all processors. If that is the case, even in
>>> this mode, all the CPU should see the timer interrupts (which is coming
>>> from 8259)?
>>
>> However things are implemented completely differently now.  I don't think
>> the coherent hypertransport domain of AMD processors actually routes
>> ExtINT interrupts to all cpus but instead one (the default route?) is
>> picked.
>>
>> So I think for the kdump case we pretty much need to use an IOAPIC
>> in virtual wire mode for recent AMD systems.
>>
>> For current Intel systems I believe either scenario still works.
>>
>>> Can you print the LAPIC registers (print_local_APIC) during normal boot
>>> and during kdump boot and paste here?
>>
>> It's worth a look.
>>
>> I still think we need to just use apic mode at kernel startup, and
>> be done with it.
>>
>
> Neil whipped up a patch to try this and evidently it worked on his test boxes
> but it didn't work very well on our problem tests box. It hung after the kernel
> printed "Ready". i.e. on a normal boot I get:

Interesting can you please try an early_printk console.


I expect you made it a fair ways and it just didn't show up because you didn't
get as far as the normal serial port setup.

You don't have any output from your linux kernel.

Eric
