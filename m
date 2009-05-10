Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZEJNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZEJNST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZEJNSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:18:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZEJNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:18:03 -0400
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first
 class  citizen
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <2f11576a0905100539l1512170oc64f7aee2864e8d5@mail.gmail.com>
References: <20090508081608.GA25117@localhost>
	 <2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>
	 <20090510092053.GA7651@localhost>
	 <2f11576a0905100229m2c5e6a67md555191dc8c374ae@mail.gmail.com>
	 <20090510100335.GC7651@localhost>
	 <2f11576a0905100315j2c810e96mc29b84647dc565c2@mail.gmail.com>
	 <20090510112149.GA8633@localhost>
	 <2f11576a0905100439u38c8bccak355ec23953950d6@mail.gmail.com>
	 <20090510114454.GA8891@localhost> <1241957948.9562.2.camel@laptop>
	 <2f11576a0905100539l1512170oc64f7aee2864e8d5@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 10 May 2009 15:17:21 +0200
Message-Id: <1241961441.9562.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-10 at 21:39 +0900, KOSAKI Motohiro wrote:
> >> > They always use mmap(PROT_READ | PROT_WRITE | PROT_EXEC) for anycase.
> >> > Please google it. you can find various example.
> >>
> >> How widely is PROT_EXEC abused? Would you share some of your google results?
> >
> > That's a security bug right there and should be fixed regardless of our
> > heuristics.
> 
> Yes, should be. but it's not security issue. it doesn't make any security hole.
> Plus, this claim doesn't help to solve end-user problems.

Having more stuff executable than absolutely needed is always a security
issue.

> I think the basic concept of the patch is right.
>   - executable mapping is important for good latency
>   - executable file is relatively small
> 
> The last problem is, The patch assume executable mappings is rare, but
> it isn't guranteed.
> How do we separate truth executable mapping and mis-used PROT_EXEC usage?

One could possibly limit the size, but I don't think it pays to bother
about this until we really run into it, again as Andrew already said,
there's more ways to screw reclaim if you really want to.



