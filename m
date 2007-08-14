Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbXHNTDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbXHNTDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760056AbXHNTCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:02:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39284 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbXHNTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:02:54 -0400
Date: Tue, 14 Aug 2007 12:02:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: lethal@linux-sh.org, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch] slab: revert "slab: fix alien cache handling"
In-Reply-To: <20070814065657.GF10033@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0708141200470.29373@schroedinger.engr.sgi.com>
References: <20070813175824.GB12874@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0708131349100.27728@schroedinger.engr.sgi.com>
 <20070814065657.GF10033@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Siddha, Suresh B wrote:

> > Only if you find another way to fix the bug that is addressed there.
> 
> Does the appended version fix both the issues? Name alien in cache_free_alien
> is confusing, as the function does two things. free through alien caches
> or direct remote free..

Yes calling cache_free_alien is not necessary if you just have a single 
node. All memory is node local in that case.

I do not think that cache_free_alien is confusing since the name refers to 
the function freeing an alien object. That alien object can be freed to an 
alien cache or directly to a remote slab.

Acked-by: Christoph Lameter <clameter@sgi.com>
