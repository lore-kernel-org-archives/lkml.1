Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbYDNSYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbYDNSYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbYDNSXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:23:10 -0400
Received: from rtr.ca ([76.10.145.34]:4925 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbYDNSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:23:07 -0400
Message-ID: <4803A109.5080800@rtr.ca>
Date: Mon, 14 Apr 2008 14:23:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ext3: Freeing blocks not in datazone 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of my test systems here, running 2.6.25-rc8-git*,
just now crapped out with this in the tail end of dmesg:

[   20.927780] EXT3-fs error (device sda1): ext3_free_blocks: Freeing blocks not in datazone - block
[   20.928756] Aborting journal on device sda1.
[    7.336461] ext3_abort called.
[   20.930208] Remounting filesystem read-only
[    7.336925] EXT3-fs error (device sda1): ext3_journal_start_sb: Detected aborted journal
[    7.336930] Remounting filesystem read-only
[   20.930847] EXT3-fs error (device sda1) in ext3_reserve_inode_write: Journal has aborted
[   20.930960] EXT3-fs error (device sda1) in ext3_truncate: Journal has aborted
[   20.931037] EXT3-fs error (device sda1) in ext3_reserve_inode_write: Journal has aborted
[   20.931148] EXT3-fs error (device sda1) in ext3_orphan_del: Journal has aborted
[   20.931257] EXT3-fs error (device sda1) in ext3_reserve_inode_write: Journal has aborted
[   20.932057] __journal_remove_journal_head: freeing b_committed_data
[   20.932071] __journal_remove_journal_head: freeing b_committed_data
[   20.932165] __journal_remove_journal_head: freeing b_committed_data
[   20.932185] __journal_remove_journal_head: freeing b_committed_data
[   20.932197] __journal_remove_journal_head: freeing b_committed_data

I had just booted the system, and was simultaneously doing "rm -r" on an old kernel tree
while also doing mirrordir to refressh a different kernel tree from a master copy off NFS.

Not much else to say.  e2fsck seems to have recovered things,
and I've repeated the commands successfully after rebooting.

-ml
