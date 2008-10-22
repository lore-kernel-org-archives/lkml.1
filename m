Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYJVKOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYJVKOH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYJVKNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:13:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYJVKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:13:53 -0400
Date: Wed, 22 Oct 2008 06:13:51 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>, lachlan@sgi.com,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081022101351.GB11313@infradead.org>
References: <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com> <20081017203710.GA27187@infradead.org> <20081017135510.7127c4e7@infradead.org> <a4423d670810200758m3cea3841h40988afc8eaf81@mail.gmail.com> <20081020163327.GA15651@infradead.org> <a4423d670810201013w6448cb38w402771799cefb5f5@mail.gmail.com> <20081020223549.GA21152@disturbed> <a4423d670810210442y51b62fc2naf6cb649e6b26942@mail.gmail.com> <20081022075838.GK18495@disturbed> <20081022082550.GM18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022082550.GM18495@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 07:25:50PM +1100, Dave Chinner wrote:
> > Basically the above commit moved xfs_ilock() inside
> > radix_tree_preload()/radix_tree_preload_end(), which means we are
> > taking a rwsem() while we have an elevated preempt count. I'll
> > get a patch out to fix it.

This really needs a warning.  Then again I don't really understand this
as the point of radix_tree_preload was that we can do the actual
radix-tree under a lock, or not?

Anyway, the patch looks correct to me, including the slightly unrelated
hunk to fix the missing unlock and preload leak.
