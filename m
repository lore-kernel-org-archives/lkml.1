Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbYGGPk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbYGGPk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 11:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYGGPkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 11:40:46 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:12455 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYGGPkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 11:40:45 -0400
Date: Mon, 7 Jul 2008 17:39:23 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: Re: AZFS file system proposal
Message-ID: <20080707173923.17dc6c05@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <200807011659.33413.arnd@arndb.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	<200807011659.33413.arnd@arndb.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you Arnd for your comments. I have changed my patch accordinly (I will send it in a few minutes).

> > Subject: azfs: initial submit of azfs, a non-buffered filesystem
> 
> Please make the patch subject the actual subject of your email next time,
> and put the introductory text below the Signed-off-by: lines, separated
> by a "---" line. That will make the standard tools work without extra
> effort on my side. Also, please always Cc the person you want to merge
> the patch, in this case probably me.

Done.

> All other file systems are in separate directories, so it would be better
> to rename fs/azfs.c to fs/azfs/inode.c

Done.

> > +#define AZFS_SUPERBLOCK_FLAGS		MS_NOEXEC | \
> > +					MS_SYNCHRONOUS | \
> > +					MS_DIRSYNC | \
> > +					MS_ACTIVE
> 
> Why MS_NOEXEC? What happens on a remount if the user does not specifies
> -o remount,exec?

I also don't see any reason of keeping MS_NOEXEC - have just removed it.

> > +static unsigned long
> > +azfs_block_find(struct inode *inode, enum azfs_direction direction,
> > +		unsigned long from, unsigned long *size)
> > +{
> > ...
> > +}
> 
> This overloading of the return type to mean either a pointer or an offset
> on the block device is rather confusing. Why not just return the raw block_id
> before the last += and leave that part up to the caller?

Changed.

> > +		if (copy_to_user(target, (void*) pin, size)) {
> > +			rc = -EFAULT;
> > +			goto out;
> > +		}
> 
> Question to the powerpc folks: is copy_to_user safe for an __iomem source?
> Should there be two copies (memcpy_fromio and copy_to_user) instead?

I leave this question open.

> > +	page_prot = pgprot_val(vma->vm_page_prot);
> > +	page_prot |= (_PAGE_NO_CACHE | _PAGE_RW);
> > +	page_prot &= ~_PAGE_GUARDED;
> > +	vma->vm_page_prot = __pgprot(page_prot);
> 
> The pgprot modifications rely on powerpc specific flags, but the
> file system should not really need to be powerpc only.
> 
> The flags we want are more or less the same as PAGE_AGP, because
> both are I/O mapped memory that needs to be uncached but should
> not be guarded, for performance reasons.
> 
> Maybe we can introduce a new PAGE_IOMEM here that we can use
> in all places that need something like this. In spufs we need
> the same flags for the local store mappings.
> 
> I wouldn't hold up merging the file system for this problem, but
> until it is solved, the Kconfig entry should probably have
> a "depends on PPC".

Done.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
