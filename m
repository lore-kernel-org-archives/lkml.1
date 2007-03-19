Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXCSVt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXCSVt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030685AbXCSVt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:49:26 -0400
Received: from waste.org ([66.93.16.53]:34508 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030591AbXCSVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:49:05 -0400
Date: Mon, 19 Mar 2007 16:36:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070319213628.GW4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain> <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174338393.17249.53.camel@sauron>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 11:06:33PM +0200, Artem Bityutskiy wrote:
> On Mon, 2007-03-19 at 14:54 -0500, Matt Mackall wrote:
> > The issue is 14000 lines of patch to make a parallel subsystem.
> 
> Parallel system exists since very long. One is
> flash->SW_or_HW_FTL->all_blkdev_stuff. The other is MTD->JFFS2. Think
> about _why_ there are 2 of them. Hint - reliability, performance. Your
> ranting basically says that only the first one makes sense. This is not
> true.

A better way would be for MTD to deliver a block dev with a rich
enough interface for JFFS2 to use efficiently in the first place. Yes,
I know that can't be done with the current block dev layer. But that's
what the source is for.

> We enhance the second branch, not the first, please, realize this. Both
> branches have their user base, and have always had.
> 
> >                      iSCSI/nbd(6)
> >                           |
> > filesystem {        swap  |  ext3        ext3     jffs2
> >                       \   |   |            |       /
> >                /       \  | dm-crypt->snapshot(5) /
> > device mapper -|        \ \   |                  /
> >                |         partitioning           /
> >                |              |          partitioning(4)
> >                |        wear leveling(3)  /
> >                |              |          /
> >                |      block concatenation
> >                |       |    |    |     |
> >                \      bad block remapping(2)   
> >                        |    |    |     |
> > MTD raw block {     raw block devices with no smarts(1)
> >                       /     |     \      \
> > hardware {         NAND    NAND   NAND   NAND
> 
> Matt, as I pointed in the first mail, flash != block device. 

And as I pointed out, you're wrong. It is both block oriented
(eraseBLOCK??) and random access. That's what a block device is. The
fact that it doesn't look like the other things that Linux currently
calls a block device and supports well is another matter.

> In your picture I see NAND->MTD raw block. So am I right that you
> assume that we already have a decent FTL? The fact is that we do
> not.

No. Look at the picture for more than two seconds, please. 

I can tell you didn't do this because you didn't manage to find (1)
which explicitly says "with no smarts". And you also cut out the footnote
where I explained what I meant by "with no smarts".

Find the spots marked (2) and (3). These are your FTL. 

> Please, bear in mind that decent FTL is difficult and an FS on top of
> FTL is slow, FTL hits performance considerably.

...and if you'd actually looked at the picture, you'd have seen JFFS2
bypassing it. Along with another footnote explaining it.

-- 
Mathematics is the supreme nostalgia of our time.
