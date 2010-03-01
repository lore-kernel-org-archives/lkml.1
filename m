Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0CAV7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:59:10 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:37558 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0CAV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:59:08 -0500
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [tip:x86/irq] x86: apic: Fix mismerge, add arch_probe_nr_irqs() again
References: <20100207210250.GB8256@jenkins.home.ifup.org>
	<tip-f6a929eb62ef43cae16ba6d4e2c64b4e430fe7a4@git.kernel.org>
	<4B881097.1050505@kernel.org>
	<1267442545.11737.20718.camel@zakaz.uk.xensource.com>
	<m1d3zn7uwl.fsf@fess.ebiederm.org>
	<1267479860.2785.843.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Mar 2010 13:58:55 -0800
In-Reply-To: <1267479860.2785.843.camel@localhost.localdomain> (Ian Campbell's message of "Mon\, 01 Mar 2010 21\:44\:20 +0000")
Message-ID: <m1iq9fvh40.fsf@fess.ebiederm.org>
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

Ian Campbell <ijc@hellion.org.uk> writes:

> On Mon, 2010-03-01 at 10:34 -0800, Eric W. Biederman wrote:
>> 
>> As of 2.6.33 the limitations in DomU support are:
>> - xen_evtchn_do_upcall starts with the irq number instead of
>>   the irq_desc, and happens to unnecessarily call into arch
>>   specific code.  
>
> I saw a patch to fix this one recently, "xen: Remove unnecessary arch
> specific xen irq functions.", right?

Yes.  

You probably want to modify evtnchn_to_irq to return an irq_desc.

It is going to take a bit but our next big step for the irq methods
is to make them all take struct irq_desc pointers instead of unsigned
int irq, so we don't have to repeat the lookups.

>> - Xen has an array irq_info[NR_IRQS] one of the last static arrays
>>   sized at NR_IRQs in the entire kernel.
>
> Hopefully the same info as is in that array could (and indeed should) be
> instead stored in irq_desc->chip_data. Would you object to
> arch_init_copy_chip_data and arch_free_chip_data becoming function
> pointers within the struct irq_chip?

No objections.  Now that I see those methods it looks like they always
should have been in irq_chip.

>> If you can fix the Xen code so it isn't dragging the rest of the
>> kernel down when it comes to large numbers of irqs more power to you.
>
> If you know of other aspects of the Xen code where this is the case (or
> find them in the future) please let me know, I'll do my best to fix
> them.

Good to hear.

Right now I am being a bit of a jack in the box reviewer.  I don't have
time to work on the irq code right now but I occasionally pop out of
my box and review the code and try to keep it from descending into an
unmaintainable disaster.

Eric
