Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbXIRUBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbXIRUBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXIRUBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:01:23 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:8418 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbXIRUBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:01:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Vxt/XTXgnm5866rNEVh1JqIbFKm/HZOYX4dEkb8P6L/TadsIwp0ESaILSU8cqbTvRRPMEdomHqDJ6mUeu7rEJPkvD7Vh7izHp3bJq3QHs+st38egIZh3rq2DgIit/e1F6o4zW6Ib2y/yjcvwDcZJYMgvGditUfMWMx2c61qdXXU=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 1/7] Immediate Values - Architecture Independent Code
Date: Tue, 18 Sep 2007 21:01:12 +0100
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070917184224.549435917@polymtl.ca> <200709181847.22905.vda.linux@googlemail.com> <20070918175902.GB2915@Krystal>
In-Reply-To: <20070918175902.GB2915@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182101.12284.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 September 2007 18:59, Mathieu Desnoyers wrote:
> * Denys Vlasenko (vda.linux@googlemail.com) wrote:
> > On Monday 17 September 2007 19:42, Mathieu Desnoyers wrote:
> > > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > > ===================================================================
> > > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-17 13:25:06.000000000 -0400
> > > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-17 13:35:50.000000000 -0400
> > > @@ -122,6 +122,13 @@
> > >  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
> > >  	}								\
> > >  									\
> > > +	/* Immediate values: pointers */				\
> > > +	__immediate : AT(ADDR(__immediate) - LOAD_OFFSET) {		\
> > > +		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > > +		*(__immediate)						\
> > > +		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > > +	}								\
> > > +									\
> > 
> > Why do you need an output section for that? IOW: will this work too?
> > 
> > .data : ... { 
> > ...
> > 
> > 		VMLINUX_SYMBOL(__start___immediate) = .;		\
> > 		*(__immediate)						\
> > 		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> > ...
> > }
> > 
> 
> This last one could cause alignment problems. We either have to use the
> proper ALIGN() before the section, or let AT(ADDR(__immediate) -
> LOAD_OFFSET) take care of it. I prefer the latter.

This adds yet another output section in vmlinux, and there is
no tools which need that. We already have 30+ sections there while we need ~20.

I am trying to fix the mess. Please don't add to it.

Re alignment: (1) do you really realy REALLY need it? Last I checked,
i386 was handling unaligned accesses just fine; and
(2) this works:

		. = ALIGN(4)
 		VMLINUX_SYMBOL(__start___immediate) = .;		\
 		*(__immediate)						\
 		VMLINUX_SYMBOL(__stop___immediate) = .;			\


--
vda
