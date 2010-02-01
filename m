Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0BANyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:54:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46550 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0BANyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:54:40 -0500
Date: Mon, 1 Feb 2010 14:54:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100201135438.GL29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com> <20100129205004.405949705@quilx.com> <20100130192623.GE788@thunk.org> <20100131083409.GF29555@one.firstfloor.org> <20100131210207.GA27883@thunk.org> <20100201101702.GH29555@one.firstfloor.org> <20100201134739.GA4635@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201134739.GA4635@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 08:47:39AM -0500, tytso@mit.edu wrote:
> On Mon, Feb 01, 2010 at 11:17:02AM +0100, Andi Kleen wrote:
> > 
> > On the other hand I would like to keep the option to be more aggressive
> > for soft page offlining where it's useful and nobody cares about 
> > the cost.
> 
> I'm not sure I understand what the goals are for "soft page
> offlining".  Can you say a bit more about that?

Predictive offlining of memory pages based on corrected error counts.
This is a useful feature to get more out of lower quality (and even
high quality) DIMMs.

This is already implemented in mcelog+.33ish memory-failure.c, but right
now it's quite dumb when trying to free a dcache/inode page (it basically
always has to blow away everything)

Also this is just one use case for this. The other would be 2MB
page at runtime support by doing targetted freeing (would be especially
useful with the upcoming transparent huge pages). Probably others
too. I merely mostly quoted hwpoison because I happen to work on that.

> 
> > Or the "let's add a updatedb" hint approach has the problem that
> > it won't cover a lot of other programs (as Linus always points out
> > these new interfaces rarely actually get used)
> 
> Sure, but the number of programs that scan all of the files in a file
> system and would need this sort of hint are actually pretty small.

Not sure that's true.

Also consider a file server :- how would you get that hint from the 
clients?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
