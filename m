Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYANVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYANVOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYANVOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:14:06 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56857 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYANVOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:14:04 -0500
Date: Mon, 14 Jan 2008 23:13:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>, zippel@linux-m68k.org
Cc: linux-kernel@vger.kernel.org
Subject: fs/hfs/btree.c: new NULL dereference
Message-ID: <20080114211305.GI9847@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following NULL dereference introduced 
by commit cf0594625083111ae522496dc1c256f7476939c2:

<--  snip  -->

...
struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id, btree_keycmp keycmp)
{
...
        if (!tree->inode)
                goto free_tree;
...
 free_tree:
        tree->inode->i_mapping->a_ops = &hfs_aops;
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

