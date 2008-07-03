Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYGCWLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYGCWLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYGCWLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:11:40 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:3337 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbYGCWLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:11:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LBzp/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,744,1204464600"; 
   d="scan'208";a="149412958"
Date: Fri, 4 Jul 2008 08:11:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>, Christoph Hellwig <hch@infradead.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       mtk.manpages@googlemail.com, axboe@kernel.dk
Subject: Re: [dm-devel] Re: [PATCH 3/3] Add timeout feature
Message-ID: <20080703221133.GA29319@disturbed>
Mail-Followup-To: Takashi Sato <t-sato@yk.jp.nec.com>,
	Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	dm-devel@redhat.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
	mtk.manpages@googlemail.com, axboe@kernel.dk
References: <20080630212450t-sato@mail.jp.nec.com> <20080701081026.GB16691@infradead.org> <20080701105251.GC22522@agk.fab.redhat.com> <9942A69CB65D4A41B39F36AF8EEF6F22@nsl.ad.nec.co.jp> <20080703124709.GI22522@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703124709.GI22522@agk.fab.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 01:47:10PM +0100, Alasdair G Kergon wrote:
> On Thu, Jul 03, 2008 at 09:11:05PM +0900, Takashi Sato wrote:
> > If the freezer accesses the frozen filesystem and causes a deadlock,
> > the above ideas can't solve it
> 
> But you could also say that if the 'freezer' process accesses the frozen
> filesystem and deadlocks then that's just a bug and that userspace code
> should be fixed and there's no need to introduce the complexity of a
> timeout parameter.

Seconded - that was also my primary objection to the timeout code.

> The point I'm trying to make here is:
>   Under what real-world circumstances might multiple concurrent freezing
>   attempts occur, and which of A, B or C (or other variations) would be
>   the most appropriate way of handling such situations?
> 
> A common example is people running xfs_freeze followed by an lvm command
> which also attempts to freeze the filesystem.

Yes, I've seen that reported a number of times.

> I can see a case for B or C, but personally I prefer A:
> 
> > > 1 succeeds, freezes
> > > 2 succeeds, remains frozen
> > > 3 succeeds, remains frozen
> > > 4 succeeds, thaws

Agreed, though I'd modify the definition of that case to be "remain
frozen until the last thaw occurs". That has the advantage that
it's relatively simple to implement with just a counter...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
