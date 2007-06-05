Return-Path: <linux-kernel-owner+w=401wt.eu-S932798AbXFEQzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798AbXFEQzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXFEQzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:55:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:36263 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbXFEQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:55:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=Sdv0pyo97p1HlA8kbT/VXVU9G9hC7dEBQJ/dgaTH3oYVy1mOeNjK8RJBr214bjB/w
	4kCGz6SMnUGfzjrrdXUWQ==
Date: Tue, 5 Jun 2007 09:52:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@hpl.hp.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/22] 2.6.22-rc3 perfmon2 : modified powerpc files
In-Reply-To: <20070605114102.GG10199@frankl.hpl.hp.com>
Message-ID: <alpine.DEB.0.99.0706050951420.23578@chino.kir.corp.google.com>
References: <200705291348.l4TDmVGp019827@frankl.hpl.hp.com>
 <alpine.DEB.0.99.0706040738530.10505@chino.kir.corp.google.com>
 <20070605114102.GG10199@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Stephane Eranian wrote:

> > > diff --exclude=.git -urp linux-2.6.22.base/include/asm-powerpc/unistd.h linux-2.6.22/include/asm-powerpc/unistd.h
> > > --- linux-2.6.22.base/include/asm-powerpc/unistd.h	2007-05-29 03:17:57.000000000 -0700
> > > +++ linux-2.6.22/include/asm-powerpc/unistd.h	2007-05-29 03:24:14.000000000 -0700
> > > @@ -330,10 +330,22 @@
> > >  #define __NR_signalfd		305
> > >  #define __NR_timerfd		306
> > >  #define __NR_eventfd		307
> > > +#define __NR_pfm_create_context	308
> > > +#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
> > > +#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
> > > +#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
> > > +#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
> > > +#define __NR_pfm_start		(__NR_pfm_create_context+5)
> > > +#define __NR_pfm_stop		(__NR_pfm_create_context+6)
> > > +#define __NR_pfm_restart	(__NR_pfm_create_context+7)
> > > +#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
> > > +#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
> > > +#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
> > > +#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
> > >  
> > >  #ifdef __KERNEL__
> > >  
> > > -#define __NR_syscalls		308
> > > +#define __NR_syscalls		319
> > >  
> > 
> > The highest numbered syscall, __NR_pfm_create_context+11, is 319 and 
> > __NR_syscalls is set to the same, which is wrong.
> > 
> You mean, it is off by one, right? Should be 320, then.
> 

Yes, and the same off by one problem exists in your i386 patch that adds 
the new syscalls as well.
