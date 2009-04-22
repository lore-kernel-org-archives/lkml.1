Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZDVU2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZDVU2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZDVU14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:27:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752987AbZDVU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:27:55 -0400
Date: Wed, 22 Apr 2009 13:19:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #13058] First hibernation attempt fails
Message-Id: <20090422131943.69288af3.akpm@linux-foundation.org>
In-Reply-To: <200904222211.18221.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090420163734.b8e24fc9.akpm@linux-foundation.org>
	<20090422130705.GA16186@elf.ucw.cz>
	<200904222211.18221.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 22:11:17 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 22 April 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > Of course, this will protect the calling task from getting oom-killed. 
> > > But it doesn't protect other tasks from getting oom-killed due to the
> > > activity of _this_ task.
> > > 
> > > But I think that problem already exists, and that this proposal doesn't
> > > worsen anything, yes?
> > > 
> > > Or is it the case that all other tasks are safely stuck in the freezer
> > > at this time, so they won't be allocating any memory anyway?
> > 
> > That is the idea, yes. ... but we now have more threads that are not
> > freezable... so they may allocate the memory.
> > 
> > Is it non-feasible to free memory without really going and allocating
> > everything?
> 
> The question is whether there is a point.  In principle we can just go and
> allocate as much as we need upfront.  It shouldn't change anything, because
> we resume and suspend devices after creating the image anyway.
> 
> I think we could try to disable the OOM killer before suspend and just
> allocate the memory for the image right before devices are suspended for the
> first time.
> 

It would be nice to do.

shrink_all_memory() is simply trying to do something which page reclaim
doesn't expect to do (free memory when there's already lots of memory
free).  Consequently it doesn't do it very well, and there's a good
risk that changes to core reclaim will accidentally break
shrink_all_memory().  

