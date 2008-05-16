Return-Path: <linux-kernel-owner+w=401wt.eu-S1758241AbYEPRBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241AbYEPRBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYEPRBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:01:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53074 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752523AbYEPRBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:01:44 -0400
Date: Fri, 16 May 2008 10:01:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
In-Reply-To: <20080515231045.GY155679365@sgi.com>
Message-ID: <Pine.LNX.4.64.0805161000390.29603@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com>
 <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
 <20080515231045.GY155679365@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2008, David Chinner wrote:

> On Thu, May 15, 2008 at 10:42:15AM -0700, Christoph Lameter wrote:
> > On Mon, 12 May 2008, David Chinner wrote:
> > 
> > > If you are going to clean bufferheads (or pages), please clean entire
> > > mappings via ->writepages as it leads to far superior I/O patterns
> > > and a far higher aggregate rate of page cleaning.....
> > 
> > That brings up another issue: Lets say I use writepages on a large file 
> > (couple of gig). How much do you want to write back?
> 
> We're out of memory. I'd suggest write backing as much as you can
> without blocking.  e.g. treat it like pdflush and say 1024 pages, or
> like balance_dirty_pages() and write a 'write_chunk' back from the
> mapping (i.e.  sync_writeback_pages()).

Why are we out of memory? How do you trigger such a special writeout?
 
> Any of these are better from an I/O perspective than single page
> writeback....

But then filesystem can do tricks like writing out the surrounding areas 
as needed. The filesystem likely can estimate better how much writeout 
makes sense.

