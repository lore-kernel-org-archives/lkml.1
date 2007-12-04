Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbXLDStj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbXLDStj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXLDSs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:48:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56043 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbXLDSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:48:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, Natalie Protasevich <protasnb@gmail.com>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 IOAPIC: de-fang IRQ compression
References: <200711280121.18376.lenb@kernel.org>
	<20071204122649.GB27286@elte.hu>
Date: Tue, 04 Dec 2007 11:46:36 -0700
In-Reply-To: <20071204122649.GB27286@elte.hu> (Ingo Molnar's message of "Tue,
	4 Dec 2007 13:26:49 +0100")
Message-ID: <m1sl2iwb5f.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Len Brown <lenb@kernel.org> wrote:
>
>>     So while the irq compression code on i386 should really
>>     be deleted -- even before merging the x86_64 irq-overhaul,
>>     this patch simply disables it on all high volume systems
>>     to avoid problems #1 and #2 on most all i386 systems.
>>     
>>     A large system with pin numbers >=64 will still have compression
>>     to conserve limited IRQ numbers for sparse IOAPICS.  However,
>>     the vast majority of the planet, those with only pin numbers < 64
>>     will use an identity GSI -> IRQ mapping.
>>     
>>     Signed-off-by: Len Brown <len.brown@intel.com>
>
> thanks for the patch and the extensive description. I've applied this to 
> x86.git. Do you agree that this has no urgency for v2.6.24 and is thus 
> v2.6.25 material?
>
> would you be interested in doing a follow-up patch as well that just 
> yanks all of the irq compression code? That would keep things nicely 
> bisectable and testable - the second, larger patch would be a NOP in 
> theory on most systems.

With respect to a follow on patch that removes irq compression.
We must raise NR_IRQs.

I have seen systems with > 256 GSIs (in the 4k ballpark) that
people occasionally boot 32bit kernels on.

However those systems seemed to use fewer then 200 or so of those irqs.
So as long as we are allocating vectors to irqs on demand (i.e. when
we find that the irq is hooked up or later) we should be ok.

Eric
