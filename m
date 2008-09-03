Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYICWdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYICWdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYICWcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:32:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbYICWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:32:51 -0400
Date: Wed, 3 Sep 2008 15:32:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
Cc: aaron@merfinllc.com, linux-kernel@vger.kernel.org, tytso@mit.edu,
       stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-Id: <20080903153206.24dc88c3.akpm@linux-foundation.org>
In-Reply-To: <1220479920.17608.62.camel@calx>
References: <20080826225918.GC5452@merfinllc.com>
	<20080828225924.GD6432@merfinllc.com>
	<20080829124807.54293904.akpm@linux-foundation.org>
	<1220465901.17608.55.camel@calx>
	<20080903182845.GM17899@merfinllc.com>
	<1220479920.17608.62.camel@calx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2008 17:12:00 -0500
Matt Mackall <mpm@selenic.com> wrote:

> > Could we still apply his patch for the upcoming stable tree and fix it
> > the "right" way at some point in the future?
> 
> I'm not sure what the current state of play is here in terms of the
> original patch being pushed to stable and mainline, but my patch is both
> simpler and more correct. If it's not too late, it's the one that should
> go to both places.

It's a fairly minor thing.  The post-this-patch code takes care to
ensure that ->entropy_count never has an illegal value, so it's OK but
aesthetially unpleasing to check its value outside the lock.

And the post-this-patch code generates less .text, so it's a desirable
thing from that POV too.

We could/should do both, I guess.  I kinda ducked your move-the-BUG
patch because I wasn't in a write-yet-another-changelog mood.

