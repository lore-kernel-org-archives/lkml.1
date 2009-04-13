Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZDMSuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZDMSuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbZDMSuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:50:32 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52529 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZDMSub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:50:31 -0400
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "Li\, Shaohua" <shaohua.li@intel.com>,
       Gary Hade <garyhade@us.ibm.com>, "mingo\@elte.hu" <mingo@elte.hu>,
       "mingo\@redhat.com" <mingo@redhat.com>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       "hpa\@zytor.com" <hpa@zytor.com>, "x86\@kernel.org" <x86@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lcm\@us.ibm.com" <lcm@us.ibm.com>
References: <20090408210735.GD11159@us.ibm.com>
	<m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
	<m1tz4wcgm8.fsf@fess.ebiederm.org>
	<86802c440904110051p3e071f8etd0792702c08d9ec5@mail.gmail.com>
	<m1myanbgiv.fsf@fess.ebiederm.org>
	<1239644495.4529.8580.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 13 Apr 2009 11:50:20 -0700
In-Reply-To: <1239644495.4529.8580.camel@localhost.localdomain> (Venkatesh Pallipadi's message of "Mon\, 13 Apr 2009 10\:41\:35 -0700")
Message-ID: <m1ab6kfkwj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: venkatesh.pallipadi@intel.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, garyhade@us.ibm.com, shaohua.li@intel.com, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered inactive device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> writes:

> On Sat, 2009-04-11 at 04:01 -0700, Eric W. Biederman wrote:
>> Yinghai Lu <yhlu.kernel@gmail.com> writes:
>> 
>> > commit 932775a4ab622e3c99bd59f14cc7d96722f79501
>> > Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>> > Date:   Fri Sep 5 18:02:15 2008 -0700
>> >
>> >     x86: HPET_MSI change IRQ affinity in process context when it is disabled
>> >
>> >     Change the IRQ affinity in the process context when the IRQ is disabled.
>> >
>> >     Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> >     Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> >
>> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
>> > index ddc9568..ad2ce72 100644
>> > --- a/kernel/irq/manage.c
>> > +++ b/kernel/irq/manage.c
>> > @@ -87,10 +87,11 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
>> >                 return -EINVAL;
>> >
>> >  #ifdef CONFIG_GENERIC_PENDING_IRQ
>> > -       if (desc->status & IRQ_MOVE_PCNTXT) {
>> > +       if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
>> >                 unsigned long flags;
>> >
>> >                 spin_lock_irqsave(&desc->lock, flags);
>> > +               desc->affinity = cpumask;
>> >                 desc->chip->set_affinity(irq, cpumask);
>> >                 spin_unlock_irqrestore(&desc->lock, flags);
>> >         } else
>> 
>> If the goal is moving MSIs, we should modify the msi code to be safe
>> in process context and to set IRQ_MOVE_PCNTXT.
>> 
>> The only reason we migrate MSIs in interrupt context today is that there
>> wasn't infrastructure for support migration both in interrupt context
>> and outside of it.
>> 
>
> Yes. The idea here was to force the MSI migration to happen in process
> context. One of the patches in the series did
>
> 	disable_irq(dev->irq);
> 	irq_set_affinity(dev->irq, cpumask_of(dev->cpu));
> 	enable_irq(dev->irq);
>
> with the above patch adding irq/manage code check for interrupt disabled
> and moving the interrupt in process context.
>
> IIRC, there was no IRQ_MOVE_PCNTXT when we were developing this HPET
> code and we ended up having this ugly hack. IRQ_MOVE_PCNTXT was there
> when we eventually submitted the patch upstream. But, looks like I did a
> blind rebasing instead of using IRQ_MOVE_PCNTXT in hpet MSI code. That
> was my fault. Will send a patch to fix this ugliness.

Thanks.

Eric
