Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbZELPHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbZELPHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZELPG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:06:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45289 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZELPG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:06:57 -0400
Date: Tue, 12 May 2009 17:06:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/numa] x86: read apic ID in the !acpi_lapic case
Message-ID: <20090512150631.GA32067@elte.hu>
References: <49FC85A9.2070702@kernel.org> <tip-4797f6b021a3fa399942245d07a1feb30df81bb8@git.kernel.org> <20090512112205.GA12108@elte.hu> <20090512145128.GA10220@lenovo> <20090512145808.GA20587@elte.hu> <4A099013.6040708@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A099013.6040708@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> >> [Ingo Molnar - Tue, May 12, 2009 at 01:22:05PM +0200]
> >> | 
> >> | this build bug is still unfixed:
> >> | 
> >> | drivers/pci/hotplug/ibmphp_core.c:165: error: expected identifier before ‘&’ token
> >> | drivers/pci/hotplug/ibmphp_core.c:166: error: too few arguments to function ‘IO_APIC_get_PCI_irq_vector’
> >> | 
> >> | 	Ingo
> >> | 
> >>
> >> Grrr... this line looks really suspicious inideed
> >>
> >> 			for (i = 0; i < 4; i++)
> >> 				(*cur_slot)->irq[i] = IO_APIC_get_PCI_irq_vector((int) (*cur_slot)->bus,
> >> --->						(int) (*cur_slot)->device, i.
> >> 						&ioapic, &ioapic_pin,
> >> 						&triggering, &polarity);
> >>
> >> but it's _not_ 'cause of this commit, since
> >> we didn't even touch this file :) The point
> >> symbol should be changed to comma. Just a
> >> misprint I believe. Appened patch should do
> >> the trick.
> > 
> > Yinghai touched it:
> > 
> > e20c06f: x86/pci: add 4 more return parameters to IO_APIC_get_PCI_irq_vector()
> > 
> i put the fix in
> [PATCH] x86: introduce io_apic_irq_attr -v2
> <4A08ACD3.2070401@kernel.org>

which is so wrong to be put into a cleanup patch ...

anyway, i applied Cyrill's patch.

	Ingo
