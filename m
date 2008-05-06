Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYEFJum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYEFJum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYEFJu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:50:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:36709 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752834AbYEFJu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:50:28 -0400
Date: Tue, 6 May 2008 11:50:26 +0200
From: Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-ext4@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: Problem mounting ext2 using ext3?
Message-ID: <20080506095026.GA1409@duck.suse.cz>
References: <Pine.LNX.4.64.0805052304280.3160@anakin> <20080505222623.GA8357@mit.edu> <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-05-08 09:26:30, Vegard Nossum wrote:
> Hi,
> 
> On Tue, May 6, 2008 at 12:26 AM, Theodore Tso <tytso@mit.edu> wrote:
> > On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
> >  > when mounting the root file system, which is ext2 (has_journal is not set).
> >  > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
> >  >
> >  > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
> >  > new and different solution to handle this just went into mainline), but if I
> >  > disable CONFIG_EXT3 support, it boots up fine.
> >  >
> >  > Is this a known problem?
> >
> >  I can confirm this as a regression.  You don't even need to mount it
> >  as a root filesystem, or do this on an 68k system.  On my x86 system,
> >  using a kernel based off of git commit: afa26be8 (6 commits after
> >  2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
> >  taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
> >  /dev/closure/textext2fs /mnt").  (see below for my oops).  This does
> >  not occur with a kernel based off of 2.6.25, so it's a definite
> >  regression.
> 
> Hi,
> 
> I posted a very similar problem a couple of days ago:
> http://www.nabble.com/BUG-in-ext3_sync_fs-td16999997.html
> 
> to which I got zero replies. Can I close this in my internal bugzilla
> as dup/"not my fault"? The stacktrace looks very similar. This was
> also ext2 fs mounted (apparently) by ext3 code.
  Yes, this looks like the same problem. I'll take care of that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
