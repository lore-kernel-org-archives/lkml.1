Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZEGUjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZEGUjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZEGUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:38:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38603 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZEGUiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:38:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Thu, 7 May 2009 22:38:13 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: fengguang.wu@intel.com, linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072218.50782.rjw@sisk.pl> <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0905071321440.646@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072238.14558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, David Rientjes wrote:
> On Thu, 7 May 2009, Rafael J. Wysocki wrote:
> 
> > OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
> > I'll use the freezer-based approach instead.
> > 
> 
> Third time I'm going to suggest this, and I'd like a response on why it's 
> not possible instead of being ignored.
> 
> All of your tasks are in D state other than kthreads, right?  That means 
> they won't be in the oom killer (thus no zones are oom locked), so you can 
> easily do this
> 
> 	struct zone *z;
> 	for_each_populated_zone(z)
> 		zone_set_flag(z, ZONE_OOM_LOCKED);
> 
> and then
> 
> 	for_each_populated_zone(z)
> 		zone_clear_flag(z, ZONE_OOM_LOCKED);
> 
> The serialization is done with trylocks so this will never invoke the oom 
> killer because all zones in the allocator's zonelist will be oom locked.
> 
> Why does this not work for you?

Well, it might work too, but why are you insisting?  How's it better than
__GFP_NO_OOM_KILL, actually?

Andrew, what do you think about this?
