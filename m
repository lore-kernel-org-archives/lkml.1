Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZEAWbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZEAWbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764924AbZEAWbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:31:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56697 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764799AbZEAWbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:31:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] PM: Drop shrink_all_memory (was: Re: [Bug #13058] First hibernation attempt fails)
Date: Sat, 2 May 2009 00:26:18 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200904222211.18221.rjw@sisk.pl> <20090422131943.69288af3.akpm@linux-foundation.org>
In-Reply-To: <20090422131943.69288af3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905020026.19027.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009, Andrew Morton wrote:
> On Wed, 22 Apr 2009 22:11:17 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday 22 April 2009, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > Of course, this will protect the calling task from getting oom-killed. 
> > > > But it doesn't protect other tasks from getting oom-killed due to the
> > > > activity of _this_ task.
> > > > 
> > > > But I think that problem already exists, and that this proposal doesn't
> > > > worsen anything, yes?
> > > > 
> > > > Or is it the case that all other tasks are safely stuck in the freezer
> > > > at this time, so they won't be allocating any memory anyway?
> > > 
> > > That is the idea, yes. ... but we now have more threads that are not
> > > freezable... so they may allocate the memory.
> > > 
> > > Is it non-feasible to free memory without really going and allocating
> > > everything?
> > 
> > The question is whether there is a point.  In principle we can just go and
> > allocate as much as we need upfront.  It shouldn't change anything, because
> > we resume and suspend devices after creating the image anyway.
> > 
> > I think we could try to disable the OOM killer before suspend and just
> > allocate the memory for the image right before devices are suspended for the
> > first time.
> > 
> 
> It would be nice to do.
> 
> shrink_all_memory() is simply trying to do something which page reclaim
> doesn't expect to do (free memory when there's already lots of memory
> free).  Consequently it doesn't do it very well, and there's a good
> risk that changes to core reclaim will accidentally break
> shrink_all_memory().  

OK, a patchset follows:

[1/3] - disable the OOM killer during system-wide power transitions (should be
        done anyway IMO)
[2/3] - move swsusp_shrink_memory() to kernel/power/snapshot.c so that the
        next patch is easier to read
[3/3] - drop shrink_all_memory()

Please have a look and tell me what you think.

Thanks,
Rafael

