Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945Ab0AHQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0AHQiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910Ab0AHQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 11:38:51 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:41374 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab0AHQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 11:38:50 -0500
Date: Fri, 8 Jan 2010 08:37:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Valdis.Kletnieks@vt.edu
Cc: Roman Zippel <zippel@linux-m68k.org>, Michal Marek <mmarek@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org
Subject: Re: mmotm 2010-01-06-14-34 uploaded (squashfs+lib/decomp)
Message-Id: <20100108083717.31ff968c.randy.dunlap@oracle.com>
In-Reply-To: <24025.1262933694@localhost>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	<12343.1262836096@localhost>
	<12823.1262836907@localhost>
	<20100107080402.2f41d6f9.randy.dunlap@oracle.com>
	<24025.1262933694@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B475F63.00AF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jan 2010 01:54:54 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Thu, 07 Jan 2010 08:04:02 PST, Randy Dunlap said:
> > On Wed, 06 Jan 2010 23:01:47 -0500 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > On Wed, 06 Jan 2010 22:48:16 EST, Valdis.Kletnieks@vt.edu said:
> > > 
> > > > Building with CONFIG_SQUASHFS=m, CONFIG_SQUASHFS_LZMA=y ,
> > > > and CONFIG_DECOMPRESS_LZMA=n fails:
> > > 
> > > > Looks like a missing select/depends for DECOMPRESS_LZMA.  Somebody else can
> > > > decide which it should be...
> > > 
> > > Digging further:
> > >   
> > >   x Symbol: DECOMPRESS_LZMA [=n]                                            x  
> > >   x   Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=y] || SQUASHFS_LZMA [=y x  
> > > 
> > > How the heck did this happen?  Looks like a SELECT *is* there but it's
> > > not firing??!?
> > 
> > I saw this build error in linux-next and sent a patch for it -- it's below.
> > However, it doesn't appear to be exactly the same config as yours.
> 
> Yeah, that patch is how you ended up cc'ed - it was already in the linux-next
> patch in Andrew's -mmotm tarball.  It looked like you addressed one corner case
> of the problem, and I tripped over another.  But now I'm trying to get my
> brain wrapped around how I was able to get SQUASHFS_LZMA=y, and it had a
> select for DECOMPRESS_LZMA, but that *still* was 'n' anyhow? How did we end
> up with both && and || in that 'Selected by:' line?  Is that saying that
> RD_LZMA needs to be on too?

The menuconfig display is truncated (use left/right arrow keys to pan it).
The xconfig display shows this:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECOMPRESS_LZMA

type: tristate
reverse dep: RD_LZMA && BLK_DEV_INITRD || SQUASHFS_LZMA && MISC_FILESYSTEMS && SQUASHFS

defined at lib/Kconfig:117

There is no help available for this kernel option.
Symbol: DECOMPRESS_LZMA [=n]
Selected by: RD_LZMA [=n] && BLK_DEV_INITRD [=n] || SQUASHFS_LZMA [=n] && MISC_FILESYSTEMS [=n] && SQUASHFS [=n]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In the "reverse dep:" line, && has higher precedence that || does, so it's:

reverse dep: (RD_LZMA && BLK_DEV_INITRD) || (SQUASHFS_LZMA && MISC_FILESYSTEMS && SQUASHFS)

So RD_LZMA and BLK_DEV_INITRD don't matter.


> Adding some plausible-sounding kbuild-related entries from MAINTAINERS to
> the cc: list, maybe they can explain it...


---
~Randy
