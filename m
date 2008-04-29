Return-Path: <linux-kernel-owner+w=401wt.eu-S1760334AbYD2NNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760334AbYD2NNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYD2NNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:13:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52783 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbYD2NND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:13:03 -0400
Date: Tue, 29 Apr 2008 22:09:47 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] mm/memory_hotplug.c must #include "internal.h"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <20080428111534.c873c81d.akpm@linux-foundation.org>
References: <20080428174008.GX2813@cs181133002.pp.htv.fi> <20080428111534.c873c81d.akpm@linux-foundation.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080429220415.D1D0.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-- > On Mon, 28 Apr 2008 20:40:08 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch fixes the following compile error caused by
> > commit 04753278769f3b6c3b79a080edb52f21d83bf6e2
> > (memory hotplug: register section/node id to free):
> > 
> > <--  snip  -->
> > 
> > ...
> >   CC      mm/memory_hotplug.o
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: In function ___put_page_bootmem___:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:82: error: implicit declaration of function _____free_pages_bootmem___
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c: At top level:
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/mm/memory_hotplug.c:87: warning: no previous prototype for ___register_page_bootmem_info_section___
> > make[2]: *** [mm/memory_hotplug.o] Error 1
> > 
> > <--  snip  -->
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 17f56d2d66ee41f504fcf0394687953c41afb8a4 diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index c4ba85c..b17dca7 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -29,6 +29,8 @@
> >  
> >  #include <asm/tlbflush.h>
> >  
> > +#include "internal.h"
> > +
> >  /* add this memory to iomem resource */
> >  static struct resource *register_memory_resource(u64 start, u64 size)
> >  {
> 
> Argh.  The -mm-only
> memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
> debugging patch adds that include so nobody hit this before.
> 
> I think I'll do an exploratory drop of that patch.

Hmm.
I remember I included it when I posted the patch.

http://marc.info/?l=linux-kernel&m=120757279231150&w=2

But it seems to have been lost somewhere...

Thanks.

Yasunori Goto 


