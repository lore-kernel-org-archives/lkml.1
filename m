Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbYFWSiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbYFWSiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYFWSip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:38:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44325 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756700AbYFWSin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:38:43 -0400
Date: Mon, 23 Jun 2008 19:38:41 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       david@fromorbit.com
Subject: Re: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd hangs for a few sec)...
Message-ID: <20080623183840.GA1824@csn.ul.ie>
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com> <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com> <20080622221930.GA11558@disturbed> <20080623002415.GB21597@csn.ul.ie> <20080623072227.GB11986@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080623072227.GB11986@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/06/08 03:22), Christoph Hellwig didst pronounce:
> On Mon, Jun 23, 2008 at 01:24:15AM +0100, Mel Gorman wrote:
> > In that case, have you any theory as to why this circular dependency is
> > being reported now but wasn't before 2.6.26-rc1? I'm beginning to wonder
> > if the bisecting fingering the zonelist modifiation is just a
> > co-incidence.
> 
> I've seen this traces since lockdep was added when running xfsqa.
> 

Oh right, so this isn't even 2.6.26-rc1 as such. It's an older problem that
seems to be happening in more cases now, right? At this point, I believe the
bisection fingering the zonelist modification was a co-incidence as reclaim
behaviour at least is equivilant although catching the memory leak early
was a lucky positive outcome.

It's still not clear why the circular warning is happening more regularly now
but it's "something else". Considering the number of changes made to NFS,
XFS, reclaim and other areas since, I'm not sure how to go about finding
the real underlying problem or if it can be dealt with in a trivial manner.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
