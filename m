Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbZCLP0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbZCLP0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZCLPZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:25:54 -0400
Received: from waste.org ([66.93.16.53]:44037 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbZCLPZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:25:53 -0400
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
From: Matt Mackall <mpm@selenic.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       akpm@linux-foundation.org
In-Reply-To: <20090312125410.25400d18@skybase>
References: <20090312113308.6fe18a93@skybase>
	 <20090312114533.GA2407@x200.localdomain>  <20090312125410.25400d18@skybase>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:23:34 -0500
Message-Id: <1236871414.3213.50.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 12:54 +0100, Martin Schwidefsky wrote:
> On Thu, 12 Mar 2009 14:45:33 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Thu, Mar 12, 2009 at 11:33:08AM +0100, Martin Schwidefsky wrote:
> > > --- linux-2.6/fs/proc/task_mmu.c
> > > +++ linux-2.6-patched/fs/proc/task_mmu.c
> > > @@ -716,7 +716,9 @@ static ssize_t pagemap_read(struct file 
> > >  	 * user buffer is tracked in "pm", and the walk
> > >  	 * will stop when we hit the end of the buffer.
> > >  	 */
> > > +	down_read(&mm->mmap_sem);
> > >  	ret = walk_page_range(start_vaddr, end_vaddr, &pagemap_walk);
> > > +	up_read(&mm->mmap_sem);
> > 
> > This will introduce "put_user under mmap_sem" which is deadlockable.
> 
> Hmm, interesting. In this case the pagemap interface is fundamentally broken.

Well it means we may have to reintroduce the very annoying double
buffering from various earlier implementations. But let's leave this
discussion until after we've figured out what to do about the walker
code.

-- 
http://selenic.com : development and support for Mercurial and Linux


