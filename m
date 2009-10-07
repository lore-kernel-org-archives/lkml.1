Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbZJGPfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbZJGPfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 11:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933900AbZJGPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 11:34:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:58709 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933878AbZJGPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 11:34:56 -0400
Date: Wed, 7 Oct 2009 17:34:15 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, devel@driverdev.osuosl.org,
       heiko.carstens@de.ibm.com, linux-s390@vger.kernel.org
Subject: Re: next-20091007 - comedi driver build breaks on S390x
Message-ID: <20091007173415.5155d995@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20091007130744.GA26081@suse.de>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
	<20091007105458.GA5472@linux.vnet.ibm.com>
	<20091007130744.GA26081@suse.de>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009 06:07:44 -0700
Greg KH <gregkh@suse.de> wrote:

> On Wed, Oct 07, 2009 at 04:24:58PM +0530, Kamalesh Babulal wrote:
> > Hi Greg,
> > 
> > 	next-20091007 randconfig build breaks on s390x with build error
> > 
> > drivers/staging/comedi/comedi_fops.c: In function 'comedi_mmap':
> > drivers/staging/comedi/comedi_fops.c:1453: error: 'PAGE_SHARED' undeclared (first use in this function)
> > drivers/staging/comedi/comedi_fops.c:1453: error: (Each undeclared identifier is reported only once
> > drivers/staging/comedi/comedi_fops.c:1453: error: for each function it appears in.)
> > make[3]: *** [drivers/staging/comedi/comedi_fops.o] Error 1
> 
> Odd.  What changed in the header files to cause this?

The problem has always been present, only now did randconfig find it.
The compile breaks because PAGE_SHARED is not defined for s390. The
equivalent define for s390 is PAGE_RW. The problem has not shown up so
far because all drivers who use the remap_pfn_range call with
PAGE_SHARED has dependencies not available on s390, e.g. CONFIG_PCI.

To fix this I see are two options: 1) add a PAGE_SHARED define to
arch/s390/include/asm/pgtable.h, 2) make comedi depend on !S390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

