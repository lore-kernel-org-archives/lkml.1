Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbXCRQkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbXCRQkB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 12:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXCRQkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 12:40:01 -0400
Received: from waste.org ([66.93.16.53]:45129 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXCRQkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 12:40:00 -0400
Date: Sun, 18 Mar 2007 11:27:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070318162720.GI10459@waste.org>
References: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070314151934.1112.70126.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 05:19:34PM +0200, Artem Bityutskiy wrote:
> Hello,
> 
> This patch-set contains UBI, which stands for Unsorted Block Images. This
> is closely related to the memory technology devices Linux subsystem (MTD),
> so this new piece of software is from drivers/mtd/ubi.
> 
> In short, UBI is kind of LVM layer but for flash (MTD) devices. It makes
> it possible to dynamically create, delete and re-size volumes. But the
> analogy is not full. UBI also takes care of wear-leveling and bad
> eraseblocks handling, so UBI completely hides 2 aspects of flash chips
> which make them very difficult to work with:
> 
> 1. wear of eraseblocks;
> 2. bad eraseblocks.

Forgive my ignorance, but why did you not implement the two features
above as device mapper layers instead? A device mapper can arbitrarily
transform I/O addresses and contents and has direct access to the
mapped device's ioctl interfaces, etc. 

Writing a mapper that's driven by out of band data on the underlying
device can be done in a couple hundred lines of code. I've done it to
implement an MD5 integrity checking layer. In this case, all the I/Os
were simply remapped to be above the on-disk MD5 table and expanded to
be at least the hashed cluster size.

Even if the device mapper API is not completely up to the task (which
I strongly suspect it is), it would seem simpler to extend it than to
add 14000 lines of parallel subsystem.

-- 
Mathematics is the supreme nostalgia of our time.
