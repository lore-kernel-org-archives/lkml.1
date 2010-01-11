Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AKW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AKW6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083Ab0AKW6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:58:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0AKW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:58:10 -0500
Message-ID: <4B4BACCA.2040805@zytor.com>
Date: Mon, 11 Jan 2010 14:57:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, apic: use 0x20 for the IRQ_MOVE_CLEANUP_VECTOR instead
 of 0x1f
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	 <4B47E7A9.6090904@zytor.com> <1263250418.2859.681.camel@sbs-t61.sc.intel.com>
In-Reply-To: <1263250418.2859.681.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 02:53 PM, Suresh Siddha wrote:
> 
>> However, my most serious concern with this patch is that there is a
>> fairly significant change due to this patch, which is that the legacy
>> IRQ vectors now fall *inside* the FIRST_DEVICE_VECTOR range.  This isn't
>> a bad thing -- in fact, it is fundamentally the right thing to do
>> especially once we consider platforms which *don't* have the legacy IRQs
>> -- but it makes me scared of unexpected behavior changes as a result.
>> If you feel confident that that is not the case, could you outline why
>> it shouldn't be a problem?
> 
> In irqinit.c, we statically pre-assign the per-cpu vector to irq
> mappings (vector_irq) for all the legacy IRQ vectors. Similarly irq_cfg
> is statically initialized for legacy IRQ's in io_apic.c. So we won't be
> able to use this space for anything else.
> 

What enforces that, though?  The used_vector bitmap?  In the past it was
enforced simply by being < FIRST_DEVICE_VECTOR.

	-hpa

