Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYLPOs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYLPOs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYLPOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:48:16 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:18001 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754905AbYLPOsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:48:15 -0500
Message-ID: <4947BFAA.4030208@panasas.com>
Date: Tue, 16 Dec 2008 16:48:10 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/9] exofs (was osdfs)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 14:46:43.0463 (UTC) FILETIME=[1CC77170:01C95F8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exofs an OSD based file system.

Whats new since RFC:
First - The name. As Jeff suggested osdfs is too generic a name, for any
particular OSD file system. So Avishay Traeger decided he would like to
call it: exofs - extended object file system. Which credits it's ext2
origin.

2nd - Move to .write_begin/.write_end from the old .prepare_write/.commit_write.
that were just removed in 2.6.28-rc1 Kernel.

3rd - Use of the new osd_req_decode_sense() API to only ignore read errors
when we expect them, i.e. read passed end of objects. (This used to work
with the old IBM initiator)

4th - Fix a NUL-terminate bug with symlinks
5th - file_fsync does not work properly for none-block-dev filesystems
so open code that in an exofs_fsync.

6th - Linux's default for .flush, called at file close, is to do nothing.
We don't like that, specially for networked osd (iscsi) so implement
exofs_flush by calling above exofs_fsync

This patchset is dependent on the open-osd initiator library, that must
get accepted first into Linux.
(git://git.open-osd.org/linux-open-osd.git linux-next)

Andrew Al?
Please, who is the maintainer that such a filesystem should go through?

Our intention with exofs is to make it exportable by Linux
pNFS server, as reference implementation for pNFS-object-layout
server. A pNFS-objects client implementation is also in the works
(See all about pNFS in Linux at:
http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design)

exofs was originally developed by Avishay Traeger <avishay@gmail.com>
from IBM. A very old version of it is hosted on sourceforge as the osdfs
project. The Original code was based on ext2 of the 2.6.10 Kernel and ran
over the old IBM's osd-initiator Linux driver.

Since then it was picked by us, open-osd, and was both forward ported to
current Kernel, as well as converted to run over our osd Kernel Library.

I have mechanically divided the code in parts, each introducing a
group of vfs function vectors, all tied at the end into a full filesystem.
Each patch can be compiled but it will only run at the very end.
This was done for the hope of easier reviewing.

Here is the list of patches
[PATCH 1/9] exofs: osd Swiss army knife
[PATCH 2/9] exofs: file and file_inode operations
[PATCH 3/9] exofs: symlink_inode and fast_symlink_inode operations
[PATCH 4/9] exofs: address_space_operations
[PATCH 5/9] exofs: dir_inode and directory operations
[PATCH 6/9] exofs: super_operations and file_system_type
[PATCH 7/9] exofs: mkexofs
[PATCH 8/9] exofs: Documentation
[PATCH 9/9] fs: Add exofs to Kernel build

This patchset is also available on:
  git-clone git://git.open-osd.org/linux-open-osd.git linux-next-exofs
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next-exofs

(Above tree is based on Linus 2.6.28.rc8-cefb3d0. A branch based on scsi-misc
 is also present see osd && osd-exofs branches)

If anyone wants to actually run this code and test it
then please start at: http://open-osd.org
and also the exofs.txt file in patch 8/9 should help

Thank you for the review
Boaz



