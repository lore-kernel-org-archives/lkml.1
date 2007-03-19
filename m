Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXCSSQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXCSSQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCSSQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:16:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53475 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbXCSSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:16:40 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319170838.GP4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 13:16:28 -0500
Message-Id: <1174328188.30079.46.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 12:08 -0500, Matt Mackall wrote:
> 
> > > If the end goal is to end up with something that looks like a block
> > > device (which seems to be implied by adding transparent wear leveling
> > 
> > Nope, not the end goal.  It's more about wear-leveling across the entire
> > flash chip than it is presenting a "block like" device.
> 
> It seems to be about spanning devices and repartitioning as well.
> Hence the analogy with LVM.

Yes, it can span multiple MTDs which spreads the wear-leveling even
more.  Yes, it can create/resize/remove volumes.  It does that
differently than LVM, but the ideas are related.  I don't see the issue
here I guess.

(UBI also has static volumes which LVM doesn't but that is an aside.)

> > > and bad block remapping), then I don't see any reason it can't be done
> > > in device mapper. The 'smarts' of mtdblock could in fact be pulled up
> > 
> > There is nothing smart about mtdblock.  And mtdblock has nothing to do
> > with UBI.
> 
> Note the scare quotes. Device mapper runs on top of a block device.
> And mtdblock is currently the block interface that MTD exports. And it
> has 'smarts' that hide handling of sub-eraseblock I/O. I'm clearly
> talking about an approach that doesn't involve UBI at all.

Ok, but what I'm saying is that using device mapper on top of mtdblock
is not a good solution.  mtdblock caches writes within an eraseblock to
a DRAM buffer of eraseblock size.  If you get a power failure before
that is flushed out, you lose an entire eraseblock's worth of data.
Oops.  And if you constantly flush the buffer, there's no point in
having it in the first place because it doesn't help or hide anything
then.  UBI doesn't have this problem.

That's why I suggested fixing the MTD layers that present block devices
first in the part of my reply that you cut off.  It seems to me that
you're really after getting flash to look like a block device, which
would enable device mapper to be used for something similar to UBI.
That's fine, but until someone does that work UBI fills a need, has
users, and has an existing implementation.

josh

