Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbZFWIeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbZFWIeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFWIeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:34:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:64766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbZFWIeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:34:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="468746992"
Date: Tue, 23 Jun 2009 16:32:46 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 3/8] SFI: core support
Message-ID: <20090623163246.1cdf755e@feng-desktop>
In-Reply-To: <20090623075643.GC6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<8d9bab79ce1169afd419035f70177e52d47626ca.1245740912.git.len.brown@intel.com>
	<20090623075643.GC6397@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 15:56:43 +0800
Ingo Molnar <mingo@elte.hu> wrote:


> >
> > +#ifdef CONFIG_X86_LOCAL_APIC
> > +static u64 sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
> > +#endif
> 
> if SFI adds a 'depends on X86_LOCAL_APIC' the ugly #ifdef can be
> dropped.

When Len designed the SFI spec, he considered the possibility of being used by
multiple archs, so we chose not to add a x86 dependency, though adding these
#ifdef does make code ugly :P

> > +{
> > +     unsigned long i;
> 
> ... like here.
> 
> > +     char *pchar = (char *)SFI_SYST_SEARCH_BEGIN;
> > +
> > +     for (i = 0; SFI_SYST_SEARCH_BEGIN + i < SFI_SYST_SEARCH_END;
> > i += 16, pchar += 16) {
> 
> What does the magic constant '16' mean here?

My bad not puting clear comments here, the SFI spec defines SYST table starts
at a 16-byte boundary


> > +
> > +static int __init sfi_parse_apic(struct sfi_table_header *table)
> > +{
> > +     struct sfi_table_simple *sb;
> > +     struct sfi_apic_table_entry *pentry;
> > +     int i, num;
> > +
> > +     BUG_ON(!table);
> 
> Same as comment above - is this case anticipated? If yes, is a crash
> the best answer?

Yes, usually table won't be NULL

> > +
> > +#define SFI_ACPI_TABLE       1
> 
> In general, nice stuff - basically SFI is cleanly implemented ACPI
> tables without any of the run-code-in-acpi-tables complications,
> right?

Thanks for the comments, I really got inspired :). The expectation for SFI
is to be able to run cleanly with CONFIG_ACPI=n, and it works fine on some
intel platform.

Thanks,
Feng

> 
>         Ingo
