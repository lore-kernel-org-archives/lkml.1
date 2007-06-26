Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbXFZSWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbXFZSWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbXFZSWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:22:00 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44589 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbXFZSV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:21:59 -0400
Date: Tue, 26 Jun 2007 11:21:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, suresh.b.siddha@intel.com
Subject: Re: [patch 15/26] Slab defrag: Support generic defragmentation for
 inode slab caches
In-Reply-To: <20070626011836.f4abb4ff.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706261119420.18010@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com> <20070618095917.005535114@sgi.com>
 <20070626011836.f4abb4ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007, Andrew Morton wrote:

> > Provide generic functionality that can be used by filesystems that have
> > their own inode caches to also tie into the defragmentation functions
> > that are made available here.
> 
> Yes, this is tricky stuff.  I have vague ancestral memories that the sort
> of inode work which you refer to here can cause various deadlocks, lockdep
> warnings and such nasties when if we attempt to call it from the wrong
> context (ie: from within fs code).

Right that is likelyi the reason why Michael did his stress test...
 
> Possibly we could prevent that by skipping all this code if the caller
> didn't have __GFP_FS.

We do. Look at the earlier patch.

> I trust all the code in kick_inodes() was carefuly copied from 
> prue_icache() and such places - I didn't check it.

Yup tried to remain faithful to that. We could increase the usefulness if 
I could take more liberties with the code in order to actually move an 
item instead of simply reclaiming. But its better to first have a proven 
correct solution before doing more work on that.


