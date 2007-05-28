Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXE1Mif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXE1Mif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 08:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXE1Mi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 08:38:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:49581 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbXE1Mi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 08:38:26 -0400
Date: Mon, 28 May 2007 14:38:24 +0200
From: Jan Kara <jack@suse.cz>
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070528123824.GA32510@atrey.karlin.mff.cuni.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org> <20070524173911.GA4541@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524173911.GA4541@ucw.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> But here's what I've got:
> 
> oot@spitz:/home/pavel# fsck.ext2 -f /dev/hda3
> e2fsck 1.38 (30-Jun-2005)
> Pass 1: Checking inodes, blocks, and sizes
> Inode 371989 has illegal block(s).  Clear<y>? yes
> 
> Illegal block #2 (134217728) in inode 371989.  CLEARED.
> Pass 2: Checking directory structure
> 
> i_file_acl for inode 371988 (/home/root/misc/zaurus/smail) is 131072,
> should be zero.
> Clear<y>? yes
> 
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  -339972 +471044
> Fix<y>? yes
> 
> Free blocks count wrong for group #10 (13882, counted=13883).
> Fix<y>? yes
> 
> ...kernel 2.6.16-preempt (on zaurus). Filesystem should have been clean -- I was
> using it till crash for half a year, but that's what journal is for,
> right? ...But I guess this is almost impossible to debug?
  Actually, your case doesn't seem to be hard. The first block number
is 0x8000000 and the second one 0x20000. So something is flipping your
bits...

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
