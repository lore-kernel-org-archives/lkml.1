Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbYHQWK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbYHQWK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHQWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:10:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40268 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYHQWKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:10:17 -0400
Date: Mon, 18 Aug 2008 00:10:15 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>, Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon access scanning
Message-ID: <20080817221015.GB21112@atrey.karlin.mff.cuni.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com> <20080814223918.GC6370@elf.ucw.cz> <20080814200005.6b363716@bree.surriel.com> <20080815004335.GF13048@mit.edu> <20080815093513.5ca24c26@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815093513.5ca24c26@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So if that is the threat model, then the only thing libmalware.so
> > doesn't solve is knfsd access, and it should be evaluated on that
> 
> And static binaries, and other kernel modular file I/O done on behalf of
> applications, and making a library work well which is *hard*, and
> labelling and scalability, and sharing a cache between users, and
> aggregating events across processes .. and a few other things.

Well, I believe libmalware.so works with threat model I described; of
course it will not protect statically linked sambad (unless you
statically link it with libmalware.so, which you should do). I'm not
actually advocating LD_PRELOAD. There are enough userspace nfsds
around, but yes, you can't use libmalware.so with knfsd. 

[You could do something like fuse filesystem linked with libmalware,
and make knfsd export that, and put applications you can't link with
libmalware to use that. But that's a _hack_.]

> There seem so far to be two independent requests
> 
> * Noticing a file has recently changed, possibly with information about
> changes and possibly being able to aggregate/time that for scalability.
> This has a need to be able to accurately reference which file. This is
> needed for good content indexing, and virus people want it for certain
> kinds of scanning (post write, background etc). Doing this solely as a
> final close notifier seems to be insufficient (as it may never
> close).

Agreed, we need this.

> * Being able to pause an open pending some action. Examples include HSM
> and dubiously some kinds of virus check. Problems here include the fact
> it can only meaningfully be done for first open (which is fine for HSM)
> and that the notion of an exclusive open, or of repeated clearly defined
> open/read-write/close/done sequences are actually quite foreign to Unix
> like systems.

Do HSMs really get implemented like that? I'd expect HSM to be
something like fuse or unionfs... and when it is confined to one
filesystem, you can use existing solutions.

I don't like blocking at open at all, and I don't think blocking at
open is enough for antivirus scanner.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
