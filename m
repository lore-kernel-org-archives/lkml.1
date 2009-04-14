Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbZDNBkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbZDNBkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZDNBk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:40:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43463 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbZDNBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:40:25 -0400
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Li\, Shaohua" <shaohua.li@intel.com>,
       Gary Hade <garyhade@us.ibm.com>, "mingo\@elte.hu" <mingo@elte.hu>,
       "mingo\@redhat.com" <mingo@redhat.com>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       "hpa\@zytor.com" <hpa@zytor.com>, "x86\@kernel.org" <x86@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lcm\@us.ibm.com" <lcm@us.ibm.com>, suresh.b.siddha@intel.com
References: <20090408210735.GD11159@us.ibm.com>
	<m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
	<m1tz4wcgm8.fsf@fess.ebiederm.org>
	<86802c440904110051p3e071f8etd0792702c08d9ec5@mail.gmail.com>
	<m1myanbgiv.fsf@fess.ebiederm.org>
	<1239644495.4529.8580.camel@localhost.localdomain>
	<m1ab6kfkwj.fsf@fess.ebiederm.org>
	<20090413222058.GB8211@linux-os.sc.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Apr 2009 18:40:16 -0700
In-Reply-To: <20090413222058.GB8211@linux-os.sc.intel.com> (Venkatesh Pallipadi's message of "Mon\, 13 Apr 2009 15\:20\:58 -0700")
Message-ID: <m18wm46min.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, garyhade@us.ibm.com, shaohua.li@intel.com, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;"Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: marc.info]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] irq, x86: Remove IRQ_DISABLED check in process context IRQ move
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> writes:

> As discussed in the thread here
> http://marc.info/?l=linux-kernel&m=123964468521142&w=2
>
> On Fri, Apr 10, 2009 at 3:02 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> It looks like some additional bugs have slipped in since last I looked.
>>
>> set_irq_affinity does this:
>> ifdef CONFIG_GENERIC_PENDING_IRQ
>>        if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
>>                cpumask_copy(desc->affinity, cpumask);
>>                desc->chip->set_affinity(irq, cpumask);
>>        } else {
>>                desc->status |= IRQ_MOVE_PENDING;
>>                cpumask_copy(desc->pending_mask, cpumask);
>>        }
>> #else
>>
>> That IRQ_DISABLED case is a software state and as such it has nothing to
>> do with how safe it is to move an irq in process context.
>>
>
> "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> writes:
>> On Sat, 2009-04-11 at 04:01 -0700, Eric W. Biederman wrote:
>> >
>> > If the goal is moving MSIs, we should modify the msi code to be safe
>> > in process context and to set IRQ_MOVE_PCNTXT.
>> >
>> > The only reason we migrate MSIs in interrupt context today is that there
>> > wasn't infrastructure for support migration both in interrupt context
>> > and outside of it.
>>
>> Yes. The idea here was to force the MSI migration to happen in process
>> context. One of the patches in the series did
>>
>>         disable_irq(dev->irq);
>>         irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
>>         enable_irq(dev->irq);
>>
>> with the above patch adding irq/manage code check for interrupt disabled
>> and moving the interrupt in process context.
>>
>> IIRC, there was no IRQ_MOVE_PCNTXT when we were developing this HPET
>> code and we ended up having this ugly hack. IRQ_MOVE_PCNTXT was there
>> when we eventually submitted the patch upstream. But, looks like I did a
>> blind rebasing instead of using IRQ_MOVE_PCNTXT in hpet MSI code. That
>> was my fault. Will send a patch to fix this ugliness.
>
> Below patch fixes this. i.e., revert
> commit 932775a4ab622e3c99bd59f14cc7d96722f79501
> and add PCNTXT to HPET MSI setup. Also removes copying of desc->affinity
> in generic code as set_affinity routines are doing it internally.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

This looks good.

Do you think you could take this one step farther, place a read
after the hpet_msi_write to flush the write to the interrupt source, 
and then finish up the work to change the irq reception setup?

Roughly like ir_set_msi_irq_affinity?

That way we really do get everything done in process context.

> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 ++
>  kernel/irq/manage.c            |    5 ++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 767fe7e..aaf8212 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3667,12 +3667,14 @@ int arch_setup_hpet_msi(unsigned int irq)
>  {
>  	int ret;
>  	struct msi_msg msg;
> +	struct irq_desc *desc = irq_to_desc(irq);
>  
>  	ret = msi_compose_msg(NULL, irq, &msg);
>  	if (ret < 0)
>  		return ret;
>  
>  	hpet_msi_write(irq, &msg);
> +	desc->status |= IRQ_MOVE_PCNTXT;
>  	set_irq_chip_and_handler_name(irq, &hpet_msi_type, handle_edge_irq,
>  		"edge");
>  
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 7e2e7dd..2734eca 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -109,10 +109,9 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
>  	spin_lock_irqsave(&desc->lock, flags);
>  
>  #ifdef CONFIG_GENERIC_PENDING_IRQ
> -	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
> -		cpumask_copy(desc->affinity, cpumask);
> +	if (desc->status & IRQ_MOVE_PCNTXT)
>  		desc->chip->set_affinity(irq, cpumask);
> -	} else {
> +	else {
>  		desc->status |= IRQ_MOVE_PENDING;
>  		cpumask_copy(desc->pending_mask, cpumask);
>  	}
> -- 
> 1.6.0.6
