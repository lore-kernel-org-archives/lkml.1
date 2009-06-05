Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbZFESpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbZFESpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbZFESpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:45:31 -0400
Received: from kroah.org ([198.145.64.141]:43855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbZFESpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:45:31 -0400
Date: Fri, 5 Jun 2009 11:26:18 -0700
From: Greg KH <greg@kroah.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
	[drivers/staging/comedi/drivers.o]
Message-ID: <20090605182618.GA11853@kroah.com>
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 01:26:25PM -0500, Subrata Modak wrote:
> >On Thu, 2009-06-04 at 22:40 +0200, Geert Uytterhoeven wrote:
> >On Thu, Jun 4, 2009 at 20:07, Greg KH <greg@kroah.com> wrote:
> > > On Thu, Jun 04, 2009 at 07:01:32PM +0530, Subrata Modak wrote:
> > >> CC [M]  drivers/staging/comedi/drivers.o
> > >> drivers/staging/comedi/drivers.c: In function ‘comedi_buf_alloc’:
> > >> drivers/staging/comedi/drivers.c:496: error: ‘PAGE_KERNEL_NOCACHE’ undeclared (first use in this function)
> > >> drivers/staging/comedi/drivers.c:496: error: (Each undeclared identifier is reported only once
> > >> drivers/staging/comedi/drivers.c:496: error: for each function it appears in.)
> > >> make[3]: *** [drivers/staging/comedi/drivers.o] Error 1
> > >> make[2]: *** [drivers/staging/comedi] Error 2
> > >> make[1]: *** [drivers/staging] Error 2
> > >> make: *** [drivers] Error 2
> > >>
> > >> Is it still normal to expect this failure ?
> > >
> > > No.
> > >
> > >> I reported them long back during April:
> > >> http://www.gossamer-threads.com/lists/linux/kernel/1065227,
> > >
> > > Yes, and I took some patches that were supposed to fix this.  I can't
> > > duplicate this here, care to send a patch that would fix it?
> 
> I tried this. But, with some catch. ‘PAGE_KERNEL_NOCACHE’ seems to be the
> choice for majority of architectures like frv, m32r, sh, x86, etc, as Geert
> mentions below. However, i believe POWERPC defines it as ‘PAGE_KERNEL_NC‘
> found at arch/powerpc/include/asm/pte-common.h.
> 
> Paul/Banjamin,
> Can you please confirm this ?
> 
> The below patch fixes the build error.

Ick, that's a mess.

> +#ifdef __powerpc64__
> +				vmap(pages, n_pages, VM_MAP,
> +				PAGE_KERNEL_NC);
> +#else
>  				vmap(pages, n_pages, VM_MAP,
>  				PAGE_KERNEL_NOCACHE);
> +#endif

Should the comedi layer just not be using PAGE_KERNEL_NOCACHE here?  I
can't believe that we need to do something like this in a driver.  What
should the proper fix for this be?

thanks,

greg k-h
