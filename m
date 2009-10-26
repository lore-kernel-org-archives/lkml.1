Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZJZGyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZJZGyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbZJZGyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:54:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:52840 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZJZGyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:54:04 -0400
Date: Sun, 25 Oct 2009 23:55:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091025235508.7f5438e6@infradead.org>
In-Reply-To: <20091025230321.aa4f26a1.akpm@linux-foundation.org>
References: <20091025225342.007138f5@infradead.org>
	<20091025230321.aa4f26a1.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 23:03:21 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > ...
> >
> > @@ -1071,6 +1072,8 @@ void __mark_inode_dirty(struct inode *inode,
> > int flags) if ((inode->i_state & flags) == flags)
> >  		return;
> >  
> > +	trace_dirty_inode(inode, current);
> > +
> >  	if (unlikely(block_dump))
> >  		block_dump___mark_inode_dirty(inode);
> >  
> 
> Doesn't powertop also want to know who is spinning up the disk via
> buffered reads, direct-io reads and direct-io writes?
> 
> That's why the block_dump hook in submit_bio() is there.

there is already an existing trace event for this in the block layer...
I was planning to use block_bio_queue for this.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
