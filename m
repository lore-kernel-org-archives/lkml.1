Return-Path: <linux-kernel-owner+w=401wt.eu-S1761826AbXISRdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761826AbXISRdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760968AbXISRcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:32:24 -0400
Received: from el-out-1112.google.com ([209.85.162.177]:54442 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760991AbXISRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=VzrfkYAplMYEjLp6X0gwPIuBXj2H/kkhaek8sHq0be8JyetJpGuj5+vikwp2zdd2MGZYieC1/V82lPt4xCWAfBbHGzzhDjZFNppX1HiRRdqreLZPUUtiy7WztSePN0kNVuxj3b1nQTqTSKgqBkQ+6BeUftWovk/P+EeQDx9lFRk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Date: Wed, 19 Sep 2007 18:32:13 +0100
User-Agent: KMail/1.9.1
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20070918211324.161373216@polymtl.ca> <20070918211459.193904061@polymtl.ca> <20070919113737.GA18177@Krystal>
In-Reply-To: <20070919113737.GA18177@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191832.13561.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 12:37, Mathieu Desnoyers wrote:
> > Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:18.000000000 -0400
> > +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-09-14 10:11:31.000000000 -0400
> > @@ -129,6 +133,11 @@
> >  		VMLINUX_SYMBOL(__stop___immediate) = .;			\
> >  	}								\
> >  									\
> > +	/* Markers: strings */						\
> > +        __markers_strings : AT(ADDR(__markers_strings) - LOAD_OFFSET) {	\
> > +		*(__markers_strings)					\
> > + 	}								\
> > +									\
> >  	/* Kernel symbol table: strings */				\
> >          __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
> >  		*(__ksymtab_strings)					\
> [...]
> 
> Do you think I should also remove the __markers_strings section from here ?

Yes.

It will be beneficial if one can read include/asm-generic/vmlinux.lds.h and
arch/$ARCH/kernel/vmlinux.lds.S and understand which sections in resulting
vmlinux serve what purpose. A comment atop each section explaining
its role will be nice. Even more so that not many people are fluent
in ld script language.

Currently, one will need to grep around (and not only in kernel tree -
you need to read depmod.c source too) in order to understand the role
of various sections in vmlinux.

There are dearth of comments in ld scripts, and some sections
are created "just because I felt like it". For example, there are
".data.page_aligned" and ".data.percpu" sections - can you
easily tell which one has to be a section, and which does not need
to be one (can be merged with ".data")? Maybe both must be sections?
Or none of them?
--
vda
