Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYHMQUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYHMQUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756459AbYHMQUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:20:39 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45005 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418AbYHMQUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:20:38 -0400
Date: Wed, 13 Aug 2008 12:20:29 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080813162029.GA24053@fieldses.org>
References: <20080812062241.GQ28946@ZenIV.linux.org.uk> <87ej4u9nf5.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <87proe81c1.fsf@devron.myhome.or.jp> <alpine.LFD.1.10.0808121303510.3462@nehalem.linux-foundation.org> <20080812205943.GX28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121415390.3462@nehalem.linux-foundation.org> <20080812215441.GY28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121500340.3462@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808121500340.3462@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:04:05PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 12 Aug 2008, Al Viro wrote:
> 
> > On Tue, Aug 12, 2008 at 02:24:04PM -0700, Linus Torvalds wrote:
> > > 
> > > You'd truncate the inode number. What's the big deal? Inode numbers aren't 
> > > that important - they're just about the _least_ important part of the data 
> > > returned for a readdir. 
> > 
> > Tell that to tar(1) ;-)
> 
> The thing is, you still have the low 32 (or 16) bits, so even tar is 
> better off most of the time. 
> 
> Let's face it, we actually always truncate things as-is. What are inode 
> numbers on NFS but truncated file handles? 

The server returns the inode number to the client as part of the file
attributes, and that's what the client reports as the inode number.  So,
no, the client doesn't try to fake up an inode number by truncating or
hashing the filehandle somehow, if that's what you mean.  Maybe I'm
missing your point....

--b.

> 
> And the other side of the coin is that legacy binaries are almost never 
> _system_ binaries. You upgrade those with your system They are some odd 
> special-purpose thing.
> 
> > Anyway, the point for getdents() is simply that we *do* return an error; it's
> > just that it ends up with -EINVAL instead of -EOVERFLOW, and that's simply
> > bogus - we should either truncate silently or return the right value.  The
> > code definitely intends to do the latter and fucks up.
> 
> I agree. However, the reason it f*cks up is exactly the fact that we have 
> two different error numbers, which was why I suggested that if we really 
> want to fix this problem and are talking about cleaning things up, then 
> _that_ should be our primary place to look at.
> 
> Yes, it implies fixing and checking a lot of low-level filesystems. I 
> agree. It's easier to just leave it be. 
> 
> 			Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
