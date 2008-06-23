Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbYFWGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbYFWGfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 02:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFWGf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 02:35:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751260AbYFWGf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 02:35:26 -0400
Date: Sun, 22 Jun 2008 23:34:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@ucw.cz>
Subject: Re: Oops when using growisofs
Message-Id: <20080622233448.4b27c131.akpm@linux-foundation.org>
In-Reply-To: <200806230028.20643.mb@bu3sch.de>
References: <200806221818.24372.mb@bu3sch.de>
	<200806222322.05706.arnd@arndb.de>
	<200806230005.51356.mb@bu3sch.de>
	<200806230028.20643.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 00:28:20 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> On Monday 23 June 2008 00:05:51 Michael Buesch wrote:
> > > Note: r9 and r3 are both NULL pointers. r3 is the value returned from alloc_page_buffers.
> > > R9 is a copy of that, which gets accessed.
> > 
> > Hm, yeah. I looked at that code already, but I can't see how it could return
> > a NULL pointer.
> 
> Well, actually, it can return a NULL pointer.
> 
>  928         head = NULL;
>  929         offset = PAGE_SIZE;
>  930         while ((offset -= size) >= 0) {
> ...
>  949         }
>  950         return head;
> 
> So if size, which is a passed in as parameter, is > PAGE_SIZE it will return NULL.
> 
> The size parameter is calculated by doing
> blocksize = 1 << inode->i_blkbits;
> in an earlier function in the callchain.

Yes, that's a more likely scenario.  isofs has a history of passing
garbage into the VFS.

> So, well. I dunno what i_blkbits is. There's no docs in struct inode.

It's log2 of the filesystem blocksize.  It'd be interesting to work out
what value isofs is setting it to, and why.

