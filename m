Return-Path: <linux-kernel-owner+w=401wt.eu-S933736AbXHGCva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbXHGCva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 22:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXHGCvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 22:51:22 -0400
Received: from ns1.suse.de ([195.135.220.2]:52883 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932971AbXHGCvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 22:51:21 -0400
Date: Tue, 7 Aug 2007 04:51:20 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] radix-tree: use indirect bit
Message-ID: <20070807025120.GD17986@wotan.suse.de>
References: <20070802052446.GC31121@wotan.suse.de> <20070806114055.704b78d8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806114055.704b78d8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 11:40:55AM -0700, Andrew Morton wrote:
> On Thu, 2 Aug 2007 07:24:46 +0200 Nick Piggin <npiggin@suse.de> wrote:
> 
> > Rather than sign direct radix-tree pointers with a special bit, sign
> > the indirect one that hangs off the root. This means that, given a
> > lookup_slot operation, the invalid result will be differentiated from
> > the valid (previously, valid results could have the bit either set or
> > clear).
> > 
> > This does not affect slot lookups which occur under lock -- they
> > can never return an invalid result. Is needed in future for lockless
> > pagecache.
> 
> so.. we added 30 bytes of text to radix-tree.o for no purpose?

I guess no functional purpose at this stage. But I do like this
scheme better anyway, because it means that locked API users are
never exposed to the direct/indirect bit.

It's a bit variable... on powerpc, it _removed_ 22 bytes, and if
I delete the extra BUG_ON that I introduced, then it removes 128
bytes. 

