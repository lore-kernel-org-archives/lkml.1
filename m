Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZCYUsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZCYUsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZCYUsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:48:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbZCYUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:48:33 -0400
Date: Wed, 25 Mar 2009 13:40:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49CA9346.6040108@garzik.org>
Message-ID: <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain>
References: <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324132032.GK5814@mit.edu> <alpine.LFD.2.00.0903241053200.3032@localhost.localdomain> <20090324184549.GE32307@mit.edu>
 <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Jeff Garzik wrote:
> 
> It is clearly possible to implement an fsync(2) that causes FLUSH CACHE to be
> issued, without adding full barrier support to a filesystem.  It is likely
> doable to avoid touching per-filesystem code at all, if we issue the flush
> from a generic fsync(2) code path in the kernel.

We could easily do that. It would even work for most cases. The 
problematic ones are where filesystems do their own disk management, but I 
guess those people can do their own fsync() management too.

Somebody send me the patch, we can try it out.

> Remember, fsync(2) means that the user _expects_ a performance hit.

Within reason, though.

OS X, for example, doesn't do the disk barrier. It requires you to do a 
separate FULL_FSYNC (or something similar) ioctl to get that. Apparently 
exactly because users don't expect quite _that_ big of a performance hit.

(Or maybe just because it was easier to do that way. Never attribute to 
malice what can be sufficiently explained by stupidity).

			Linus
