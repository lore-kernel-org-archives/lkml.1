Return-Path: <linux-kernel-owner+w=401wt.eu-S1763464AbYEXWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763464AbYEXWXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761667AbYEXWXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:23:06 -0400
Received: from [195.113.26.193] ([195.113.26.193]:57767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755895AbYEXWXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:23:05 -0400
Date: Sun, 25 May 2008 00:23:04 +0200
From: Jan Kara <jack@suse.cz>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080524222304.GD20563@atrey.karlin.mff.cuni.cz>
References: <4836EE8C.1010200@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4836EE8C.1010200@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> Rank 3: mark_buffer_dirty
> 	Reported 253 times (547 total reports)
> 	EXT3 bug while hot-removing a USB device
> 	This oops was last seen in version 2.6.25.3, and first seen in 
> 	2.6.24-rc6.
> 	More info: 
> 	http://www.kerneloops.org/searchweek.php?search=mark_buffer_dirty
  Is someone looking into this? It could be somehow connected with commit
1be62dc190ebaca331038962c873e7967de6cc4b where we add smp_mb() to
mark_buffer_dirty() under some circumstances. But I don't really see
how. The WARN_ON() being triggered is !buffer_uptodate(bh) but that
seems ridiculous for call paths like ext2_sync_super() ->
mark_buffer_dirty() or journal_destroy() -> journal_update_superblock() ->
mark_buffer_dirty() which are in oopses. Also this warning started
appearing only recently while ext2 and JBD didn't change those areas
recently. Also interesting may be that both ext2_sync_super() and
journal_update_superblock() call sync_dirty_buffer() just after calling
mark_buffer_dirty()...
  Arjan, do we have some more info for these oopses (like hw config,
what was the machine doing while the WARN_ON has been triggered etc.)?
Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
