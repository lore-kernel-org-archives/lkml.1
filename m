Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbXERJlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbXERJlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXERJlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:41:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54620 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbXERJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:41:34 -0400
Date: Fri, 18 May 2007 11:42:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/14] all-archs: consolidate .data section definition in asm-generic
Message-ID: <20070518094231.GA13390@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org> <20070518065257.GE12284@uranus.ravnborg.org> <20070518.001604.23011298.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518.001604.23011298.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:16:04AM -0700, David Miller wrote:
> 
> Looking at these patches reminds me of a quirk in the generic
> RODATA definition:
> 
> >  #define RODATA								\
> >  	. = ALIGN(4096);						\
> >  	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
> 
> It uses ALIGN(4096) which is likely supposed to be something
> like ALIGN(PAGE_SIZE).  Perhaps we should handle this by
> definiting a LD_PAGE_SIZE at the top of vmlinux.ld.S files
> that need a value other than 4096, and define the default of
> 4096 in asm-generic/vmlinux.lds.h?

I would much rather use PAGE_SIZE direct since we have access to that symbol.
I would require a small modification in most asm-*/page.h files
so ld can parse them:

#define PAGE_SIZE (1UL << PAGE_SHIFT)
will become
#define PAGE_SIZE (_AC(1,UL) << PAGE_SHIFT)

This will allow the arch's to use that symbol in assembler too
which is a win.

Then we could do something like:

#define RODATA(alignment)	\
	ALIGN(alignment)	\

And on the call site we will most likely use

	RODATA(PAGE_SIZE)

But the architecture can override it.
Full flexibility and acceptable documentation.

> 
> If you could take care of this I'd really appreciate it.
Will do.
And may expend the effort a bit further when attacking the .lds files.

It will be a week or two before I get at it.

	Sam
