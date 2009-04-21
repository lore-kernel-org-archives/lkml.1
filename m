Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZDUHCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZDUHCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZDUHCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:02:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55763 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZDUHCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:02:00 -0400
Date: Tue, 21 Apr 2009 09:01:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [patch 4/5] x2apic, IR: remove reinit_intr_remapped_IO_APIC()
Message-ID: <20090421070130.GC22937@elte.hu>
References: <20090420200450.128993000@linux-os.sc.intel.com> <20090420200450.552359000@linux-os.sc.intel.com> <715D42877B251141A38726ABF5CABF2C01A6B7F9FC@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715D42877B251141A38726ABF5CABF2C01A6B7F9FC@pdsmsx503.ccr.corp.intel.com>
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

> Siddha, Suresh B wrote:
> > When interrupt-remapping is enabled, We are relying on
> > setup_IO_APIC_irqs() 
> > to configure remapped entries in the IO-APIC, which comes little bit
> > later after enabling interrupt-remapping.
> > 
> > Meanwhile, Restore of old io-apic entries after enabling
> > interrupt-remapping will not make the interrupts through io-apic
> > functional anyway. 
> > 
> > So remove unnecessary reinit_intr_remapped_IO_APIC().
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Weidong Han <weidong.han@intel.com>
> > ---
> > 
> > Index: tip/arch/x86/include/asm/io_apic.h
> > ===================================================================
> > --- tip.orig/arch/x86/include/asm/io_apic.h
> > +++ tip/arch/x86/include/asm/io_apic.h
> > @@ -166,8 +166,6 @@ extern void free_ioapic_entries(struct I
> >  extern int save_IO_APIC_setup(struct IO_APIC_route_entry
> >  **ioapic_entries); extern void mask_IO_APIC_setup(struct
> >  IO_APIC_route_entry **ioapic_entries); extern int
> > restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries); 
> > -extern void reinit_intr_remapped_IO_APIC(int intr_remapping,
> > -	struct IO_APIC_route_entry **ioapic_entries);
> > 
> >  extern void probe_nr_irqs_gsi(void);
> > 
> > Index: tip/arch/x86/kernel/apic/apic.c
> > ===================================================================
> > --- tip.orig/arch/x86/kernel/apic/apic.c
> > +++ tip/arch/x86/kernel/apic/apic.c
> > @@ -1416,8 +1416,6 @@ end_restore:
> >  		 * IR enabling failed
> >  		 */
> >  		restore_IO_APIC_setup(ioapic_entries);
> > -	else
> > -		reinit_intr_remapped_IO_APIC(x2apic_preenabled, ioapic_entries);
> 
> Whether IR enabling succeeds or fails, it always needs to restore 
> old IOAPIC entries. Due to removing reinit_intr_remapped_IO_APIC 
> here, it needs to also remove the "if (ret)" before 
> restore_IO_APIC_setup(ioapic_entries);

Ok - i skipped this patch for now.

	Ingo
