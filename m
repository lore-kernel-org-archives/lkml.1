Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376Ab0ALA2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0ALA2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308Ab0ALA2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:28:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55023 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0ALA2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:28:37 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>
	<4B4BB0B7.3000106@zytor.com>
	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>
	<4B4BBEBA.4060403@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 16:28:30 -0800
In-Reply-To: <4B4BBEBA.4060403@zytor.com> (H. Peter Anvin's message of "Mon\, 11 Jan 2010 16\:13\:46 -0800")
Message-ID: <m17hro6ua9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 01/11/2010 04:06 PM, Suresh Siddha wrote:
>>>
>>> Yes, that's what I said.  My question was to Suresh what enforces that
>>> in the case of his patch, which moves the legacy range into the middle
>>> of the device vectors.
>> 
>> It's not the used_vector bitmap. That range will appear as used on all
>> the cpu's and hence we won't be allocating it for anything else.
>> 
>
> OK, fair enough.
>
>> Now the question is: for non-legacy (io-apic) case, instead of reserving
>> this range for all the cpu's, does it make sense to generalize like any
>> other vector?
>
> It sounds like something that we could experiment with -- after
> switching an IRQ to ioapic mode, make it a movable interrupt.  It
> *seems* it should work, but it's scary stuff to muck with.
>
> Eric, do you see any reason why it wouldn't work?  I truly couldn't
> understand your previous remark, especially the bit about "it is
> dangerous to play lowest priority irq games in that range".

Sorry.  I suck at multitasking.

Without changes assign_irq_vector will reuse vectors in the range
IRQ0_VECTOR to IRQ15_VECTOR in the code as it we currently ship it,
when we switch irq0-15 into ioapic mode.

Switching the loop to cover IRQ0_VECTOR to IRQ15_VECTOR is not a
problem.  I don't think it will find anything free as we assign those
vectors on all cpus, but the data structures are fine.

I am uncomfortable with the suggestion of sharing the priority of the
IRQ_MOVE_CLEANUP_VECTOR with other interrupts.  I know if it had be
clear from the documentation that it was safe to share the irq level
with other interrupts I would not have reserved the entire interrupt
level for the IRQ_MOVE_CLEANUP_VECTOR.

Eric
