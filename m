Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbXEJTiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbXEJTiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXEJTiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:38:07 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXEJTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:38:06 -0400
Date: Thu, 10 May 2007 12:37:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [2.6.22 PATCH 23/26] dm delay:
Message-Id: <20070510123755.09dbc70c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
References: <20070508194859.GD24114@agk.fab.redhat.com>
	<20070508175410.d5b7e91f.akpm@linux-foundation.org>
	<20070510120223.bb4c22df.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 12:04:50 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Thu, 10 May 2007, Andrew Morton wrote:
> 
> > > > +	delayed_cache = kmem_cache_create("dm-delay",
> > > > +					  sizeof(struct delay_info),
> > > > +					  __alignof__(struct delay_info),
> > > > +					  0, NULL, NULL);
> > > 
> > > We have an ugly^Wnice new KMEM_CACHE macro for this now.
> 
> How could I nicify the macro? Lower case?

Lower case would be worse, IMO.  Upper-case says "this is a macro".  Lower-case
macros are OK when they are macros pretending to be functions, but KMEM_CACHE
is not such a thing.

I don't think it can be nicified, except by removing it.  We generally
prefer to open-code things rather than wrapping them up in macros.

But given the amount of variation amongst callers and the number of times
this got screwed up, I agree that burying those details at a single site
makes sense in this instance.
