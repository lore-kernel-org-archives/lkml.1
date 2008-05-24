Return-Path: <linux-kernel-owner+w=401wt.eu-S1762914AbYEXWcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762914AbYEXWcQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYEXWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:32:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42698 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYEXWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:32:03 -0400
Date: Sat, 24 May 2008 15:30:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@MIT.EDU
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080524153020.1df96cf2@linux.intel.com>
In-Reply-To: <20080524222304.GD20563@atrey.karlin.mff.cuni.cz>
References: <4836EE8C.1010200@linux.intel.com>
	<20080524222304.GD20563@atrey.karlin.mff.cuni.cz>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 May 2008 00:23:04 +0200
Jan Kara <jack@suse.cz> wrote:

>   Hello,
> 
> > Rank 3: mark_buffer_dirty
> > 	Reported 253 times (547 total reports)
> > 	EXT3 bug while hot-removing a USB device
> > 	This oops was last seen in version 2.6.25.3, and first seen
> > in 2.6.24-rc6.
> > 	More info: 
> > 	http://www.kerneloops.org/searchweek.php?search=mark_buffer_dirty
>   Is someone looking into this? It could be somehow connected with
> commit 1be62dc190ebaca331038962c873e7967de6cc4b where we add smp_mb()
> to mark_buffer_dirty() under some circumstances. But I don't really
> see how. The WARN_ON() being triggered is !buffer_uptodate(bh) but
> that seems ridiculous for call paths like ext2_sync_super() ->
> mark_buffer_dirty() or journal_destroy() ->
> journal_update_superblock() -> mark_buffer_dirty() which are in
> oopses. Also this warning started appearing only recently while ext2
> and JBD didn't change those areas recently. Also interesting may be
> that both ext2_sync_super() and journal_update_superblock() call
> sync_dirty_buffer() just after calling mark_buffer_dirty()...
>   Arjan, do we have some more info for these oopses (like hw config,
> what was the machine doing while the WARN_ON has been triggered etc.)?
> Thanks.
> 

Ted looked at these during the LF summit, and his conclusion was that
they're all media errors (eg USB unplug) that ext3 then did not handle
well at all. Maybe Ted has an update on this?

the 2.6.24-rc is a red herring btw.. that's just the first kernel
version that actually printed its version as part of WARN_ON().
