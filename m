Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYKRN5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYKRN5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbYKRN5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:57:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36026 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYKRN5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:57:35 -0500
Subject: Re: [PATCH] physmap: Fix leak of memory returned by
	parse_mtd_partitions
From: David Woodhouse <dwmw2@infradead.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0811120808p5858d5adleeef43b1d374bee1@mail.gmail.com>
References: <20081112.235733.01917391.anemo@mba.ocn.ne.jp>
	 <20081113.005534.56563769.anemo@mba.ocn.ne.jp>
	 <8bd0f97a0811120808p5858d5adleeef43b1d374bee1@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 13:57:27 +0000
Message-Id: <1227016647.27728.398.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-12 at 11:08 -0500, Mike Frysinger wrote:
> i wonder why we duplicate this same code block in so many places.  and
> why does every driver have to declare its own list of parsers ?  cant
> we unify all of these in one place ?

Well, most boards only really want _one_ partition type; maybe two. And
the probes can be quite expensive and have false positives, so we don't
want to be doing all the probes for all devices.

It might make sense to just pass a bitmask indicating which partition
probes to use. Assuming we can agree on an ordering, that is :)

Another complication is that some boards have registered the whole
device first, while others have just registered the partitions.

I suspect it might be better to take the simple bug-fix approach for
now, given that we are planning a revamp of the MTD core API anyway --
we can redo partitions properly at the point, so they aren't just an
evil hack.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

