Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYFYRiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYFYRiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYFYRip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:38:45 -0400
Received: from mail2.shareable.org ([80.68.89.115]:50387 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYFYRio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:38:44 -0400
Date: Wed, 25 Jun 2008 18:38:38 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Message-ID: <20080625173837.GA10005@shareable.org>
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I also really don't think this even fixes the problems you have with 
> FUSE/NFSD - because you'll still be reading zeroes for a truncated file. 
> Yes, you get the rigth counts, but you don't get the right data.
...
> That's "correct" from a splice() kind of standpoint (it's essentially a 
> temporary mmap() with MAP_PRIVATE), but the thing is, it just sounds like 
> the whole "page went away" thing is a more fundamental issue. It sounds 
> like nfds should hold a read-lock on the file while it has any IO in 
> flight, or something like that.

I'm thinking any kind of user-space server using splice() will not
want to transmit zeros either, when another process truncates the file.
E.g. Apache, Samba, etc.

Does this problem affect sendfile() users?

-- Jamie
