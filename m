Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbXFZCsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbXFZCsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXFZCsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:48:36 -0400
Received: from ns.suse.de ([195.135.220.2]:52984 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXFZCsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:48:35 -0400
From: Neil Brown <neilb@suse.de>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Tue, 26 Jun 2007 12:48:20 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18048.32372.40011.10896@notabene.brown>
Cc: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
In-Reply-To: message from Nick Piggin on Tuesday June 26
References: <20070624014528.GA17609@wotan.suse.de>
	<20070624014613.GB17609@wotan.suse.de>
	<18046.63436.472085.535177@notabene.brown>
	<467F71C6.6040204@yahoo.com.au>
	<20070625122906.GB12446@think.oraclecorp.com>
	<46807B32.6050302@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday June 26, nickpiggin@yahoo.com.au wrote:
> Chris Mason wrote:
> > 
> > The block device pagecache isn't special, and certainly isn't that much
> > code.  I would suggest keeping it buffer head specific and making a
> > second variant that does only fsblocks.  This is mostly to keep the
> > semantics of PagePrivate sane, lets not fuzz the line.
> 
> That would require a new inode and address_space for the fsblock
> type blockdev pagecache, wouldn't it? I just can't think of a
> better non-intrusive way of allowing a buffer_head filesystem and
> an fsblock filesystem to live on the same blkdev together.

I don't think they would ever try to.  Both filesystems would bd_claim
the blkdev, and only one would win.

The issue is more of a filesystem sharing a blockdev with the
block-special device (i.e. open("/dev/sda1"), read) isn't it?

If a filesystem wants to attach information to the blockdev pagecache
that is different to what blockdev want to attach, then I think "Yes"
- a new inode and address space is what it needs to create.

Then you get into consistency issues between the metadata and direct
blockdevice access.  Do we care about those?


NeilBrown
