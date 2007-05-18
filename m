Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXERV5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXERV5v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbXERV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:57:45 -0400
Received: from thunk.org ([69.25.196.29]:59867 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036AbXERV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:57:44 -0400
Date: Fri, 18 May 2007 17:57:31 -0400
From: Theodore Tso <tytso@mit.edu>
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Message-ID: <20070518215731.GB10655@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
	Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
	ext3-users@redhat.com
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518143529.GB14611@ribosome.natur.cuni.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 04:35:29PM +0200, Martin Mokrejs wrote:
> >  How do you know that the corruption was caused by 2.6.21-rc1 ?
> >  Isn't it possible that the corruption was created by an earlier
> >  kernel, but only detected when a forced fsck was run - which just
> >  happened to be while you were running 2.6.21-rc1 ...
> > 
> >  My point is that, as far as I can see, there's nothing tying
> >  2.6.21-rc1 specifically to this corruption... or?
> 
> You might be right, but I thought maybe more probably is the cause in kernel
> as that is what I have changed recently. ;) Or maybe someone can at leats say
> "No, no changes to be considered between 2.6.20.6 and 2.6.22-rc1.". ;)

Well, given that your e2fsck transcript started with this:

> /dev/hda3 has been mounted 38 times without being checked, check forced

#1, This is why periodic checks are a good thing; it catches problems
that could stay hidden and result in data loss sooner rather later.

#2, It seems unlikely tha tthe problem is tied to 2.6.21-rc1.  The
filesystme corruption could have happened at any time in the last 38
mounts.  It could be caused by hardware problems, or software
problems; there really is no telling.

#3, With respect to your use of gentoo's unstable e2fsprogs, it seems
unlikely that the corruptions were caused by gentoo's e2fsprogs.  The
being said, Gentoo includes a number of development patches that I
wouldn't necessarily feel comfortable putting into production, and
indeed haven't been checked into SCM yet.  So it makes me nervous, but
I doubt it's related to your specific problem.

Regards,

						- Ted
