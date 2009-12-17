Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbZLQTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbZLQTgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965448AbZLQTgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:36:50 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38897 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965440AbZLQTgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:36:49 -0500
Date: Thu, 17 Dec 2009 20:36:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: tytso@mit.edu, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217193648.GI4489@kernel.dk>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org> <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain> <20091217173957.GG2123@thunk.org> <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912170950330.15740@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17 2009, Linus Torvalds wrote:
> 
> 
> On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> > 
> > Sure, but there's some rumors/oral traditions going around that some
> > block devices want bio address which are page aligned, because they
> > want to play some kind of refcounting game,
> 
> Yeah, you might be right at that.
> 
> > And it's Weird Shit(tm) (aka iSCSI, AoE) type drivers, that most of us 
> > don't have access to, so just because it works Just Fine on SATA doesn't 
> > mean anything.
> > 
> > And none of this is documented anywhere, which is frustrating as hell.
> > Just rumors that "if you do this, AoE/iSCSI will corrupt your file
> > systems".
> 
> ACK. Jens? 

I've heard those rumours too, and I don't even know if they are true.
Who has a pointer to such a bug report and/or issue? The block layer
itself doesn't not have any such requirements, and the only places where
we play page games is for bio's that were explicitly mapped with pages
by itself (like mapping user data).o

We fix driver crap like that, we don't work around it. It's a BUG.

-- 
Jens Axboe

