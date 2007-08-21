Return-Path: <linux-kernel-owner+w=401wt.eu-S1761533AbXHURgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761533AbXHURgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 13:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbXHURgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 13:36:45 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57062 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757574AbXHURgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 13:36:44 -0400
Date: Tue, 21 Aug 2007 19:35:50 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: RFC: drop support for gcc < 4.0
Message-ID: <20070821173550.GC30705@stusta.de>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070821093103.3c097d4a.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 09:31:03AM -0700, Randy Dunlap wrote:
> On Tue, 21 Aug 2007 15:20:38 +0200 Jarek Poplawski wrote:
> 
> > Here are some more of, probably well-known, warnings with attached
> > testing-only .config.
> >...
> > drivers/pci/msi.c:686: warning: weak declaration of `arch_msi_check_device' after first use results in unspecified behavior
> > drivers/pci/msi.c:698: warning: weak declaration of `arch_setup_msi_irqs' after first use results in unspecified behavior
> > drivers/pci/msi.c:718: warning: weak declaration of `arch_teardown_msi_irqs' after first use results in unspecified behavior
> >...
> 
> What gcc version?  I don't get the arch_ warnings in drivers/pci/msi.c.

Obviously a gcc <= 3.4 [1], and therefore no unit-at-a-time.

You can reproduce it with a more recent gcc when adding 
-fno-unit-at-a-time to the CFLAGS.

And it's becoming a real maintainance problem that not only this problem 
but also other problems like some section mismatches [2] are only 
present without unit-at-a-time.

Currently we support 6 different stable gcc release series, and it might 
be the right time to consider dropping support for the older ones.

Are there any architectures still requiring a gcc < 4.0 ?

> ~Randy

cu
Adrian

[1] unit-at-a-time was added in gcc 3.4, but on gcc 3.4 we disable it on
    i386 due to stack usage problems
[2] example: static __init function with exactly one caller, and this
             caller is non-__init

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

