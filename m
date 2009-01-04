Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbZADTVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbZADTVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758594AbZADTVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:21:17 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:41443 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760529AbZADTVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:21:14 -0500
Date: Sun, 4 Jan 2009 20:21:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Theodore Tso <tytso@mit.edu>
cc: Duane Griffin <duaneg@dghda.com>, Valdis.Kletnieks@vt.edu,
       Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>,
       Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
In-Reply-To: <20090104184040.GC17558@mit.edu>
Message-ID: <Pine.LNX.4.64.0901042015230.31141@anakin>
References: <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com>
 <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz>
 <e9e943910901031538m24ff9616na2aaf3a57f161655@mail.gmail.com>
 <495FF9CE.2020908@ribosome.natur.cuni.cz> <e9e943910901031600o1705dfb3j197f90b62d1f75a6@mail.gmail.com>
 <495FFECB.5040001@ribosome.natur.cuni.cz> <e9e943910901031641x4c900b6ar5d0f50b648584b7b@mail.gmail.com>
 <15786.1231041158@turing-police.cc.vt.edu> <e9e943910901040624y69c01b43p1655c0078b969ea6@mail.gmail.com>
 <20090104184040.GC17558@mit.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Theodore Tso wrote:
> On Sun, Jan 04, 2009 at 02:24:43PM +0000, Duane Griffin wrote:
> > > Is there a way using md/dm/lvm etc to make the source partition R/O and
> > > replay the journal onto a CoW snapshop?  Admittedly, not easy to do inside
> > > the 'mount' command itself, but at least it might be workable for LiveCD R/O
> > > mounts and forensics work, where you can *tell* beforehand that's what you
> > > want and can jump through setup games before doing the mount...
> > 
> > Yes, something like that is best practice, as I understand it. The
> > LiveCD init scripts could check whether they are about to R/O mount an
> > ext[34] filesystem needing recovery and either refuse with a useful
> > message to the user, or even automatically create and mount a COW
> > snapshot, as you described. They'd still need to warn the user though,
> > since things like remounting R/W wouldn't work as expected.
> 
> So what's the use case where people want to be able to mount a
> filesystem needing recovery read/only without running the journal?

As mentioned before, suspending a laptop (running from hdd), running a live CD,
and expecting everything to work fine when resuming from hdd?

I think most people get shocked when they discover that mounting something
read-only may actualy write to the media. This is a bit unexpected (hey, if I
mount `read-only', I expect that no writes will happen), as it behaved
differently before the introduction of journalling.

As for mounting the root file system read-only during early boot up, and
remounting it read-write later, I guess it's quite complicated to replay the
journal (in RAM) on read-only mount, and deferring the replay writeback until
remounting read-write?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
