Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYILJub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYILJub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYILJuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:50:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbYILJuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:50:16 -0400
Date: Fri, 12 Sep 2008 11:49:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080912094955.GB14201@elte.hu>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu> <20080910115525.GA31692@elte.hu> <48C7FA91.9050302@goop.org> <86802c440809111334u6d6691c3sd83bcfddc83b1bbd@mail.gmail.com> <48C9889B.7090901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C9889B.7090901@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Yinghai Lu wrote:
> > void __iomem *__init_refok
> > acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
> > {
> >         if (phys > ULONG_MAX) {
> >                 printk(KERN_ERR PREFIX "Cannot map memory that high\n");
> >                 return NULL;
> >         }
> >         if (acpi_gbl_permanent_mmap)
> >                 /*
> >                 * ioremap checks to ensure this is in reserved space
> >                 */
> >                 return ioremap((unsigned long)phys, size);
> >         else
> >                 return __acpi_map_table((unsigned long)phys, size);
> > }
> > EXPORT_SYMBOL_GPL(acpi_os_map_memory);
> >
> > void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
> > {
> >         if (acpi_gbl_permanent_mmap) {
> >                 iounmap(virt);
> >         }
> > }
> > EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
> >
> > just let acpi_os_unmap_memory to call __acpi_unmap_table...
> >   
> 
> That was my first attempt.  Unfortunately a lot of the acpi code seems 
> pretty sloppy about unmapping its tables, and basically relies on 
> __acpi_map_table's current behaviour of removing the previous mapping 
> when creating the new mapping.

could we just emit a WARN_ON_ONCE() warning when we have to remove a 
previous mapping, so that the ACPI code can be fixed eventually?

	Ingo
