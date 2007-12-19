Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbXLSNpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbXLSNpx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXLSNpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:45:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbXLSNpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:45:44 -0500
Date: Wed, 19 Dec 2007 08:45:34 -0500
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [patch 17/20] non-reclaimable mlocked pages
Message-ID: <20071219084534.4fee8718@bree.surriel.com>
In-Reply-To: <200712191156.48507.nickpiggin@yahoo.com.au>
References: <20071218211539.250334036@redhat.com>
	<20071218211550.186819416@redhat.com>
	<200712191156.48507.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 11:56:48 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Wednesday 19 December 2007 08:15, Rik van Riel wrote:
> 
> > Rework of a patch by Nick Piggin -- part 1 of 2.
> >
> > This patch:
> >
> > 1) defines the [CONFIG_]NORECLAIM_MLOCK sub-option and the
> >    stub version of the mlock/noreclaim APIs when it's
> >    not configured.  Depends on [CONFIG_]NORECLAIM.

> Hmm, I still don't know (or forgot) why you don't just use the
> old scheme of having an mlock count in the LRU bit, and removing
> the mlocked page from the LRU completely.

How do we detect those pages reliably in the lumpy reclaim code?
 
> These mlocked pages don't need to be on a non-reclaimable list,
> because we can find them again via the ptes when they become
> unlocked, and there is no point background scanning them, because
> they're always going to be locked while they're mlocked.

Agreed.

The main reason I sent out these patches now is that I just
wanted to get some comments from other upstream developers.

I have gotten distracted by other work so much that I spent
most of my time forward porting the patch set, and not enough
time working with the rest of the upstream community to get
the code moving forward.

To be honest, I have only briefly looked at the non-reclaimable
code.  I would be more than happy to merge any improvements to
that code.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
