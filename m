Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbZEKWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbZEKWGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZEKWGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:06:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730AbZEKWGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:06:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xWs9GqHxNAw0X5nU5glQiVHDB6IkkRdlKof91ReUFYXaOFov+bQDofZMxXlqNBGR9
	G+bhhKIlzr7bRCT96Ipng==
Date: Mon, 11 May 2009 15:05:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de, mel@csn.ul.ie,
       a.p.zijlstra@chello.nl, Christoph Lameter <cl@linux-foundation.org>,
       dave@linux.vnet.ibm.com, san@android.com, arve@android.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 05/11 -mmotm] oom: fix possible oom_dump_tasks NULL
 pointer
In-Reply-To: <20090511214106.GB22040@suse.de>
Message-ID: <alpine.DEB.2.00.0905111501480.2234@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101501050.18804@chino.kir.corp.google.com> <20090511141138.3e8118ab.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111418560.466@chino.kir.corp.google.com>
 <20090511214106.GB22040@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Greg KH wrote:

> > This was a source of confusion from me when I posted a smaller set earlier 
> > that made the same changes to the staging driver, and the only reason I 
> > sent the change here was because drivers/staging/android/lowmemorykiller.c 
> > is in Linus' tree.
> 
> I have that series in my "to-apply" queue to get through this week.  I
> will handle them.
> 

Great!

> I think the original lowmemorykiller.c patches have no problem getting
> into the tree.  But, it seems that people are still disagreeing with the
> core oom changes you have made, so those will probably take a few more
> review cycles in order to work themselves out.
> 

Andrew merged a fixed up version of 
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch to -mm so that 
it's not dependent on the earlier lowmemorykiller changes.  I assume the 
merge conflicts will be handled by whoever pushes their changes last.

> I would _really_ like to see the end goal to get this lowmemorykiller
> code out of the staging tree, and I think that is what your goal here is
> as well.

Not really, my only real change to it was making sure it would compile 
when I moved ->oomkilladj from task_struct to mm_struct.  In the course of 
that, I found a possible NULL pointer and coding style problems so I 
thought I'd fix them up as well.  Then Arve posted a couple of patches 
he'd been sitting on, so I added them early on to my series so they'd all 
apply cleanly.

> If, at the end of your series that happens, I think that would
> be very good.
> 

Arve, San, it seems like this driver is still being actively developed 
judging by the patches you sent me.  Any ideas?
