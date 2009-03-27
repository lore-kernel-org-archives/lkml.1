Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZC0DSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZC0DSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbZC0DSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:18:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44470 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178AbZC0DSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:18:39 -0400
Message-ID: <49CC4558.7020701@garzik.org>
Date: Thu, 26 Mar 2009 23:17:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] issue storage device flush via sync_blockdev()
References: <20090324184549.GE32307@mit.edu> <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <20090326032445.GA16999@havoc.gtf.org> <20090327025044.GM6239@mit.edu>
In-Reply-To: <20090327025044.GM6239@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Jeff,
> 
> FYI, I tried your patch; it causes the lvm process called out of
> the initramfs from an Ubuntu 8.10 system to blow up while trying to
> set up the root filesystem.  The stack trace was:
> 
> generic_make_request+0x2a3/0x2e6
> trace_hardirqs_on_caller+0x111/0x135
> mempool_alloc_slab+0xe/0x10
> mempool_alloc+0x42/0xe0
> submit_bio+0xad/0xb5
> bio_alloc_bioset+0x21/0xfc
> blkdev_issue_flush+0x7f/0xfc
> syn_blockdev+0x2a/0x36
> __blkdev_put_0x44/0x131
> blkdev_put+0xa/0xc
> blkdev_close+0x2e/0x32
> __fput+0xcf/0x15f
> fput+0x19/0x1b
> filp_close+0x51/0x5b
> sys_close+0x73/0xad

hmmm, I wonder if DM/LVM doesn't like blkdev_issue_flush, or it's too 
early, or what.  I'll toss Ubuntu onto a VM and check it out...

	Jeff



