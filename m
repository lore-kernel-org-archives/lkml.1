Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXIJMFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXIJMFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758388AbXIJMDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:03:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47238 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758362AbXIJMDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:03:46 -0400
Date: Mon, 10 Sep 2007 14:03:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, perex@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070910120353.GD3563@stusta.de>
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070910022324.c69e1897.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 02:23:24AM -0700, Andrew Morton wrote:
> On Mon, 10 Sep 2007 10:08:08 +0100 Christoph Hellwig <hch@infradead.org> wrote:
>...
> > > Adrian knows this, yet he habitually sends zero-warning export-removal
> > > patches and I habitually ignore them.  I guess we must both enjoy this or
> > > something.
> > 
> > And I think almost everyone disagrees with you.  We just carry too much
> > crap around because of your subborness in this issue, and it gets really
> > annoying to have some high up on the food chain fighting his longly flight
> > against the other people.
> 
> I would like to see "everyone" explain what we lose by giving developers a
> bit of warning before we break their stuff.
>...

If it is really your intention that "everyone" warns external module 
authors in advance, the interesting part of the process are patches 
like commit 7d12e780e003f93433d49ce78cfedf4b4c52adc5 that break the API 
for virtually every module.

EXPORT_UNUSED_SYMBOL can't handle such API changes, you'll need to add 
other parts to the process. In this case it would most likely require 
adding a new IRQ API plus new APIs in several subsystems where structs 
changed, mantaining both in parallel for some time, and then dropping 
the older ones after some time.

What we lose is a bit of flexibility when changing kernel code plus a 
bit of time when adding replacement APIs and maintaining both in 
parallel.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

