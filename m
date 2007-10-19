Return-Path: <linux-kernel-owner+w=401wt.eu-S933397AbXJSNmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397AbXJSNmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbXJSNmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:42:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:50131 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757513AbXJSNmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:42:33 -0400
Date: Fri, 19 Oct 2007 15:43:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: fs/buffer.c:nobh_write_end(): NULL dereference
Message-ID: <20071019134300.GA3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 03158cd7eb3374843de68421142ca5900df845d9 introcduced the 
following NULL dereference:

<--  snip  -->

...
int nobh_write_end(struct file *file, struct address_space *mapping,
                        loff_t pos, unsigned len, unsigned copied,
                        struct page *page, void *fsdata)
{
        struct inode *inode = page->mapping->host;
        struct buffer_head *head = NULL;
        struct buffer_head *bh;

        if (!PageMappedToDisk(page)) {
                if (unlikely(copied < len) && !page_has_buffers(page))
                        attach_nobh_buffers(page, head);
...                                               ^^^^

<--  snip  -->

Spotted by the Coverity checker.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

