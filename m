Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXDMK71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXDMK71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 06:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXDMK71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 06:59:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:37917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436AbXDMK70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 06:59:26 -0400
Date: Fri, 13 Apr 2007 12:59:05 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fastcalls, was Re: [patch] generic rwsems
Message-ID: <20070413105905.GB27914@wotan.suse.de>
References: <20070413100416.GC31487@wotan.suse.de> <20070413101930.GA13169@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413101930.GA13169@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2007 at 11:19:30AM +0100, Christoph Hellwig wrote:
> On Fri, Apr 13, 2007 at 12:04:16PM +0200, Nick Piggin wrote:
> > Remove one level of indirection (kernel/rwsem.c -> lib/rwsem.c), and
> > give a bit of a cleanup (eg remove the fastcall junk) to make the
> > code a bit easier to read.
> 
> Arpopos fastcalls, now that -mregparam=3 is the defaul on i386 and
> FASTCALL/fastcall is a noop everywhere else can we please get rid
> of this attribute entirely?  If any other architecture provides
> a more optimal non-standard calling convention we can just use
> it by default in kernelspace as a few architectures already do.

I don't see why not. David objected me removing them I think because
the rwsem code called some from asm (but of course that's removed too).
However AFAIK, this situation should be using the asmlinkage attribute
anyway.

fastcall in kernel is annoying... it seems to imply that we normally
rather slow calls ;)
