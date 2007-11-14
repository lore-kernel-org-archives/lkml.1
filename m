Return-Path: <linux-kernel-owner+w=401wt.eu-S1765102AbXKNXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765102AbXKNXvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763627AbXKNXvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:51:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763116AbXKNXvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:51:24 -0500
Message-ID: <473B89F9.7070204@redhat.com>
Date: Wed, 14 Nov 2007 18:51:21 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Repeated oopses with inode == 0xffffffff in 2.6.23
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What does it mean when a pointer to an inode has a value of -1?

https://bugzilla.redhat.com/show_bug.cgi?id=334181


/usr/src/debug/kernel-2.6.22/linux-2.6.22.x86_64/block/ll_rw_blk.c:3139
ffffffff8110854e:       48 8b 45 10             mov    0x10(%rbp),%rax
ffffffff81108552:       48 8b 40 08             mov    0x8(%rax),%rax
ffffffff81108556:       48 8b 40 68             mov    0x68(%rax),%rax

       maxsector = bio->bi_bdev->bd_inode->i_size >> 9;

bd_inode == -1

-----------

rw_verify_area+0x24/0x7e

inode == -1 again


------- Additional Comments From cebbert@redhat.com  2007-11-14 18:39 EST -------
fs/dnotify.c:46:

        inode = filp->f_path.dentry->d_inode;
===>    if (!S_ISDIR(inode->i_mode))
                return;

inode is -1 again


