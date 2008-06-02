Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYFBEiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYFBEiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYFBEiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:38:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39738 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYFBEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:37:59 -0400
Date: Mon, 2 Jun 2008 00:37:32 -0400
Message-Id: <200806020437.m524bWiW027508@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Arnd Bergmann <arnd@arndb.de>, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-reply-to: Your message of "Mon, 02 Jun 2008 11:48:22 +0900."
             <9785.1212374902@jrobl> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan Engelhardt wrote:
> > On Sunday 2008-06-01 08:02, David Newall wrote:
> >>   
> >>> I prefer the technique of union of a tmpfs over some other fs
> >>
> >> You're right in principle, but unfortunately there is to date no working
> >> implementation of union mounts. Giving users the option of using an
> >> existing file system with a few tweaks can only be better than than
> >> forcing them to use hacks like unionfs.
> >
> >I've not used unionfs (nor aufs) so I'm not aware of its foibles, but I
> >can say that it's the right kind of solution.  Rather than spend effort
> >implementing write support for read-only filesystems, why not put your
> >time into fixing whatever you see wrong with one or both of those?
> 
> I have to join in. Unionfs and AUFS may be bigger in bytes than the
> embedded developer wants to sacrifice, but that is what it takes for
> a solid implementation that has to deal with things like NFS and
> mmap. Even so, there is a fs called mini_fo you can try using if
> you disagree with the size of unionfs/aufs, at the cost of not having
> support for all corner cases.

I agree w/ Jan E.

Folks, I've said it before: unioning is a deceptively simple idea in
principle, and &^@%*$&^@ hard in practice.  And anyone who thinks otherwise
is welcome to write a *versatile* unioning implementation on their own.  Once
you get through all corner cases and satisfy all the features which users
want, you have a complex large file system.

I believe that implementing unioning inside actual filesystems is totally the
wrong direction: going to lower layers is wrong, instead of going up to a
VFS-based solution.  Unioning is a namespace operation that should not be
done deep inside a lower f/s.

People often wonder why FScache is (reportedly) so complex and big.  It's
b/c in some part it has to deal with similar issues: unioning is
copy-on-write, whereas caching is copy-on-read.

Nevertheless, I can understand if the embedded community wants lightweight
unioning.  Union Mounts initially may not support everything that unionfs
does, but it should be smaller, and it should be enough I believe for the
basic unioning uses --- perhaps even for the embedded community.  If so,
then I suggest people offer to help Bharata and Jan Blunk's efforts, rather
than [sic] cramming unioning into a single file system.

Erez.
