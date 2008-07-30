Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbYG3LXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbYG3LXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYG3LXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:23:04 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54902 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYG3LXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:23:03 -0400
Date: Wed, 30 Jul 2008 14:22:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: build issue #538 for v2.6.27-rc1 :undefined reference to
	`pnp_get_resource'
Message-ID: <20080730112211.GA19966@cs181140183.pp.htv.fi>
References: <200807291811.49788.toralf.foerster@gmx.de> <20080730030344.25cba78a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080730030344.25cba78a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 03:03:44AM -0700, Andrew Morton wrote:
> On Tue, 29 Jul 2008 18:11:46 +0200 Toralf F__rster <toralf.foerster@gmx.de> wrote:
> 
> > Hello,
> > 
> > the build (.config attached) failed, make ends with :
> > ...
> >   AS      arch/x86/lib/thunk_32.o
> >   CC      arch/x86/lib/usercopy_32.o
> >   AR      arch/x86/lib/lib.a
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> > WARNING: modpost: Found 13 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >   GEN     .version
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `pnp_port_start':
> > /home/tfoerste/devel/linux-2.6/include/linux/pnp.h:51: undefined reference to `pnp_get_resource'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> 
> y:/usr/src/25> grep PNP .config 
> y:/usr/src/25> grep pnp_port_start $(find . -name '*.o')
> Binary file ./drivers/built-in.o matches
> Binary file ./drivers/telephony/built-in.o matches
> Binary file ./drivers/telephony/ixj.o matches
> Binary file ./vmlinux.o matches
> 
> I assume that drivers/telephony/ixj.c needs to depend on PNP.
>...

No, it does not need this dependency.

CONFIG_OPTIMIZE_INLINING broke it, and Bjorn has already done a fix 
(it's silly to get an out-of-line pnp_port_start() function only due to 
it having two callers in one source file, but that is what gcc 4.2 does 
as "optimized inlining"...).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

