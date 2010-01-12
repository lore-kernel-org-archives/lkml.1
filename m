Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527Ab0ALAnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab0ALAnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250Ab0ALAnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:43:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46068 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab0ALAnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:43:23 -0500
Message-ID: <4B4BC572.4070002@zytor.com>
Date: Mon, 11 Jan 2010 16:42:26 -0800
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
References: <1263002989.2879.664.camel@sbs-t61.sc.intel.com>	<4B47E7A9.6090904@zytor.com>	<1263250418.2859.681.camel@sbs-t61.sc.intel.com>	<4B4BACCA.2040805@zytor.com> <m1tyus8chc.fsf@fess.ebiederm.org>	<4B4BB0B7.3000106@zytor.com>	<1263254812.2859.890.camel@sbs-t61.sc.intel.com>	<4B4BBEBA.4060403@zytor.com> <m17hro6ua9.fsf@fess.ebiederm.org>
In-Reply-To: <m17hro6ua9.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2010 04:28 PM, Eric W. Biederman wrote:
> 
> Without changes assign_irq_vector will reuse vectors in the range
> IRQ0_VECTOR to IRQ15_VECTOR in the code as it we currently ship it,
> when we switch irq0-15 into ioapic mode.
> 
> Switching the loop to cover IRQ0_VECTOR to IRQ15_VECTOR is not a
> problem.  I don't think it will find anything free as we assign those
> vectors on all cpus, but the data structures are fine.
> 

The question there is if we can treat the resulting ioapic IRQs as
normal movable IRQs, and just let the target-moving mechanism take care
of it.  After all, there is a discrete event at which we decide that any
particular interrupt is an IOAPIC interrupt instead of XT-PIC.
Obviously, the vectors that remain XT-PIC vectors have to remain
allocated on all vectors for all time.

Another question is why we reserve the legacy IRQ 2 vector at all --
except when ACPI is present!  I don't think it could ever be tickled,
and it sort of felt as a "just in case" thing that could be removed.

	-hpa
