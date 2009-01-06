Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZAFKGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZAFKGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZAFKGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:06:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:52336 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751038AbZAFKGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:06:37 -0500
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX19NrfcTRqtN7cB5jgbaqH43DFBhm5mcytXV3YOxBV
	mUV6cRxVPnvz5c
Date: Tue, 6 Jan 2009 11:06:34 +0100
From: Matthias Andree <matthias.andree@gmx.de>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: document ext3 requirements
Message-ID: <20090106100634.GA6700@merlin.emma.line.org>
Mail-Followup-To: kernel list <linux-kernel@vger.kernel.org>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090103222957.GG1666@elf.ucw.cz>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Jan 2009, Pavel Machek wrote:

> On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
> > [Fixed top-posting]
> > 
> > 2009/1/3 Martin MOKREJ¦ <mmokrejs@ribosome.natur.cuni.cz>:
> > > Pavel Machek wrote:
> > >> readonly mount does actually write to the media in some cases. Document that.
> > >>
> > > Can one avoid replay of the journal then if it would be unclean?
> > > Just curious.
> > 
> > Nope. If the underlying block device is read-only then mounting the
> > filesystem will fail. I tried to fix this some time ago, and have a
> > set of patches that almost always work, but "almost always" isn't good
> > enough. Unfortunately I never managed to figure out a way to finish it
> > off without disgusting hacks or major surgery.
> 
> Uhuh, can you just ignore the journal and mount it anyway?

An ext3 file system that needs journal recovery sets one of the ext2
incompatible flags to prevent just that.

> ...basically treating it like an ext2?
> 
> ...ok, that will present "old" version of the filesystem to the
> user... violating fsync() semantics.
> 
> Still handy for recovering badly broken filesystems, I'd say.

While you cannot have that, you'll need to dump the file system
(possibly with dd_rescue) to another medium and work on the copy.
That's what you should do anyways. ;-)

I think if you really want to mount the file system without journal
replay, you need to clear the needs-recovery "incompat" flag (on the
copy, obviously).

-- 
Matthias Andree
