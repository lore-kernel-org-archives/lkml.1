Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbXERKVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbXERKVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbXERKVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:21:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32925
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbXERKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:21:24 -0400
Date: Fri, 18 May 2007 03:21:26 -0700 (PDT)
Message-Id: <20070518.032126.93383845.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 05/14] all-archs: consolidate .data section definition
 in asm-generic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070518094231.GA13390@uranus.ravnborg.org>
References: <20070518065257.GE12284@uranus.ravnborg.org>
	<20070518.001604.23011298.davem@davemloft.net>
	<20070518094231.GA13390@uranus.ravnborg.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 18 May 2007 11:42:31 +0200

> On Fri, May 18, 2007 at 12:16:04AM -0700, David Miller wrote:
> > 
> > Looking at these patches reminds me of a quirk in the generic
> > RODATA definition:
> > 
> > >  #define RODATA								\
> > >  	. = ALIGN(4096);						\
> > >  	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
> > 
> > It uses ALIGN(4096) which is likely supposed to be something
> > like ALIGN(PAGE_SIZE).  Perhaps we should handle this by
> > definiting a LD_PAGE_SIZE at the top of vmlinux.ld.S files
> > that need a value other than 4096, and define the default of
> > 4096 in asm-generic/vmlinux.lds.h?
> 
> I would much rather use PAGE_SIZE direct since we have access to that symbol.

I completely agree, that seems to be what platforms which have
a configurable page size such as powerpc, ia64, etc. are already
using in their vmlinux.lds.S files, and I'll likely follow suit on
sparc64. :-)

> > If you could take care of this I'd really appreciate it.
> Will do.
> And may expend the effort a bit further when attacking the .lds files.
> 
> It will be a week or two before I get at it.

Thanks a lot.
