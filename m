Return-Path: <linux-kernel-owner+w=401wt.eu-S1757903AbZBXNqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903AbZBXNqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZBXNp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:45:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48016 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbZBXNp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:45:57 -0500
Date: Tue, 24 Feb 2009 08:45:55 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block bits for 2.6.29-rc5
Message-ID: <20090224134555.GA21436@infradead.org>
References: <20090218144105.GZ30821@kernel.dk> <20090219185434.GB24117@infradead.org> <20090219185539.GI29783@kernel.dk> <20090220072635.GR29783@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220072635.GR29783@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 08:26:35AM +0100, Jens Axboe wrote:
> It seems to work fine for me, tested with a modified sd that doesn't
> have barrier support and loop:
> 
> Filesystem "sdc1": Disabling barriers, trial barrier write failed
> XFS mounting filesystem sdc1
> 
> and
> 
> Filesystem "loop0": Disabling barriers, trial barrier write failed
> XFS mounting filesystem loop0
> 
> No extra failure warnings on the barrier IO itself. What device do you
> see this on?

virtio_blk and loop.  bvut I have investigated this further, and the
reason why I still saw the warnings is that xfs does a
blkdev_issue_flush on unomunt which is not protected by the barrier
flag, so it gets issued unconditionally.  So we got the additional
warning on unmount.  I've sent a patch to make the blkdev_issue_flush
conditionally to fix that issue.

