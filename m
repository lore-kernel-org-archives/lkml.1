Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZKDC0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZKDC0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:26:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZKDC0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:26:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:17302 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZKDC0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:26:15 -0500
X-ExtLoop1: 1
Subject: Re: [tip:x86/apic] x86: Use EOI register in io-apic on intel
 platforms
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "garyhade@us.ibm.com" <garyhade@us.ibm.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
In-Reply-To: <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
References: <20091026230001.947855317@sbs-t61.sc.intel.com>
	 <tip-b3ec0a37a7907813bb4fb85a2d94102c152470b7@git.kernel.org>
	 <alpine.LFD.2.00.0911040038460.9725@eddie.linux-mips.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 03 Nov 2009 18:24:50 -0800
Message-Id: <1257301490.2668.280.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 16:53 -0800, Maciej W. Rozycki wrote:
> On Mon, 2 Nov 2009, tip-bot for Suresh Siddha wrote:
> 
> > Commit-ID:  b3ec0a37a7907813bb4fb85a2d94102c152470b7
> > Gitweb:     http://git.kernel.org/tip/b3ec0a37a7907813bb4fb85a2d94102c152470b7
> > Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> > AuthorDate: Mon, 26 Oct 2009 14:24:35 -0800
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 2 Nov 2009 15:56:36 +0100
> > 
> > x86: Use EOI register in io-apic on intel platforms
> > 
> > IO-APIC's in intel chipsets support EOI register starting from
> > IO-APIC version 2. Use that when ever we need to clear the
> > IO-APIC RTE's RemoteIRR bit explicitly.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Acked-by: Gary Hade <garyhade@us.ibm.com>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > LKML-Reference: <20091026230001.947855317@sbs-t61.sc.intel.com>
> > [ Marked use_eio_reg as __read_mostly, fixed small details ]
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> [...]
> > +static int ioapic_supports_eoi(void)
> > +{
> > +	struct pci_dev *root;
> > +
> > +	root = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));
> > +	if (root && root->vendor == PCI_VENDOR_ID_INTEL &&
> > +	    mp_ioapics[0].apicver >= 0x2) {
> > +		use_eoi_reg = 1;
> > +		printk(KERN_INFO "IO-APIC supports EOI register\n");
> > +	} else
> > +		printk(KERN_INFO "IO-APIC doesn't support EOI\n");
> > +
> > +	return 0;
> > +}
> 
>  This is wrong -- the 82093AA I/O APIC has its version set to 0x11 and it 
> does not support the EOI register.  Similarly I/O APICs integrated into 
> the 82379AB south bridge and the 82374EB/SB EISA component.

Maciej, There might be some confusion (mostly on my side). When I looked
at ICH2 spec http://www.intel.com/assets/pdf/datasheet/290687.pdf it
says it has an EOI register and it is version 2.

All I heard internally was we have it from version 2 and it works (our
experiments on ICH4 etc worked).

But I do agree that I overlooked the version 11h of 82093AA (which is
older than ICH2).

> Overall values below 0x10 are reserved for the 82489DX

This is for local apic right?

>  -- are you sure 
> you didn't mean 0x12 or 0x20?

Let me check tomorrow and see where the confusion is.

thanks for looking at this.

