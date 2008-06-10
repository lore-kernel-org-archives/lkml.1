Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYFJItd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYFJItd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYFJItW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:49:22 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:63206 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbYFJItU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:49:20 -0400
Date: Tue, 10 Jun 2008 10:49:19 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <20080609125530.GF30405@parisc-linux.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<20080609125530.GF30405@parisc-linux.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 06:55:30 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Jun 09, 2008 at 10:46:50AM +0200, Maxim Shchetynin wrote:
> > +config AZ_FS
> > +	tristate "AZFS filesystem support"
> > +	help
> > +	  Non-buffered filesystem for block devices with a gendisk and
> > +	  with direct_access() method in gendisk->fops.
> > +	  AZFS does not buffer outgoing traffic and is doing no read ahead.
> > +	  It supports mount options (given with -o) bs=x,uid=x,gid=x.
> > +	  If block-size (bs) is not specified AZFS uses block-size used
> > +	  by block device. Though mmap() method is available only if
> > +	  block-size equals to or is greater than system page size.
> 
> This is a terrible description.  I can't even suggest better wording
> because I don't understand it.  The correct wording would not mention
> gendisks, fops or direct_access().  It would tell the user what they
> might use it for.
> 

What do you think about the following - shorter description and a better place for it (moved to "Pseudo filesystems"):

--- linux-2.6.26-rc5/fs/Kconfig 2008-06-05 05:10:44.000000000 +0200
+++ linux-2.6.26-rc5-azfs/fs/Kconfig    2008-06-10 10:43:24.326686538 +0200
@@ -1017,6 +1017,19 @@
 config HUGETLB_PAGE
        def_bool HUGETLBFS

+config AZ_FS
+       tristate "AZFS filesystem support"
+       help
+         azfs is a file system for I/O attached memory backing. It requires
+         a block device with direct_access capability, e.g. axonram.
+         Mounting such device with azfs gives memory mapped access to the
+         underlying memory to user space.
+
+         To compile this file system support as a module, choose M here: the
+         module will be called azfs.
+
+         If unsure, say N.
+
 config CONFIGFS_FS
        tristate "Userspace-driven configuration filesystem"
        depends on SYSFS

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
