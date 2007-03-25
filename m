Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXCYXAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXCYXAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 19:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932810AbXCYXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 19:00:24 -0400
Received: from lazybastard.de ([212.112.238.170]:56887 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbXCYXAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 19:00:09 -0400
Date: Mon, 26 Mar 2007 00:55:28 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Lang <david.lang@digitalinsight.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070325225528.GD19691@lazybastard.org>
References: <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070325200826.GA19691@lazybastard.org> <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 March 2007 13:49:58 -0800, David Lang wrote:
> On Sun, 25 Mar 2007, Jörn Engel wrote:
> 
> >Logical volume management can just as easily move its management
> >information into a table, instead of having it spread across all blocks.
> >Blocks can keep their original size.  Since you have to scan flash
> >anyway, you can also scan for a table, compare a magical number and do
> >some extra check to protect yourself against a UBI image inside some
> >logical volume.  No big deal.

[ This was not a request for UBI to be changed.  The only purpose was to
illustrate that LogFS is not broken.  The previous thread suggested
otherwise and I just couldn't leave it at that. ]

> if you are being paranoid about write cycles putting the write count in the 
> block you are writing avoids doing an erase/write elsewhere
>
> although, since you can flip bits to 1 without requireing an erase you 
[ vice versa.  you can flip bits to 0 without erasing. ]
> could sacrafice some space and say that your table has a normal counter for 
> the number of times the block has been erased, but a 'tally counter' where 
> you turn one bit on each time you erase the block, and when you fill up the 
> tally block you re-write the entire table, clearing all the tallys. if you 
> have relativly large eraseblocks it seems like you could afford to 
> sacrafice the space in your master table to avoid erases of it

Or you could have a table and any number of updates to it.  Erase one
block, append a small update marker to the table.  There are plenty of
options.  All have in common that code would be more complicated.

Another advantage is that erase counts don't get reset if the race
against a power failure during erase is lost.

Whether the advantaves of power-of-two blocksizes and safe erasecounts
are worth it, I leave for others to decide.

Jörn

-- 
Fools ignore complexity.  Pragmatists suffer it.
Some can avoid it.  Geniuses remove it.
-- Perlis's Programming Proverb #58, SIGPLAN Notices, Sept.  1982
