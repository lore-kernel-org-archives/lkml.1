Return-Path: <linux-kernel-owner+w=401wt.eu-S1763510AbZANPb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763510AbZANPb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbZANPbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:31:15 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57057 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758220AbZANPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:31:14 -0500
Date: Wed, 14 Jan 2009 16:32:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Reif <reif@earthlink.net>, David Miller <davem@davemloft.net>,
       "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: sparc32 compile error: =?utf-8?Q?redef?=
	=?utf-8?B?aW5pdGlvbiBvZiDigJhzbXBfY2FsbF9mdW5jdGlvbl9zaW5nbGXigJk=?=
Message-ID: <20090114153255.GA32082@uranus.ravnborg.org>
References: <496D4274.6000304@earthlink.net> <20090113.181039.185575172.davem@davemloft.net> <20090113184239.e6b6e68e.akpm@linux-foundation.org> <20090113184536.95ebc973.akpm@linux-foundation.org> <496D5E19.7040802@earthlink.net> <20090113235940.12d856d0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113235940.12d856d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 11:59:40PM -0800, Andrew Morton wrote:
> On Tue, 13 Jan 2009 22:38:01 -0500 Robert Reif <reif@earthlink.net> wrote:
> 
> > This worked:
> > 
> > diff --git a/kernel/Makefile b/kernel/Makefile
> > index 2aebc4c..368227d 100644
> > --- a/kernel/Makefile
> > +++ b/kernel/Makefile
> > @@ -43,8 +43,10 @@ obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
> >  ifeq ($(CONFIG_USE_GENERIC_SMP_HELPERS),y)
> >  obj-y += smp.o
> >  else
> > +ifneq ($(CONFIG_SMP),y)
> >  obj-y += up.o
> >  endif
> > +endif
> >  obj-$(CONFIG_SMP) += spinlock.o
> >  obj-$(CONFIG_DEBUG_SPINLOCK) += spinlock.o
> >  obj-$(CONFIG_PROVE_LOCKING) += spinlock.o
> 
> This all can be simplified, can't it?
> 
> obj-$(CONFIG_USE_GENERIC_SMP_HELPERS) += smp.o
> ifneq ($(CONFIG_SMP),y)
> obj-y += up.o
> endif
> 
> (someone please check my homework - I don't have a good track
> record here ;))

Looks correct. We pull in smp.o only for SPARC64 AND SMP

But I find the next lines distastefull in a Makefile:
> ifneq ($(CONFIG_SMP),y)
> obj-y += up.o
> endif

I would prefer a small Kconfig helper symbol:

config SPARC_UP
	def_bool y
	depends on !SMP

And then we would do the Makefile bits like this:
obj-$(CONFIG_SPARC_UP) += up.o

So maybe a bit more involved patch - but more readable IMO.
Robert - can I ask you to fix it up if you and others agree.

Thanks,
	Sam
