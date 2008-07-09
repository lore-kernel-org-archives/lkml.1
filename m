Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYGIJOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYGIJOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 05:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYGIJNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 05:13:50 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:42200 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYGIJNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 05:13:49 -0400
Date: Wed, 9 Jul 2008 11:14:02 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: AZFS file system proposal
Message-ID: <20080709111402.5af92580@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <1215593918.8970.363.camel@pasglop>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	<200807011659.33413.arnd@arndb.de>
	<1215593918.8970.363.camel@pasglop>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 09 Jul 2008 18:58:38 +1000
schrieb Benjamin Herrenschmidt <benh@kernel.crashing.org>:

> On Tue, 2008-07-01 at 16:59 +0200, Arnd Bergmann wrote:
> > I wouldn't hold up merging the file system for this problem, but
> > until it is solved, the Kconfig entry should probably have
> > a "depends on PPC".
> 
> Better, use an ifdef for powerpc flags, and #else to pgprot_noncached.

Thank you Ben. Then, how about this?

azfs_mmap(struct file *file, struct vm_area_struct *vma)
{
...
...
...
#ifdef CONFIG_PPC
	pgprot_t page_prot;
#endif
...
...
...
#ifdef CONFIG_PPC
	page_prot = pgprot_val(vma->vm_page_prot);
	page_prot |= (_PAGE_NO_CACHE | _PAGE_RW);
	page_prot &= ~_PAGE_GUARDED;
	vma->vm_page_prot = __pgprot(page_prot);
#else
	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
#endif
...
...
...

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Research & Development GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
