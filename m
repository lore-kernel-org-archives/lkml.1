Return-Path: <linux-kernel-owner+w=401wt.eu-S1422979AbXBPA6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422979AbXBPA6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXBPA6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:58:08 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37205 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422980AbXBPA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:58:06 -0500
Date: Thu, 15 Feb 2007 19:58:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse chokes on arch/i386/kernel/i8253.c
Message-ID: <20070216005804.GA12736@Krystal>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <45D483D7.2040609@imap.cc> <20070215144142.0c13580a.akpm@linux-foundation.org> <20070216002347.GB9851@Krystal> <20070215163709.720c38f0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070215163709.720c38f0.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:55:16 up 13 days, 15:03,  3 users,  load average: 1.46, 1.37, 1.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 15 Feb 2007 19:23:47 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > sparse chokes on arch/i386/kernel/i8253.c
> > 
> > Here is a marker fix that puts the correct -i include/linux/marker.h in
> > the top level Makefile so sparse works correctly. The tricky part is to
> > keep the kernel compiling correctly with a kernel build directory
> > different from the kernel source tree too.
> > 
> > The fix applies on top the the Linux Kernel Markers for 2.6.20.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -309,7 +309,8 @@ AFLAGS_KERNEL	=
> >  LINUXINCLUDE    := -Iinclude \
> >                     $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
> >  		   -include include/linux/autoconf.h \
> > -		   -include linux/marker.h
> > +		   -include \
> > +		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
> >  
> >  CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
> 
> But what is so magical about marker.h to justify special-case treatment at the
> kbuid level?

Idealistically speaking, nothing. It is however much easier to maintain
an external set of patches introducing markers within the kernel tree :
most of the rejects between kernel version comes from new includes that
comes in the way.

So this is there more by convenience than requirement.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
