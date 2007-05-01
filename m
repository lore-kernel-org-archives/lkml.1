Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXEAUht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXEAUht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945918AbXEAUhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:37:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423671AbXEAUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:37:10 -0400
Date: Tue, 1 May 2007 13:36:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-Id: <20070501133618.93793687.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
	<20070501125559.9ab42896.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 21:19:09 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 1 May 2007, Andrew Morton wrote:
> > On Tue, 1 May 2007 19:10:29 +0100 (BST)
> > Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > > > Most of the rest of slub.  Will merge it all.
> > > 
> > > Merging slub already?  I'm surprised.
> > 
> > My thinking here is "does slub have a future".
> > I think the answer is "yes",
> 
> I think I agree with that,
> though it's a judgement I'd leave to you and others.
> 
> > so we're reasonably safe getting it into mainline for the finishing
> > work.  The kernel.org kernel will still default to slab.
> > 
> > Does that sound wrong?
> 
> Yes, to me it does.  If it could be defaulted to on throughout the
> -rcs, on every architecture, then I'd say that's "finishing work";
> and we'd be safe knowing we could go back to slab in a hurry if
> needed.  But it hasn't reached that stage yet, I think.
> 

Given the current state and the current rate of development I'd expect slub
to have reached the level of completion which you're describing around -rc2
or -rc3.  I think we'd be pretty safe making that assumption.

This is a bit unusual but there is of course some self-interest here: the
patch dependencies are getting awful and having this hanging around
out-of-tree will make 2.6.23 development harder for everyone.

So on balance, given that we _do_ expect slub to have a future, I'm
inclined to crash ahead with it.  The worst that can happen will be a later
rm mm/slub.c which would be pretty simple to do.

otoh I could do some frantic patch mangling and make it easier to carry
slub out-of-tree, but do we gain much from that?
