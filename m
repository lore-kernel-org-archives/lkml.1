Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbZCYTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbZCYTt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbZCYTtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:49:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZCYTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:49:47 -0400
Date: Wed, 25 Mar 2009 15:48:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325194851.GA1617@infradead.org>
References: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325185824.GO32307@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 02:58:24PM -0400, Theodore Tso wrote:
> omits the fsync().  So with ext4 we has workarounds that start pushing
> out the data blocks in the for replace-via-rename and
> replace-via-truncate cases, while XFS will do an implied fsync for
> replace-via-truncate only, and btrfs will do an implied fsync for
> replace-via-rename only.

The XFS one and the ext4 one that I saw only start an _asynchronous_
writeout.  Which is not an implied fsync but snake oil to make the
most common complaints go away without providing hard guarantees.

IFF we want to go down this route we should better provide strong
guranteed semantics and document the propery.  And of course implement
it consistently on all native filesystems.

> Traditionally, the way applications told us about such dependencies
> was fsync().  But if application programmers are demanding that
> fsync() is no longer required for correct operation after a filesystem
> crash, all we can do is push things out to disk much more
> aggressively.

Note that the rename for atomic commits trick originated in mail severs
which always did the proper fsync.  When the word spread into the
desktop world it looks like this wisdom got lost.

