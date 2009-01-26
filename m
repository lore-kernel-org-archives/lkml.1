Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZAZMQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZAZMQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:16:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZAZMQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:16:21 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36323 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZAZMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:16:20 -0500
Date: Mon, 26 Jan 2009 13:16:14 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Travis <travis@sgi.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] sysrq: include interrupt.h instead of irq.h
Message-ID: <20090126131614.4ad29c15@osiris.boeblingen.de.ibm.com>
In-Reply-To: <4977523B.6000507@sgi.com>
References: <20090121150249.a87aca09.sfr@canb.auug.org.au>
	<1232545758.31303.2.camel@osiris.boeblingen.de.ibm.com>
	<4977523B.6000507@sgi.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2009 08:50:03 -0800
Mike Travis <travis@sgi.com> wrote:

> Thanks for catching this Heiko!
> Mike

Erm... it still breaks. Are you going to add the patch to your tree?

> Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
> > we get this compile bug on s390:
> > 
> >   CC      drivers/char/sysrq.o
> > In file included from drivers/char/sysrq.c:38:
> > include/linux/irq.h: In function 'init_alloc_desc_masks':
> > include/linux/irq.h:442: error: dereferencing pointer to incomplete type
> > 
> > drivers/char/sysrq.c should include interrupt.h instead of irq.h.
> > 
> > Cc: Mike Travis <travis@sgi.com>
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> > ---
> >  drivers/char/sysrq.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-next/drivers/char/sysrq.c
> > ===================================================================
> > --- linux-next.orig/drivers/char/sysrq.c
> > +++ linux-next/drivers/char/sysrq.c
> > @@ -35,7 +35,7 @@
> >  #include <linux/vt_kern.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/kexec.h>
> > -#include <linux/irq.h>
> > +#include <linux/interrupt.h>
> >  #include <linux/hrtimer.h>
> >  #include <linux/oom.h>
