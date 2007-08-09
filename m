Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbXHIVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbXHIVki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXHIVkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:40:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50402 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752099AbXHIVkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:40:23 -0400
Date: Thu, 9 Aug 2007 14:40:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee.Schermerhorn@hp.com, pj@sgi.com, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] Use one zonelist per node instead of multiple
 zonelists v2
In-Reply-To: <200708092320.01669.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0708091437580.32324@schroedinger.engr.sgi.com>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
 <20070809131943.64cb0921.akpm@linux-foundation.org> <200708092320.01669.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Andi Kleen wrote:

> > I think I'll duck this for now on im-trying-to-vaguely-stabilize-mm grounds.
> > Let's go with the horrible-hack for 2.6.23, then revert it and get this
> > new approach merged and stabilised over the next week or two?
> 
> I would prefer to not have horrible hacks even temporary

The changes that we are considering for 2.6.24 will result in a single 
zonelist per zone that will filter the zoneslist in alloc_pages. This lead 
to a performance improvement in the page allocator.

What you call a hack is doing the same for the special policy zonelist in 
2.6.23 in order to be able to apply policies to the two highest zones. We 
apply a limited portion of the changes for 2.6.24 to .23 to fix the 
ZONE_MOVABLE issue.

