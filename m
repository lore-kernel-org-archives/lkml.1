Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189Ab0AKXKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0AKXKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978Ab0AKXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:10:13 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38275 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0AKXKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:10:12 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>
	<4B47E7A9.6090904@zytor.com>
	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>
	<4B4BACCA.2040805@zytor.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 11 Jan 2010 15:10:07 -0800
In-Reply-To: <4B4BACCA.2040805@zytor.com> (H. Peter Anvin's message of "Mon\, 11 Jan 2010 14\:57\:14 -0800")
Message-ID: <m1tyus8chc.fsf@fess.ebiederm.org>
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

> On 01/11/2010 02:53 PM, Suresh Siddha wrote:
>> 
>>> However, my most serious concern with this patch is that there is a
>>> fairly significant change due to this patch, which is that the legacy
>>> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
>>> a bad thing -- in fact, it is fundamentally the right thing to do
>>> especially once we consider platforms which *don't* have the legacy IRQs
>>> -- but it makes me scared of unexpected behavior changes as a result.
>>> If you feel confident that that is not the case, could you outline why
>>> it shouldn't be a problem?
>> 
>> In irqinit.c, we statically pre-assign the per-cpu vector to irq
>> mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
>> is statically initialized for legacy IRQ's in io_apic.c. So we won't be
>> able to use this space for anything else.
>> 
>
> What enforces that, though?  The used_vector bitmap?  In the past it was
> enforced simply by being < FIRST_DEVICE_VECTOR.

I believe historically it was simply that we did not loop over that set of vectors,
in assign_irq_vector.

Eric
