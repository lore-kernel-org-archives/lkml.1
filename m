Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbXFLWhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbXFLWhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXFLWhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:37:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33044 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798AbXFLWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:37:38 -0400
Date: Wed, 13 Jun 2007 00:37:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, avi@qumranet.com,
       linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.22-rc4-mm2: kvm compile breakage with X86_CMPXCHG64=n
Message-ID: <20070612223746.GX3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070612000718.GS3588@stusta.de> <20070612032224.GA19293@redhat.com> <20070612150357.1685c622.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070612150357.1685c622.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 03:03:57PM -0700, Andrew Morton wrote:
> On Mon, 11 Jun 2007 23:22:24 -0400
> Dave Jones <davej@redhat.com> wrote:
> 
> > Add -Werror-implicit-function-declaration
> > This makes builds fail sooner if something is implicitly defined instead
> > of having to wait half an hour for it to fail at the linking stage.
> > 
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > 
> > --- linux-2.6/Makefile~	2007-06-04 16:46:24.000000000 -0400
> > +++ linux-2.6/Makefile	2007-06-04 16:46:53.000000000 -0400
> > @@ -313,7 +313,8 @@ LINUXINCLUDE    := -Iinclude \
> >  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
> >  
> >  CFLAGS          := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
> > -                   -fno-strict-aliasing -fno-common
> > +		   -fno-strict-aliasing -fno-common \
> > +		   -Werror-implicit-function-declaration
> >  AFLAGS          := -D__ASSEMBLY__
> >  
> >  # Read KERNELRELEASE from include/config/kernel.release (if it exists)
> 
> This causes the i386 allmodconfig build to fail:
> 
> include/linux/uaccess.h: In function 'pagefault_disable':
> include/linux/uaccess.h:23: error: implicit declaration of function '__memory_barrier'
> 
> I didn't look to see why...

I have -Werror-implicit-function-declaration in the CFLAGS of my 
testbuilds for ages without ever hitting this.

Perhaps some change in your working tree?
Can you verify this problem with 2.6.22-rc4-mm2?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

