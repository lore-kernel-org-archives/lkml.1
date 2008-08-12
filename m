Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYHLWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYHLWFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYHLWEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:04:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbYHLWEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:04:37 -0400
Date: Tue, 12 Aug 2008 15:04:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
In-Reply-To: <20080812215441.GY28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0808121500340.3462@nehalem.linux-foundation.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org>
 <20080812205943.GX28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121415390.3462@nehalem.linux-foundation.org> <20080812215441.GY28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Aug 2008, Al Viro wrote:

> On Tue, Aug 12, 2008 at 02:24:04PM -0700, Linus Torvalds wrote:
> > 
> > You'd truncate the inode number. What's the big deal? Inode numbers aren't 
> > that important - they're just about the _least_ important part of the data 
> > returned for a readdir. 
> 
> Tell that to tar(1) ;-)

The thing is, you still have the low 32 (or 16) bits, so even tar is 
better off most of the time. 

Let's face it, we actually always truncate things as-is. What are inode 
numbers on NFS but truncated file handles? 

And the other side of the coin is that legacy binaries are almost never 
_system_ binaries. You upgrade those with your system They are some odd 
special-purpose thing.

> Anyway, the point for getdents() is simply that we *do* return an error; it's
> just that it ends up with -EINVAL instead of -EOVERFLOW, and that's simply
> bogus - we should either truncate silently or return the right value.  The
> code definitely intends to do the latter and fucks up.

I agree. However, the reason it f*cks up is exactly the fact that we have 
two different error numbers, which was why I suggested that if we really 
want to fix this problem and are talking about cleaning things up, then 
_that_ should be our primary place to look at.

Yes, it implies fixing and checking a lot of low-level filesystems. I 
agree. It's easier to just leave it be. 

			Linus
