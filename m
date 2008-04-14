Return-Path: <linux-kernel-owner+w=401wt.eu-S1759928AbYDNHQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928AbYDNHQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbYDNHQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:16:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759669AbYDNHQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:16:05 -0400
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
From: Peter Zijlstra <peterz@infradead.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: efault@gmx.de, manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
In-Reply-To: <4802E93E.4090205@bull.net>
References: <20080411161702.460410000@bull.net>
	 <1207931235.7157.0.camel@twins>  <4802E93E.4090205@bull.net>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:15:59 +0200
Message-Id: <1208157359.7427.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 07:18 +0200, Nadia Derbey wrote:
> Peter Zijlstra wrote:
> > On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
> > 
> >>Here is finally the ipc ridr-based implementation I was talking about last
> >>week (see http://lkml.org/lkml/2008/4/4/208).
> >>I couldn't avoid much of the code duplication, but at least made things
> >>incremental.
> >>
> >>Does somebody now a test suite that exists for the idr API, that I could
> >>run on this new api?
> >>
> >>Mike, can you try to run it on your victim: I had such a hard time building
> >>this patch, that I couldn't re-run the test on my 8-core with this new
> >>version. So the last results I have are for 2.6.25-rc3-mm1.
> >>
> >>Also, I think a careful review should be done to avoid introducing yet other
> >>problems :-(
> > 
> > 
> > Why duplicate the whole thing, when we converted the Radix tree to be
> > RCU safe we did it in-place. Is there a reason this is not done for idr?
> > 
> > 
> > 
> 
> I did that because I wanted to go fast and try to fix the performance 
> problem we have with sysV ipc's. I didn't want to introduce (yet other) 
> regressions in the code that uses idr's today and that works well ;-)
> May be in the future if this rcu based api appears to be ok, we can 
> replace one with the other?

>From what I can see the API doesn't change at all, so I don't see why
you need to duplicate - either the new code works as expected or its
broken. If it works its good enough for all IDR users, if its broken we
should fix it. Seems simple enough.. am I missing something obvious?


