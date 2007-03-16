Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbXCOX7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbXCOX7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 19:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXCOX7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 19:59:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbXCOX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 19:59:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] swsusp: Do not use page flags
Date: Fri, 16 Mar 2007 01:01:25 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Kosina <jikos@jikos.cz>, Pavel Machek <pavel@ucw.cz>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
References: <200703122214.02657.rjw@sisk.pl> <Pine.LNX.4.64.0703152317260.12394@twin.jikos.cz> <20070315152328.228379db.akpm@linux-foundation.org>
In-Reply-To: <20070315152328.228379db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703160101.26384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 March 2007 23:23, Andrew Morton wrote:
> On Thu, 15 Mar 2007 23:19:02 +0100 (CET)
> Jiri Kosina <jikos@jikos.cz> wrote:
> 
> > On Thu, 15 Mar 2007, Andrew Morton wrote:
> > 
> > > > > And why _does_ suspend use GFP_ATOMIC all over the place?
> > > > Generally, because it cannot sleep.
> > > Why not?
> > 
> > I guess it's simply beucase of kswapd being already frozen, so there is no 
> > chance that once GFP_KERNEL allocation goes to sleep, it is going to get 
> > any free pages eventually ... ?
> 
> No, things should run fine with a dead kswapd.
> 
> There are reasons why we can't call into filesystems from there, but
> GFP_NOIO will ensure that and it is heaps better than GFP_ATOMIC.

In fact the role of swsusp_shrink_memory() is to ensure that our subsequent
atomic allocations won't fail.

Still, the particular allocations in create_basic_memory_bitmaps() are made
before we call swsusp_shrink_memory(), so it's better to use GFP_NOIO in there.

I'll prepare a patch for that on top of the current series.
