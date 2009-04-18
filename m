Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZDRGly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZDRGly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 02:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZDRGlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 02:41:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZDRGlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 02:41:45 -0400
Date: Sat, 18 Apr 2009 08:41:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Kay, Allen M" <allen.m.kay@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>
Subject: Re: [PATCH 0/5] fix bugs of x2apic/intr-remap
Message-ID: <20090418064119.GA9287@elte.hu>
References: <1239957736-6161-1-git-send-email-weidong.han@intel.com> <20090417143033.GF23493@elte.hu> <20090417144152.GA11772@elte.hu> <715D42877B251141A38726ABF5CABF2C01A6B7F4B3@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A6B7F4B3@pdsmsx503.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Han, Weidong <weidong.han@intel.com> wrote:

> Ingo Molnar wrote:
> > Note, there's a new compiler warning caused by your patches:
> > 
> >   arch/x86/kernel/apic/io_apic.c:2543: warning: 'eoi_ioapic_irq'
> > defined but not used 
> > 
> > most likely by:
> > 
> >   631dd75: x86, intr-remap: fix ack for interrupt remapping
> > 
> > 	Ingo
> 
> eoi_ioapic_irq is only used for remapped interrupt, so we should 
> define eoi_ioapic_irq and __eoi_ioapic_irq when #ifdef 
> CONFIG_INTR_REMAP.

Ok - please send a patch that fixes this.

Btw., it would be nice to reduce the number of #ifdef 
CONFIG_INTR_REMAP's in all .c files in general - or even eliminate 
them.

It might be feasible to move all the INTR_REMAP code into a separate 
.c file and only build it in the INTR_REMAP case. I have not tried 
to do that so i dont know - if the interfaces are too wide and 
unnatural to the rest of the ioapic code it might not improve the 
end result - but good layering generally does do the trick.

	Ingo
