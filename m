Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYICWOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYICWOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYICWOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:14:35 -0400
Received: from waste.org ([66.93.16.53]:40683 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbYICWOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:14:35 -0400
Subject: Re: drivers/char/random.c line 728 BUG
From: Matt Mackall <mpm@selenic.com>
To: Aaron Straus <aaron@merfinllc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
In-Reply-To: <20080903182845.GM17899@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com>
	 <20080828225924.GD6432@merfinllc.com>
	 <20080829124807.54293904.akpm@linux-foundation.org>
	 <1220465901.17608.55.camel@calx>  <20080903182845.GM17899@merfinllc.com>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 17:12:00 -0500
Message-Id: <1220479920.17608.62.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-09-03 at 11:28 -0700, Aaron Straus wrote:
> Hi Matt,
> 
> On Sep 03 01:18 PM, Matt Mackall wrote:
> > This fix is bogus - it assumes that r->entropy_count has atomic
> > assignment which is not universally true (witness the existence of
> > atomic_t). So we can still observe partial updates to entropy_count on
> > some architectures. Now it's probably the case that we'll never see a
> > partial update that actually triggers the BUG_ON, but it's still
> > conceptually wrong to do things this way.
> 
> I think Andrew was just being safe by reverting to the old behavior.

Indeed. I've no doubt that his fix works and I'm certainly glad you guys
took the time to fix things while I was away. I just think the resulting
fix is a little silly.

> Could we still apply his patch for the upcoming stable tree and fix it
> the "right" way at some point in the future?

I'm not sure what the current state of play is here in terms of the
original patch being pushed to stable and mainline, but my patch is both
simpler and more correct. If it's not too late, it's the one that should
go to both places.

-- 
Mathematics is the supreme nostalgia of our time.

