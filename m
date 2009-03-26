Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZCZI0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZCZI0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbZCZI0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:26:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59274 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZCZI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:26:33 -0400
Date: Thu, 26 Mar 2009 04:24:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] issue storage device flush via sync_blockdev() (was
	Re: Linux 2.6.29)
Message-ID: <20090326082435.GA12317@infradead.org>
References: <49C93AB0.6070300@garzik.org> <20090325093913.GJ27476@kernel.dk> <49CA86BD.6060205@garzik.org> <20090325194341.GB27476@kernel.dk> <49CA9346.6040108@garzik.org> <alpine.LFD.2.00.0903251337410.3032@localhost.localdomain> <20090325212923.GA5620@havoc.gtf.org> <49CAA88B.1080102@sandeen.net> <49CAD343.5070009@redhat.com> <49CAD9B3.1010208@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CAD9B3.1010208@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 09:26:11PM -0400, Jeff Garzik wrote:
> What do you think sync_blockdev() does?  What is its purpose?

It writes out data in the block device inode.  Which does not include
any user data, and might not contain anything at all for filesystems
that have their own address space for metadata.  It's defintively the
wrong place for this kind of hack.

