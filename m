Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbZFWJQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbZFWJQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZFWJQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:16:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:28253 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZFWJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:16:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="701709111"
Date: Tue, 23 Jun 2009 17:15:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090623171525.79be96c5@feng-desktop>
In-Reply-To: <20090623090347.GA21616@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
	<20090623075643.GC6397@elte.hu>
	<20090623163246.1cdf755e@feng-desktop>
	<20090623090347.GA21616@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 17:03:47 +0800
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Feng Tang <feng.tang@intel.com> wrote:
> 
> > On Tue, 23 Jun 2009 15:56:43 +0800
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > 
> > > >
> > > > +#ifdef CONFIG_X86_LOCAL_APIC
> > > > +static u64 sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> > > > +#endif
> > > 
> > > if SFI adds a 'depends on X86_LOCAL_APIC' the ugly #ifdef can be
> > > dropped.
> > 
> > When Len designed the SFI spec, he considered the possibility of 
> > being used by multiple archs, so we chose not to add a x86 
> > dependency, though adding these
> > #ifdef does make code ugly :P
> 
> But the file i commented on is arch/x86/kernel/sfi.c, not 
> drivers/sfi/.

Now got your point, then we can think about adding a SFI_X86 Kconfig 
option specifically for x86 platform, which has dependency over the
LAPIC/IO_APIC

Thanks,
Feng

> 
> Those #ifdefs arent _that_ bad (and are used elsewhere in x86 code 
> too) - but generally some effort should be spent in new code on 
> trying to eliminate them.
> 
> > > In general, nice stuff - basically SFI is cleanly implemented 
> > > ACPI tables without any of the run-code-in-acpi-tables 
> > > complications, right?
> > 
> > Thanks for the comments, I really got inspired :). The expectation 
> > for SFI is to be able to run cleanly with CONFIG_ACPI=n, and it 
> > works fine on some intel platform.
> 
> Ok, cool!
> 
> 	Ingo
