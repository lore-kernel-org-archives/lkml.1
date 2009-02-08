Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709AbZBHU5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbZBHU5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZBHU5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:57:46 -0500
Received: from cmpxchg.org ([85.214.51.133]:43074 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZBHU5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:57:45 -0500
Date: Sun, 8 Feb 2009 21:56:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@jp.fujitsu.com,
       riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Message-ID: <20090208205650.GA6188@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org> <20090206130009.99400d43.akpm@linux-foundation.org> <20090206232747.GA3539@cmpxchg.org> <200902071823.54259.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902071823.54259.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 06:23:53PM +0100, Rafael J. Wysocki wrote:
> On Saturday 07 February 2009, Johannes Weiner wrote:
> > On Fri, Feb 06, 2009 at 01:00:09PM -0800, Andrew Morton wrote:
> > > On Fri, 6 Feb 2009 05:49:07 +0100
> > > Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > 
> > > > > and, I think you should mesure performence result.
> > > > 
> > > > Yes, I'm still thinking about ideas how to quantify it properly.  I
> > > > have not yet found a reliable way to check for whether the working set
> > > > is intact besides seeing whether the resumed applications are
> > > > responsive right away or if they first have to swap in their pages
> > > > again.
> > > 
> > > Describing your subjective non-quantitative impressions would be better
> > > than nothing...
> > 
> > Okay.
> > 
> > > The patch bugs me.
> > 
> > Please ignore it, it is broken as is.  My verbal cortex got obviously
> > disconnected from my code cortex when writing the changelog...
> 
> If I understood this correctly, patch 3/3 is to be disregarded.
> 
> > And I will reconsider the actual change bits, I still think that we
> > shouldn't scan anon page lists while may_swap is zero.
> 
> Hm, can you please remind me what may_swap == 0 acutally means?

That no mapped pages are reclaimed.  These are also mapped file pages,
but more importantly in this case, anon pages.  See this check in
shrink_page_list():

                if (!sc->may_swap && page_mapped(page))
                        goto keep_locked;

So scanning anon lists without allowing to unmap doesn't free memory.

	Hannes
