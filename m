Return-Path: <linux-kernel-owner+w=401wt.eu-S933284AbXF2NNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbXF2NNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 09:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764920AbXF2NM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 09:12:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:32818 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764897AbXF2NMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 09:12:54 -0400
X-Originating-Ip: 74.102.207.204
Date: Fri, 29 Jun 2007 09:10:52 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexey Dobriyan <adobriyan@sw.ru>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: fix fallout from "remove sched.h from mm.h" patch
In-Reply-To: <20070628151257.7a03e81b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706290904420.13877@localhost.localdomain>
References: <20070628140921.GA9753@localhost.sw.ru>
 <20070628151257.7a03e81b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:

> On Thu, 28 Jun 2007 18:09:21 +0400
> Alexey Dobriyan <adobriyan@sw.ru> wrote:
>
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> > ---
> >
> >  include/asm-frv/pgtable.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- a/include/asm-frv/pgtable.h
> > +++ b/include/asm-frv/pgtable.h
> > @@ -25,7 +25,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/list.h>
> >  #include <linux/spinlock.h>
> > -struct mm_struct;
> > +#include <linux/sched.h>
> >  struct vm_area_struct;
> >  #endif
> >
>
> Please provide changelogs.
>
> I assume this patch fixes some build error or something.

  i actually asked about this on either the janitors or newbies list
the other day -- one of the early examples from the LDD3 device
drivers book which built fine all this time suddenly stopped building,
until i explicitly included <linux/sched.h> to be able to dereference
a pointer to "task_struct":

/home/rpjday/AMD/k/topics/0_hi/hi1.c:15: error: dereferencing pointer to incomplete type
/home/rpjday/AMD/k/topics/0_hi/hi1.c:16: error: dereferencing pointer to incomplete type

  clearly, until now, that header file was being picked up
*somewhere*, but not now.  so i'm guessing there's going to be code
all over the place that suddenly needs to add that inclusion of
sched.h.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
