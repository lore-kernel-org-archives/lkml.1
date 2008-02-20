Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbYBTRbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbYBTRbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:31:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764729AbYBTRbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:31:00 -0500
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:48366 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764511AbYBTRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:30:58 -0500
Date: Wed, 20 Feb 2008 17:30:53 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <chaz20080220173053.GX4539@artesyncp.com>
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <200802192333.39707.arnd@arndb.de> <chaz20080220144339.GK4539@artesyncp.com> <20080220163042.GC5539@lazybastard.org> <chaz20080220170231.GV4539@artesyncp.com> <20080220172250.GA6873@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080220172250.GA6873@lazybastard.org>
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 20 Feb 2008 17:30:55.0357 (UTC) FILETIME=[590A2AD0:01C873E6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008-02-20 18:22:50 +0100, Jörn Engel:
> On Wed, 20 February 2008 17:02:31 +0000, Stephane Chazelas wrote:
> > 
> > sorry, I wasn't very clear.
> > 
> > With "loop", you're doing an ioctl() to /dev/loop<x> so that
> > /dev/loop<x> become a block device associated with a given file.
> > 
> > Applying that strictly to block2mtd wouldn't make sense.
> > 
> > At the moment, when you create a new block2mtd, the only thing
> > you see is an entry in /proc/mtd.
> > 
> > You don't access that mtd device directly (there's no
> > /dev/mtd<x>). Instead, you may access it via a /dev/mtdblock<x>
> > if you have "block2mtd" for instance.
> 
> Actually, there is /dev/mtd<x>.  Enable CONFIG_MTD_CHAR.

Yes, my point ;). "block2mtd" creates a "mtd" out of a block
device and "mtdchar" and "mtdblock" create the "char" and
"block" devices out of the "mtd". This is a different concept
from "loop". With "loop", you make a block device out of a file,
but you do the ioctl on the target loop block device itself.
With block2mtd, you can't do that.

> > Here, what you need, is an API that gets a block device (with fd
> > or path) and an erase size and that returns a mtd identifier.
> 
> Erase size is a real difference, agreed.  Otherwise the loop analogy is
> quite good.  Occasionally people are asking for file->mtd translation as
> well.
[...]

Actually, that's what I use block2mtd for, in combination with
"loop" to mount jffs2 filesystem images (always wondered if
there wasn't a simpler way, BTW (other than mtdram))

Cheers,
Stephane
