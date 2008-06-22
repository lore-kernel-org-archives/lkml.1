Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYFVW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYFVW2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbYFVW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:28:23 -0400
Received: from bu3sch.de ([62.75.166.246]:56314 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015AbYFVW2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:28:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Oops when using growisofs
Date: Mon, 23 Jun 2008 00:28:20 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>
References: <200806221818.24372.mb@bu3sch.de> <200806222322.05706.arnd@arndb.de> <200806230005.51356.mb@bu3sch.de>
In-Reply-To: <200806230005.51356.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806230028.20643.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 00:05:51 Michael Buesch wrote:
> > Note: r9 and r3 are both NULL pointers. r3 is the value returned from alloc_page_buffers.
> > R9 is a copy of that, which gets accessed.
> 
> Hm, yeah. I looked at that code already, but I can't see how it could return
> a NULL pointer.

Well, actually, it can return a NULL pointer.

 928         head = NULL;
 929         offset = PAGE_SIZE;
 930         while ((offset -= size) >= 0) {
...
 949         }
 950         return head;

So if size, which is a passed in as parameter, is > PAGE_SIZE it will return NULL.

The size parameter is calculated by doing
blocksize = 1 << inode->i_blkbits;
in an earlier function in the callchain.

So, well. I dunno what i_blkbits is. There's no docs in struct inode.

-- 
Greetings Michael.
