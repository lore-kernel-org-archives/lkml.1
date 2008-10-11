Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYJKQ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYJKQ3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 12:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYJKQ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 12:29:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:58101 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYJKQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 12:29:36 -0400
Date: Sat, 11 Oct 2008 09:29:32 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: Chris Snook <csnook@redhat.com>, Stefan Monnier <monnier@iro.umontreal.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Filesystem for block devices using flash storage?
Message-ID: <20081011092932.31618741@infradead.org>
In-Reply-To: <20081011143552.GA1556@ucw.cz>
References: <jwvvdw33v5p.fsf-monnier+gmane.linux.kernel@gnu.org>
	<48ED1D62.8080100@redhat.com>
	<20081011143552.GA1556@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Writes to magnetic disks are functionally atomic at the sector
> > level. With SSDs, writing requires an erase followed by rewriting
> > the sectors that aren't changing.  This means that an ill-timed
> > power loss can corrupt an entire erase block, which could be up to
> > 256k on some MLC flash.  Unless you have a RAID card with a
> > battery-backed write cache, your best bet is probably data
> > journaling. On ext3, you can enable this with the data=journal
> > mount option or the rootflags=data=journal kernel parameter for
> > your root filesystem.  It's entirely possible that doing 
> 
> I don't think ext3 is safe w.r.t. whole eraseblocks disappearing. So
> if you write data 'nearby' root directory and power fails, bye bye
> filesystem, and journal will not help.
> 
> Actually ext2 will at least detect damage...

SSDs generally (and ones that are even remotely worth their money for
sure) erase blocks that have no data in them.
They keep empty blocks around, and when they want to erase a block with
"half data", they first move that data to an empty block before erasing
the old block.

This moving around is just a natural part of wear leveling..


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
