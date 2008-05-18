Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYEROM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYEROM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 10:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYEROMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 10:12:50 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:33400 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651AbYEROMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 10:12:50 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
Date: Sun, 18 May 2008 15:12:42 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com,
       Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, dgc@sgi.com
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org> <20080517233908.GA15279@infradead.org>
In-Reply-To: <20080517233908.GA15279@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805181512.42921.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 May 2008 00:39:08 Christoph Hellwig wrote:
> On Sat, May 17, 2008 at 02:17:37PM -0700, Linus Torvalds wrote:
> > > [4294293.003500]  [<ffffffff8028106a>] __kmalloc+0x3e/0xe6
> > > [4294293.003500]  [<ffffffff803067fc>] ? xfs_iflush_int+0x272/0x2fb
> > > [4294293.003500]  [<ffffffff80320552>] kmem_alloc+0x6a/0xd1
> > > [4294293.003500]  [<ffffffff80307a9c>] xfs_iflush_cluster+0x4b/0x33f
> > > [4294293.003500]  [<ffffffff8030681e>] ? xfs_iflush_int+0x294/0x2fb
> > > [4294293.003500]  [<ffffffff80307f4b>] xfs_iflush+0x1bb/0x29d
> > > [4294293.003500]  [<ffffffff8031bc30>] xfs_inode_flush+0xb8/0xdd
> > > [4294293.003500]  [<ffffffff80328b1f>] xfs_fs_write_inode+0x30/0x4c
> >
> > And as a result, all the XFS stuff is then waiting for that lock which is
> > held by pdflush above:
>
> Btw, just that function has a missing GFP_NOFS and a too large
> allocation which were fixed by Dave Chinner but aren't in mainline
> yet.  Can you check whether it still happens with the patch below?

These patches fix the problem. Thanks Christoph.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
