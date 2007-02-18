Return-Path: <linux-kernel-owner+w=401wt.eu-S2993098AbXBRC5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993098AbXBRC5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993109AbXBRC5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:57:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:58387 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993098AbXBRC5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:57:02 -0500
Date: Sat, 17 Feb 2007 21:02:17 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 41/44 take 2] [UBI] gluebi unit header
Message-ID: <20070218030217.GH1038@crusty.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <200702172214.55654.arnd@arndb.de> <20070218020429.GE1038@crusty.rchland.ibm.com> <200702180315.25067.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200702180315.25067.arnd@arndb.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 03:15:23AM +0100, Arnd Bergmann wrote:
> On Sunday 18 February 2007 03:04, Josh Boyer wrote:
> > No, the MTD interface isn't flawed.  gluebi is present to make things like
> > JFFS2 work on top of UBI volumes with very little adaptations.  If you go
> > changing _every_ MTD user to now use either an MTD device or a native UBI
> > device, then the code for those users just gets bloated.
> 
> Right, that was my point. If the MTD API in the kernel is not flawed, why
> do we need the 'native' UBI interface? Just merge gluebi into UBI and
> get rid of the extra abstraction.

That suggestion came up several times.  gluebi represents a compromise
between the two groups.  IIRC, the issue was that representing UBI volumes
as MTD devices only makes sense in the dynamic volume case.  Static UBI
volumes require special write/update handling and so there was a need for
a native interface anyway.

> 
> > Assuming your SD card isn't doing wear-leveling itself within the device,
> > yes that is what you would get.  
> 
> While probably all modern SD cards have some amount of wear leveling
> built in, I wouldn't want to rely on that for anything but the simple
> large-file-on-fatfs (jpeg or mp3) case. Using UBI on top of the
> native wear-leveling sounds like the right solution.

Yeah.  Unfortunately, SD/USB/CF cards are all in sort of an awkward spot
when it comes to things like that.  They don't expose the raw flash
underneath, and they don't provide any indication of how robust the
built in wear-leveling is.  Ugh.

> > Or you could do something slightly more sane 
> > and use:
> > 
> > 1. MMC
> > 2. block2mtd
> > 3. JFFS2
> 
> Not on a 4GB SD medium, with the current jffs2 version. The problem
> is that jffs2 doesn't scale that well, so you want a different fs.

Oh, believe me I know. :)

> Since logfs isn't stable yet, you end up with something like ext3,
> which in turn means that you need a UBI-like concept to avoid
> wearing out the blocks that store your metadata.

That just sounds like we need Jörn to get off his butt and finish logfs ;)
Seriously, until something like that is done we'll be stuck with some not
so pleasant solutions for these kind of devices.

josh
