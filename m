Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZDVUM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZDVUM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZDVUMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:12:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36175 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbZDVUMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:12:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [Bug #13058] First hibernation attempt fails
Date: Wed, 22 Apr 2009 22:11:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       jens.axboe@oracle.com, alan-jenkins@tuffmail.co.uk,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090420163734.b8e24fc9.akpm@linux-foundation.org> <20090422130705.GA16186@elf.ucw.cz>
In-Reply-To: <20090422130705.GA16186@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904222211.18221.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 April 2009, Pavel Machek wrote:
> Hi!
> 
> > Of course, this will protect the calling task from getting oom-killed. 
> > But it doesn't protect other tasks from getting oom-killed due to the
> > activity of _this_ task.
> > 
> > But I think that problem already exists, and that this proposal doesn't
> > worsen anything, yes?
> > 
> > Or is it the case that all other tasks are safely stuck in the freezer
> > at this time, so they won't be allocating any memory anyway?
> 
> That is the idea, yes. ... but we now have more threads that are not
> freezable... so they may allocate the memory.
> 
> Is it non-feasible to free memory without really going and allocating
> everything?

The question is whether there is a point.  In principle we can just go and
allocate as much as we need upfront.  It shouldn't change anything, because
we resume and suspend devices after creating the image anyway.

I think we could try to disable the OOM killer before suspend and just
allocate the memory for the image right before devices are suspended for the
first time.

Thanks,
Rafael
