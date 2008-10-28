Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbYJ1TTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbYJ1TTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJ1TTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:19:37 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20896 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYJ1TTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:19:36 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=kf/23nO5ATJ2EiKFjKN2DY83VOKbOsdHB1MBsVlPi5fl0sJ0MVenr7oWTkJ56QfMB
	uN9SbLnJZ0n7YCoIgKBXg==
Date: Tue, 28 Oct 2008 12:19:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
In-Reply-To: <1225215985.15763.36.camel@lappy.programming.kicks-ass.net>
Message-ID: <alpine.DEB.1.10.0810281219070.30390@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com> <1225215985.15763.36.camel@lappy.programming.kicks-ass.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Peter Zijlstra wrote:

> > @@ -487,6 +488,12 @@ void generic_sync_sb_inodes(struct super_block *sb,
> >                         continue;               /* blockdev has wrong queue */
> >                 }
> >  
> > +               if (!cpuset_intersects_dirty_nodes(mapping, wbc->nodes)) {
> > +                       /* No node pages under writeback */
> > +                       requeue_io(inode);
> > +                       continue;
> > +               }
> 
> So, aside from all the dirty limit and passing node masks around, this
> is the magic bit?
> 
> I totally missed it first time around, a short mention in the changelog
> might not be undeserved.
> 

Added, thanks.
