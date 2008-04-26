Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYDZV3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYDZV3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYDZV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:28:13 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:47995 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbYDZV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:28:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, alan@lxorguk.ukuu.org.uk, miklos@szeredi.hu,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/8] OMFS filesystem version 5
Date: Sat, 26 Apr 2008 17:26:37 -0400
Message-Id: <1209245205-10096-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks again for the reviews.  Not much changed since version 4,
just addressed a few more concerns raised by Miklos and Marcin.

These patches 1-8 add the Optimized MPEG Filesystem, a proprietary
filesystem used by the embedded devices Rio Karma and ReplayTV, 
which are no longer manufactured.  This filesystem module enables 
people to access files on these devices. 

version 5:
 - fix buffer leak in omfs_fill_super
 - fix inode leak in omfs_create/_mkdir, and combine them
 - switch to bitmap_weight instead of repeated hweight64()
 - switch to get_bitmask_order instead of open-coded version
 - clean up some error branching & label names 

version 4:
 - rebased against 2.6.25-mm1
 - converted prepare/commit_write to write_begin/_end
 - killed leaks in the error paths of inode.c and dir.c
 - split out data structures from omfs.h into omfs_fs.h
 - dropped checksum.c and moved its method into inode.c
 - added sanity checks on block numbers read from superblock
 - added missing rename implementation
 - added uid/umask mount options
 - documented the basic FS usage & updated MAINTAINERS

version 3:
 - fixed sparse warnings
 - added more sanity checking in list traversals

version 2:
 - removed private inode cache 
 - included GPL v2 notice
 - rewrote omfs_count_free to use hamming weight library functions 
 - removed duplicated crc-itu-t

Version 1: initial post

