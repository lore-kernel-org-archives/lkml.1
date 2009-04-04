Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZDDOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZDDOg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDDOgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 10:36:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZDDOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 10:36:47 -0400
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: David Woodhouse <dwmw2@infradead.org>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dedekind@infradead.org, David Brownell <david-b@pacbell.net>,
       Linux MTD <linux-mtd@lists.infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
	 <1238742215.20906.99.camel@localhost.localdomain>
	 <a95a62fe0904031300i82bdf42h5bc854a002e0091e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Apr 2009 15:36:37 +0100
Message-Id: <1238855797.4068.6.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 13:00 -0700, Kevin Cernekee wrote:
> Based on: http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html
> 
> My only change from the previous posting
> (http://lists.infradead.org/pipermail/linux-mtd/2009-April/025121.html)
> was to remove the "mtd_" prefix on the device attributes.
> 
> David's 2/2 patch
> (http://lists.infradead.org/pipermail/linux-mtd/2009-March/025011.html)
> may still be used as-is.
> 
> Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>

Thanks, this looks like a very good start in the direction we need to
go. I've applied David's patches as well as the changes from this one,
and hooked it up for the CAFÉ NAND controller too.

Since the callers are passing a struct mtd_info * into nand_scan(), it
doesn't seem necessary to pass the device in too; they can just set it
for themselves. Passing it in to the NOR chip probe routines might make
sense though.

I'm not worried about a flag day for _internal_ stuff -- for 2.6.31 I
think I'm going to add a WARN_ON(&mtd->dev.parent) into the core code.

I really do think I want this to avoid the need for 64-bit ioctls
(except maybe MEMERASE64).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

