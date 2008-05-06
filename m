Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYEFH0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYEFH0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYEFH0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:26:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:13701 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYEFH0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:26:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PE1+a9urOAGNaWDavnOvRsKnYT++l/Ut11ry0sUMeEvGr8at2gm1zsgSZkU63Ke2/EKNR5l/F84+OEHzG2xSbiPy+qrc9NcSSqK3JY2eqYSDc0Ga+cG+LiBsCVojJZWGwX5KxdEAAMjNBVzPw+FTizLUFW9wko5qNq2ukK11bUg=
Message-ID: <19f34abd0805060026m138bf3dfo87dbf303362d69ca@mail.gmail.com>
Date: Tue, 6 May 2008 09:26:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>, linux-ext4@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>, "Jan Kara" <jack@suse.cz>
Subject: Re: Problem mounting ext2 using ext3?
In-Reply-To: <20080505222623.GA8357@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0805052304280.3160@anakin>
	 <20080505222623.GA8357@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 6, 2008 at 12:26 AM, Theodore Tso <tytso@mit.edu> wrote:
> On Mon, May 05, 2008 at 11:11:46PM +0200, Geert Uytterhoeven wrote:
>  > when mounting the root file system, which is ext2 (has_journal is not set).
>  > Apparently it crashes in ext3_sync_fs because EXT3_SB(sb)->s_journal is NULL.
>  >
>  > At first I thought it was an issue with the byteswapped IDE bus on Atari (a
>  > new and different solution to handle this just went into mainline), but if I
>  > disable CONFIG_EXT3 support, it boots up fine.
>  >
>  > Is this a known problem?
>
>  I can confirm this as a regression.  You don't even need to mount it
>  as a root filesystem, or do this on an 68k system.  On my x86 system,
>  using a kernel based off of git commit: afa26be8 (6 commits after
>  2.6.26-rc1), mounting an ext3 filesystem, you can cause an oops by
>  taking an ext2 filesystem and forcing a mount as ext3, "mount -t ext3
>  /dev/closure/textext2fs /mnt").  (see below for my oops).  This does
>  not occur with a kernel based off of 2.6.25, so it's a definite
>  regression.

Hi,

I posted a very similar problem a couple of days ago:
http://www.nabble.com/BUG-in-ext3_sync_fs-td16999997.html

to which I got zero replies. Can I close this in my internal bugzilla
as dup/"not my fault"? The stacktrace looks very similar. This was
also ext2 fs mounted (apparently) by ext3 code.

Thanks.

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
