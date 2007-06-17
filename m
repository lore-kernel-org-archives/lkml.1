Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXFQEsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXFQEsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 00:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFQEr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 00:47:59 -0400
Received: from waste.org ([66.93.16.53]:38062 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXFQEr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 00:47:58 -0400
Date: Sat, 16 Jun 2007 23:46:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, johannes@sipsolutions.net,
       linux-wireless@vger.kernel.org, dcbw@redhat.com,
       hs4233@mail.mn-solutions.de, linux-kernel@vger.kernel.org,
       marcelo@kvack.org
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070617044636.GL11166@waste.org>
References: <1181757483.29767.99.camel@johannes.berg> <20070614170901.GA13384@infradead.org> <20070614103836.23b07a72.akpm@linux-foundation.org> <20070614181307.GA16856@infradead.org> <alpine.LFD.0.98.0706141121080.14121@woody.linux-foundation.org> <20070614190936.GA28917@tuxdriver.com> <20070614125618.a7338ad8.akpm@linux-foundation.org> <20070614200844.GC28917@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614200844.GC28917@tuxdriver.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 04:08:44PM -0400, John W. Linville wrote:
> On Thu, Jun 14, 2007 at 12:56:18PM -0700, Andrew Morton wrote:
> > On Thu, 14 Jun 2007 15:09:36 -0400
> > "John W. Linville" <linville@tuxdriver.com> wrote:
> > 
> > > It does not make sense to me to rip this out purely for aesthetic
> > > reasons.
> > 
> > Aesthetics are good, but that's not the main issue.
> > 
> > What is most worrying is that there appears to be a risk that these
> > newly-added interfaces will later become obsoleted by another interface. 
> > This means that we'll need to maintain, test and support _both_ interfaces
> > for a very long time.  This is the sort of foot-shooting we should avoid.
> 
> True enough.  However, I hope you will agree that we should not
> confuse foresight with speculation.
> 
> At present there is no sign on the horizon of either any mac80211
> mesh code or any other full-MAC wireless driver supporting mesh.
> Without either of those, it would seem imprudent to rush toward
> a gneric configuration interface even if nl80211 was prepared to
> sprout one.

Making it generic may be premature optimization.

But at the very least, we should deal with the three other problems
Christoph has pointed out: subfunctions, pointer indirections, and
32on64 cleanliness.

That last one may come back to bite you in a couple years' time, if not
other people. It's a major pain in the ass.

-- 
Mathematics is the supreme nostalgia of our time.
