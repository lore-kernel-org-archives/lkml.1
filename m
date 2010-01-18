Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393Ab0ARUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0ARUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269Ab0ARUzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:55:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab0ARUzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:55:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Date: Mon, 18 Jan 2010 21:56:26 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1263549544.3112.10.camel@maxim-laptop> <201001180000.23376.rjw@sisk.pl> <201001180853.31446.oliver@neukum.org>
In-Reply-To: <201001180853.31446.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182156.26878.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, Oliver Neukum wrote:
> Am Montag, 18. Januar 2010 00:00:23 schrieb Rafael J. Wysocki:
> > On Sunday 17 January 2010, Benjamin Herrenschmidt wrote:
> > > On Sun, 2010-01-17 at 14:27 +0100, Rafael J. Wysocki wrote:
> > ...
> > > However, it's hard to deal with the case of allocations that have
> > > already started waiting for IOs. It might be possible to have some VM
> > > hook to make them wakeup, re-evaluate the situation and get out of that
> > > code path but in any case it would be tricky.
> > 
> > In the second version of the patch I used an rwsem that made us wait for these
> > allocations to complete before we changed gfp_allowed_mask.
> 
> This will be a very, very hot semaphore. What's the impact on performance?

rwsems are highly optimized AFAICT, but this is a good question of course.

I have no data at the moment.

Rafael
