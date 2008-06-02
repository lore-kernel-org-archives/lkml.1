Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYFBSO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYFBSO1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYFBSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:14:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42586 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYFBSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:14:19 -0400
Date: Mon, 2 Jun 2008 14:13:42 -0400
Message-Id: <200806021813.m52IDgFn015621@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-reply-to: Your message of "Mon, 02 Jun 2008 09:51:26 +0200."
             <200806020951.26868.arnd@arndb.de> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200806020951.26868.arnd@arndb.de>, Arnd Bergmann writes:
> On Monday 02 June 2008, Erez Zadok wrote:

> > Arnd, I favor a more generic approach, one that will work with the vast
> > majority of file systems that people use w/ unioning, preferably all of
> > them.  Supporting copy-on-write in cramfs will only help a small subset of
> > users.  Yes, it might be simple, but I fear it won't be useful enough to
> > convince existing users of unioning to switch over.  And I don't think we
> > should add CoW support in every file system -- the complexity will be much
> > more than using unionfs or some other VFS-based solution.
> 
> My idea was to have it in cramfs, squashfs and iso9660 at most, I agree
[...]

Ah, ok.  Doing those 3 will get better coverage for existing users.  The
question may come to how much code complexity does it add to each, and
whether some common code can be excised into generic helpers?

Arnd, my concern is that it might take a long time to see those in mainline.
Look at the status of whiteouts support in native file systems (just
whiteouts, not duplicate elimination): after months trials and several
posts, those patches aren't even in -mm.  And those are relatively simple
patches.  I can search for Viro's posting when he said he could hack it all
in one weekend; ok so maybe *he* can :-), but the point is that even with
Viro's tentative support of whiteouts, we're still not closer to having WH
support in mainline.

Who knows, maybe if you managed to get _something_ into mainline, it'll help
the overall effort move along; right now I fear there are too many strong
opinions on all sides that the effort is stuck.

[...]
> I'll probably try implementing a '-o union' option tmpfs anyway, just
> to see how hard it is and what the problems are.

And I'll be happy to test it for you (read: find bugs :-).  I've built a
large set of unioning-related regression tests over the years.

> 	Arnd <><

Erez.
