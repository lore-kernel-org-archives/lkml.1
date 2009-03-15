Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZCOWly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZCOWly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 18:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZCOWln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 18:41:43 -0400
Received: from phunq.net ([64.81.85.152]:55197 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751859AbZCOWln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 18:41:43 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sun, 15 Mar 2009 15:41:35 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903151445.04552.nickpiggin@yahoo.com.au> <20090315214426.GA6357@mit.edu>
In-Reply-To: <20090315214426.GA6357@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903151541.36223.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Sunday 15 March 2009, Theodore Tso wrote:
> On Sun, Mar 15, 2009 at 02:45:04PM +1100, Nick Piggin wrote:
> > > As it happens, Tux3 also physically allocates each _physical_ metadata
> > > block (i.e., what is currently called buffer cache) at the time it is
> > > dirtied.  I don't know if this is the best thing to do, but it is
> > > interesting that you do the same thing.  I also don't know if I want to
> > > trust a library to get this right, before having completely proved out
> > > the idea in a non-trival filesystem.  But good luck with that!  It
> > 
> > I'm not sure why it would be a big problem. fsblock isn't allocating
> > the block itself of course, it just asks the filesystem to. It's
> > trivial to do for fsblock.
> 
> So the really unfortunate thing about allocating the block as soon as
> the page is dirty is that it spikes out delayed allocation.  By
> delaying the physical allocation of the logical->physical mapping as
> long as possible, the filesystem can select the best possible physical
> location.

Tux3 does not dirty the metadata until data cache is flushed, so the
allocation decisions for data and metadata are made at the same time.
That is the reason for the distinction between physical metadata above,
and logical metadata such as directory data and bitmaps, which are
delayed.  Though physical metadata is positioned when first dirtied,
physical metadata dirtying is delayed until delta commit.

Implementing this model (we are still working on it) requires taking
care of a lot of subtle details that are specific to the Tux3 cache
model.  I have a hard time imagining those allocation decisions driven
by callbacks from a buffer-like library.

Regards,

Daniel
