Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbZDBO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbZDBO4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDBO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:56:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbZDBO4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:56:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200904030100.05741.nickpiggin@yahoo.com.au>
References: <200904030100.05741.nickpiggin@yahoo.com.au> <20090401230321.28177.12010.stgit@warthog.procyon.org.uk> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>, hch@infradead.org
Cc: dhowells@redhat.com, viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Date: Thu, 02 Apr 2009 15:55:53 +0100
Message-ID: <5564.1238684153@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> > Hook the Ext2 and Ext3 operations to the generic implementation.
> 
> Is this really worthwhile?

I seem to remember being told that I'm not allowed to call such directly (by
Christoph Hellwig perhaps?), and that I should add an address space op to do
this.

> What do you do that write_begin/write_end doesn't?

This code calls write_begin() and write_end().

write_begin() and write_end() don't actually update the target page, and don't
so the osync stuff.

My code assumed file can be passed as NULL to write_begin() and write_end().
If file is, however, necessary then the backing fs can do something different.
cachefiles doesn't know.

Creating loads of file structs gives you ENFILE problems if you start opening
lots of files internally.  This caused lots of argument when I proposed a
patch to allow the kernels to open files not on account.

I'm quite happy to ditch the extra address space op and put this code in
cachefiles itself.  Doing it there would perhaps allow me to handle multiple
pages more easily.

> I have a patch around somewhere enable splice stealing into the pagecache
> with write_begin/write_end if you are worried about the copy.

I'm not sure what you mean.

> But how about you put this at the end of the series justified with some
> numbers?

I don't see how that helps.  cachefiles has to do something to get the data
out.

David
