Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZAKJbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZAKJbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 04:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZAKJau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 04:30:50 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:40772 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZAKJaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 04:30:46 -0500
Date: Sun, 11 Jan 2009 10:30:37 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: <20090110221528.GA31774@elte.hu>
Message-ID: <Pine.LNX.4.64.0901111022590.30201@anakin>
References: <20090108175338.2abbee16.akpm@linux-foundation.org>
 <4966B24E.1050700@lougher.demon.co.uk> <ac3eb2510901081824g38abc47g4619e80ffaf8f1c5@mail.gmail.com>
 <20090109023629.GA29520@linuxace.com> <20090109165422.GF24884@logfs.org>
 <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org>
 <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org>
 <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Ingo Molnar wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > More importantly, the filesystem driver has to be able to read older 
> > filesystem instances.  This is a userspace-visible binary interface! A 
> > really complex one.
> > 
> > If for some reason we wish to change the on-disk format then that could 
> > be done now.  But once the code is merged, such changes could only be 
> > done in a back-compatible way.
> 
> IMHO what makes squashfs special is that:
> 
>  1) it's read-only: i.e. we dont actually _generate_ this data structure.
>     It comes from the outside.

This is not 100% true: the squashfs layout _has_ been changed in V4, in
response to review comments from the Linux kernel community on V3.3/V3.4.

>  2) it's a the "cat is already out of the bag" situation.
>     It's in the field, it's used.

AFAIK, all existing users use pre-V4. Let's hope this is going to change soon.

Apart from the use for backups (old ones have to be read using e.g. unsquashfs
now), I think this is OK: in most situations (embedded, Live CDs), the kernel
and the file system image are generated together (this is what e.g. OpenWRT
does).

> Generally when a filesystem driver comes to us, its lowlevel format is 
> pretty much a done deal already - it's out in the wild and we should say 
> 'no' only as an exception mechanism for clearly unacceptable crap.
> 
> Instead of trying to flex our muscle and steer the big red firetruck way 
> after the fire has been put out already - by others.
> 
> Saying 'no' at this stage comes at a great and largely unnecessary cost to 
> everyone involved. I believe we force ourselves into the R&D flow at an 
> inappropriately late stage - while at the same time we are unreceptive to 
> early adopter projects who'd like to avoid that. We cannot have the cake 
> and eat it too.
> 
> At least IMHO.
> 
> ( What could _perhaps_ change the picture a bit IMO is drivers/staging/ i 
>   think - we could take a far more active role in certain types of 
>   projects that have been done out of tree typically, with no formal
>   promise for compatibility - or something like that. )

So if staging would have existed +one year ago, we should probably have
included squashfs 3.3 at that time, and just have moved it to fs/ once the V4
layout was finished?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
