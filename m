Return-Path: <linux-kernel-owner+w=401wt.eu-S1759406AbYBTRCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbYBTRCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYBTRCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:02:36 -0500
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:39959 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYBTRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:02:35 -0500
Date: Wed, 20 Feb 2008 17:02:31 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <chaz20080220170231.GV4539@artesyncp.com>
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <200802192333.39707.arnd@arndb.de> <chaz20080220144339.GK4539@artesyncp.com> <20080220163042.GC5539@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080220163042.GC5539@lazybastard.org>
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 20 Feb 2008 17:02:32.0617 (UTC) FILETIME=[6220A990:01C873E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008-02-20 17:30:42 +0100, Jörn Engel:
> On Wed, 20 February 2008 14:43:39 +0000, Stephane Chazelas wrote:
> > 
> > note that for "loop", you have /dev/loop0, /dev/loop1... which
> > makes it a pain to handle
> > 
> > For block2mtd, you don't need several device files in /dev, you
> > only need one to pass ioctls down to create mtd devices.
> > 
> > That may end up creating new /dev devices via mtdblock or
> > mtdblock_ro for instance.
> > 
> > So I'm not sure reusing the "loop" ioctls is a good idea.
> 
> /me notes that you dislike both existing interfaces and would prefer a
> third.  How likely is it that you will still like the new interface two
> years down the road?  How likely is it that everyone else will agree
> with you?
> 
> In the end, a painful interface is still less painful than a choice of
> several incompatible ones.  I used to think different and have burned my
> fingers often enough to learn the lesson. :)
[...]

Hi Jörn,

sorry, I wasn't very clear.

With "loop", you're doing an ioctl() to /dev/loop<x> so that
/dev/loop<x> become a block device associated with a given file.

Applying that strictly to block2mtd wouldn't make sense.

At the moment, when you create a new block2mtd, the only thing
you see is an entry in /proc/mtd.

You don't access that mtd device directly (there's no
/dev/mtd<x>). Instead, you may access it via a /dev/mtdblock<x>
if you have "block2mtd" for instance.

Here, what you need, is an API that gets a block device (with fd
or path) and an erase size and that returns a mtd identifier.

Best regards,
Stephane
