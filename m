Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXIJMUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXIJMUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXIJMUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:20:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36405 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756952AbXIJMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:20:33 -0400
Date: Mon, 10 Sep 2007 14:20:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dan Aloni <da-x@monatomic.org>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/kexec.c: make code static
Message-ID: <20070910122040.GE3563@stusta.de>
References: <20070909202516.GQ3563@stusta.de> <20070910115549oomichi@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070910115549oomichi@mail.jp.nec.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 11:55:49AM +0900, Ken'ichi Ohmichi wrote:
> 
> Hi Adrian,
> 
> 
> 2007/09/09 22:25:16 +0200, Adrian Bunk <bunk@kernel.org> wrote:
> >On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >>...
> >> Changes since 2.6.23-rc3-mm1:
> >>...
> >> +add-vmcoreinfo.patch
> >>...
> >>  misc
> >>...
> >
> >This patch makes the following needlessly global code static:
> >- vmcoreinfo_data[]
> >- vmcoreinfo_size
> >- vmcoreinfo_append_str()
> 
> The kernel compiling fails with your patch because architecture-specific
> function should access the above data/function:
> 
> # make
> [snip]
> arch/ia64/kernel/machine_kexec.c: In function 'arch_crash_save_vmcoreinfo':
> arch/ia64/kernel/machine_kexec.c:134: error: implicit declaration of function 'SYMBOL'
> arch/ia64/kernel/machine_kexec.c:135: error: implicit declaration of function 'LENGTH'
> arch/ia64/kernel/machine_kexec.c:139: error: implicit declaration of function 'SIZE'
> arch/ia64/kernel/machine_kexec.c:139: error: 'node_memblk_s' undeclared (first use in this function)
> arch/ia64/kernel/machine_kexec.c:139: error: (Each undeclared identifier is reported only once
> arch/ia64/kernel/machine_kexec.c:139: error: for each function it appears in.)
> arch/ia64/kernel/machine_kexec.c:140: error: implicit declaration of function 'OFFSET'
> arch/ia64/kernel/machine_kexec.c:140: error: 'start_paddr' undeclared (first use in this function)
> arch/ia64/kernel/machine_kexec.c:141: error: 'size' undeclared (first use in this function)
> arch/ia64/kernel/machine_kexec.c:144: error: implicit declaration of function 'CONFIG'
> arch/ia64/kernel/machine_kexec.c:144: error: 'PGTABLE_3' undeclared (first use in this function)
> make[1]: *** [arch/ia64/kernel/machine_kexec.o] Error 1
> make: *** [arch/ia64/kernel] Error 2
> #

Thanks, I missed this.

That's 80% my fault and 20% the fault of the usage of generic names 
SYMBOL/SIZE/OFFSET/LENGTH/CONFIG making it impossible to grep for them 
(and namespace conflicts quite possible).

Can we get these #define's properly prefixed (e.g. KEXEC_SYMBOL etc.) so 
that other people will not repeat my mistake and namespace conflicts 
will be prevented?

> Thanks
> Ken'ichi Ohmichi

TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

