Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYFBD0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYFBD0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 23:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYFBD0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 23:26:22 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39549 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYFBD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 23:26:21 -0400
Date: Sun, 1 Jun 2008 23:25:52 -0400
Message-Id: <200806020325.m523Pqsq025740@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Arnd Bergmann <arnd@arndb.de>, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-reply-to: Your message of "Mon, 02 Jun 2008 11:48:22 +0900."
             <9785.1212374902@jrobl> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann:
> Besides, there are a many more problems with unionfs, which have
> all been mentioned in the previous review cycles. Aufs doesn't
> address those either AFAIK, with the exception of at least
> not making additional copies in the page cache when writing to
> a file.

Correction: Unionfs doesn't make additional copies in the page cache.

Arnd, I favor a more generic approach, one that will work with the vast
majority of file systems that people use w/ unioning, preferably all of
them.  Supporting copy-on-write in cramfs will only help a small subset of
users.  Yes, it might be simple, but I fear it won't be useful enough to
convince existing users of unioning to switch over.  And I don't think we
should add CoW support in every file system -- the complexity will be much
more than using unionfs or some other VFS-based solution.

I can see some advantages (re: cache coherency) by hacking CoW support
directly into a f/s.  If you want to use a filesystem-specific solution,
then I suggest you don't modify a file system used as a source in a union,
but one used as a destination.  You'll have better overage that way.  The
vast majority of times, unionfs users will either write to tmpfs or ext2;
but the source readonly f/s can be a lot of different ones (most popular are
ext*, nfs*, isofs, and cramfs/squashfs).

I find it somewhat ironic to hear the argument that "union mounts isn't
stable yet, so lets come up with a new solution inside cramfs."  Why should
your solution become stable much faster than union mounts (which also had
patches floating around for a long time already).

If you have cycles to spare, why not help Bharata and Jan?

Cheers,
Erez.
