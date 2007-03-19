Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXCSVOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXCSVOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965055AbXCSVOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:14:22 -0400
Received: from www.osadl.org ([213.239.205.134]:53169 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964853AbXCSVOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:14:20 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Matt Mackall <mpm@selenic.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070319201243.GV4892@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
	 <20070318162720.GI10459@waste.org> <1174236579.17249.6.camel@sauron>
	 <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174331010.13341.548.camel@localhost.localdomain>
	 <20070319201243.GV4892@waste.org>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 22:04:12 +0100
Message-Id: <1174338252.13341.630.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-19 at 15:12 -0500, Matt Mackall wrote:
> > Should we export block devices with 16/32/64/128 KiB size ?
> 
> Sure, why not?

Simply because we want to have the ability to write fine grained in
order to write data safe to FLASH. If we export those large sizes we
lose this ability and have to write full erase blocks for a couple of
bytes. This simply breaks JFFS2 and you can do the math yourself what
that means for the life time of FLASH, when you write small data chunks
in fast sequences and want to make sure that they are written to FLASH
immidiately.

> > A disk _IS_ fundamentally different to FLASH and all the magic which is
> > done inside of CF-Cards and USB-Sticks is just hiding this away.
> 
> And yet they're still both block devices. That our current block layer
> doesn't handle one as well as the other is something we should fix
> instead of inventing a whole new full-feature but incompatible block
> layer on the side.

And yet they are still broken and unreliable. And you can wear them out
in no time, just because they are stupid and do full eraseblock updates
when you write one sector.

No thanks. A bunch of people have done experiments with those beasts and
they are unusable for environments, where we need to make sure, that
data is on FLASH.

UBI is not an incompatible block layer. It allows to implement a very
clever block layer on top. And you can use just one large partition and
small ones for your kernel image and bootloader, which still get the
benefits of data integrity (by doing background safe copies on bit
flips) and the easy implementation in an IPL.

	tglx



