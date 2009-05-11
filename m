Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbZEKVp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbZEKVp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZEKVpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:45:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:52243 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510AbZEKVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:45:10 -0400
Date: Mon, 11 May 2009 14:41:06 -0700
From: Greg KH <gregkh@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de, mel@csn.ul.ie,
       a.p.ziljstra@chello.nl, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, san@android.com, arve@android.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11 -mmotm] oom: fix possible oom_dump_tasks NULL
	pointer
Message-ID: <20090511214106.GB22040@suse.de>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com> <20090511141138.3e8118ab.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111418560.466@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905111418560.466@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 02:28:05PM -0700, David Rientjes wrote:
> On Mon, 11 May 2009, Andrew Morton wrote:
> 
> > On Sun, 10 May 2009 15:07:16 -0700 (PDT)
> > David Rientjes <rientjes@google.com> wrote:
> > 
> > > When /proc/sys/vm/oom_dump_tasks is enabled, it is possible to get a NULL
> > > pointer for tasks that have detached mm's since task_lock() is not held
> > > during the tasklist scan.
> > 
> > ok.  But a better changelog would have told us how the patch fixes the
> > problem?
> > 
> 
> Sure, I suppose "Add the task_lock()." could follow it.
> 
> > This patch series is partially core MM and partially drivers/staging. 
> > I don't normally handle staging things, so I'd need to be cherrypicking
> > from this lot.  Is there any interdependency between the two things?
> > 
> 
> This was a source of confusion from me when I posted a smaller set earlier 
> that made the same changes to the staging driver, and the only reason I 
> sent the change here was because drivers/staging/android/lowmemorykiller.c 
> is in Linus' tree.

I have that series in my "to-apply" queue to get through this week.  I
will handle them.

> This patch series moves oomkilladj from struct task_struct to struct 
> mm_struct where it more appropriately belongs.  The Android 
> lowmemorykiller uses oomkilladj, so it will fail to compile in Linus' git 
> if you pushed the patchset to him and the Android driver were enabled.
> 
> To prevent that breakage, they should probably either all go through one 
> series so nothing ever breaks or Greg takes the staging patches and then 
> pushes them when you push the other changes.  I thought the former would 
> be easier for the maintainers (apparently not :).

I think the original lowmemorykiller.c patches have no problem getting
into the tree.  But, it seems that people are still disagreeing with the
core oom changes you have made, so those will probably take a few more
review cycles in order to work themselves out.

I would _really_ like to see the end goal to get this lowmemorykiller
code out of the staging tree, and I think that is what your goal here is
as well.  If, at the end of your series that happens, I think that would
be very good.

thanks,

greg k-h
