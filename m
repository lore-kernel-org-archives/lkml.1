Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639Ab0AKXOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab0AKXOv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0AKXOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:14:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0AKXOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:14:50 -0500
Message-ID: <4B4BB0B7.3000106@zytor.com>
Date: Mon, 11 Jan 2010 15:13:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	<4B47E7A9.6090904@zytor.com>	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
In-Reply-To: <m1tyus8chc.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 03:10 PM, Eric W. Biederman wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
> 
>> On 01/11/2010 02:53 PM, Suresh Siddha wrote:
>>>
>>>> However, my most serious concern with this patch is that there is a
>>>> fairly significant change due to this patch, which is that the legacy
>>>> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
>>>> a bad thing -- in fact, it is fundamentally the right thing to do
>>>> especially once we consider platforms which *don't* have the legacy IRQs
>>>> -- but it makes me scared of unexpected behavior changes as a result.
>>>> If you feel confident that that is not the case, could you outline why
>>>> it shouldn't be a problem?
>>>
>>> In irqinit.c, we statically pre-assign the per-cpu vector to irq
>>> mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
>>> is statically initialized for legacy IRQ's in io_apic.c. So we won't be
>>> able to use this space for anything else.
>>>
>>
>> What enforces that, though?  The used_vector bitmap?  In the past it was
>> enforced simply by being < FIRST_DEVICE_VECTOR.
> 
> I believe historically it was simply that we did not loop over that set of vectors,
> in assign_irq_vector.
> 

Yes, that's what I said.  My question was to Suresh what enforces that
in the case of his patch, which moves the legacy range into the middle
of the device vectors.

	-hpa
