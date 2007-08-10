Return-Path: <linux-kernel-owner+w=401wt.eu-S940504AbXHJQ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940504AbXHJQ73 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764475AbXHJQ7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:59:21 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57502 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760297AbXHJQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:59:20 -0400
Date: Fri, 10 Aug 2007 18:59:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Aurelien Jarno <aurelien@aurel32.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm2
Message-ID: <20070810165906.GI18938@stusta.de>
References: <20070809224254.11f42716.akpm@linux-foundation.org> <20070810092334.GA15285@hall.aurel32.net> <26090.1186764049@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <26090.1186764049@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 12:40:49PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 10 Aug 2007 11:23:34 +0200, Aurelien Jarno said:
> > I have just tried it, and it fails to build for MIPS with the following
> > error:
> > 
> >   CC      arch/mips/kernel/asm-offsets.s
> > In file included from include/linux/sched.h:58,
> >                  from arch/mips/kernel/asm-offsets.c:13:
> > include/linux/mm_types.h:115: error: expected specifier-qualifier-list before 'pgprot_t'
> > include/linux/mm_types.h:169: warning: 'struct file' declared inside parameter list
> > include/linux/mm_types.h:169: warning: its scope is only this definition or declaration, which is probably not what you want
> > include/linux/mm_types.h:175: error: expected specifier-qualifier-list before 'pgd_t'
> > 
> > 
> > The trivial patch below fixes this problem.
> 
> Rather than adding it to an include/linux file, where it then gets dragged
> in on *all* architectures, maybe we should investigate why it dies on MIPS,
> and fix it for *that* arch?

It must be included on *all* architectures, and the architectures where 
asm/page.h wasn't by chance already included indirectly included by some 
other header don't compile.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

