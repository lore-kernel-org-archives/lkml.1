Return-Path: <linux-kernel-owner+w=401wt.eu-S1759600AbYJVVKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600AbYJVVKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYJVVKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:10:35 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:2813 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752408AbYJVVKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:10:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,466,1220193000"; 
   d="scan'208";a="216162427"
Date: Thu, 23 Oct 2008 08:10:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, lachlan@sgi.com,
       Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022211028.GO18495@disturbed>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Alexander Beregalov <a.beregalov@gmail.com>, lachlan@sgi.com,
	Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com> <20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed> <20081022101351.GB11313@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022101351.GB11313@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 06:13:51AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 22, 2008 at 07:25:50PM +1100, Dave Chinner wrote:
> > > Basically the above commit moved xfs_ilock() inside
> > > radix_tree_preload()/radix_tree_preload_end(), which means we are
> > > taking a rwsem() while we have an elevated preempt count. I'll
> > > get a patch out to fix it.
> 
> This really needs a warning.  Then again I don't really understand this
> as the point of radix_tree_preload was that we can do the actual
> radix-tree under a lock, or not?

Right - the preload allows us to do GFP_KERNEL allocations for radix
tree nodes and use a spinlock for inserts into the tree. We could
drop the preload stuff if we initialised the radix tree to use
GFP_ATOMIC allocations for radix tree nodes, but that is more likely
to lead to insert failures under low memory conditions compared to
the preload method.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
