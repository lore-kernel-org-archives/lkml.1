Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXCYVRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXCYVRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 17:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932638AbXCYVRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 17:17:54 -0400
Received: from lazybastard.de ([212.112.238.170]:33836 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXCYVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 17:17:53 -0400
Date: Sun, 25 Mar 2007 22:08:27 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070325200826.GA19691@lazybastard.org>
References: <20070318191812.GM4892@waste.org> <20070318203149.GC29295@crusty.rchland.ibm.com> <20070319170838.GP4892@waste.org> <1174328188.30079.46.camel@zod.rchland.ibm.com> <20070319195442.GT4892@waste.org> <1174338329.13341.633.camel@localhost.localdomain> <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174476334.10840.49.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 March 2007 12:25:34 +0100, Thomas Gleixner wrote:
> On Wed, 2007-03-21 at 12:05 +0100, Jörn Engel wrote:
> > 
> > Also LogFS currently requires erasesizes of 2^n.
> 
> Last time I talked to you about that, you said it would be possible and
> fixable.

Actually, no.  LogFS is not broken, there is nothing to fix.

And there is no fundamental reason why UBI should export blocks with
non-power-of-two sizes.  UBI currently consists of two parts that are
intimately intertwined in the current implementation, but have
relatively little connection otherwise.

1. Logical volume management.
2. Static volumes.

Logical volume management can just as easily move its management
information into a table, instead of having it spread across all blocks.
Blocks can keep their original size.  Since you have to scan flash
anyway, you can also scan for a table, compare a magical number and do
some extra check to protect yourself against a UBI image inside some
logical volume.  No big deal.

Static volumes can keep a header inside their volumes.  The tiny
first-stage bootloader is currently scanning flash and can continue to
do so.  But at least this header no longer causes trouble for LogFS or
any other UBI user.

UBI is just as broken as LogFS is.  It works with every user in mainline
(which comes down to JFFS2).  LogFS works with every MTD device in
mainline.  The only combination that doesn't work is LogFS on UBI - due
to deliberate design decisions on both sides.

Jörn

-- 
Joern's library part 8:
http://citeseer.ist.psu.edu/plank97tutorial.html
