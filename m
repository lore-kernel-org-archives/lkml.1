Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYBWPeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYBWPeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYBWPeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:34:00 -0500
Received: from lazybastard.de ([212.112.238.170]:42111 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYBWPd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:33:59 -0500
Date: Sat, 23 Feb 2008 16:33:21 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Stephane Chazelas <stephane.chazelas@emerson.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080223153321.GC29143@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <200802192333.39707.arnd@arndb.de> <chaz20080220144339.GK4539@artesyncp.com> <20080220163042.GC5539@lazybastard.org> <chaz20080220170231.GV4539@artesyncp.com> <20080220172250.GA6873@lazybastard.org> <chaz20080220173053.GX4539@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <chaz20080220173053.GX4539@artesyncp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 February 2008 17:30:53 +0000, Stephane Chazelas wrote:
> > 
> > Actually, there is /dev/mtd<x>.  Enable CONFIG_MTD_CHAR.
> 
> Yes, my point ;). "block2mtd" creates a "mtd" out of a block
> device and "mtdchar" and "mtdblock" create the "char" and
> "block" devices out of the "mtd". This is a different concept
> from "loop". With "loop", you make a block device out of a file,
> but you do the ioctl on the target loop block device itself.
> With block2mtd, you can't do that.

The fact is that there is _no_ interface to manage mtd.  Part of the
reason is this tradition to have seperate modules every couple of lines
of code.  In other subsystems, CONFIG_MTD_CHAR would not exist and the
code always be compiled in.  Simply to get _some_ interface to handle
the device that is always there.

Without going much deeper into that discussion, I consider it acceptable
to depend on CONFIG_MTD_CHAR for things like device removal.  If you
want device removal and explicitly don't want the extra code from
mtdchar.c, send a patch or go find 500 bytes to save elsewhere. ;)

With that out of the way, the question remains which interface we should
have.  Independently of mimicking loop, I would like to have a generic
interface for all mtd, not just block2mtd.  Whether it is "echo 1 >
/sys/.../mtd/mtdN/remove" or an ioctl(), I don't care much about.

> Actually, that's what I use block2mtd for, in combination with
> "loop" to mount jffs2 filesystem images (always wondered if
> there wasn't a simpler way, BTW (other than mtdram))

Logfs can use a block device directly, which still leaves loop.
Enhancing block2mtd to work with files shouldn't be too hard.  If anyone
want a fun project to hack on...

Jörn

-- 
Data dominates. If you've chosen the right data structures and organized
things well, the algorithms will almost always be self-evident. Data
structures, not algorithms, are central to programming.
-- Rob Pike
