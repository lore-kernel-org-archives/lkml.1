Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXLDVBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXLDVBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXLDVBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:01:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57153 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXLDVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:01:08 -0500
Date: Tue, 4 Dec 2007 15:57:40 -0500
From: Chris Mason <chris.mason@oracle.com> (by way of Chris Mason
	<chris.mason@oracle.com>)
To: btrfs-devel@oss.oracle.com, btrfs-announce@oss.oracle.com
Message-ID: <20071204155740.0c63bc3e@think.oraclecorp.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [ANNOUNCE] Btrfs v0.9
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I've just tagged and released Btrfs v0.9.  Special thanks to Yan Zheng
and Josef Bacik for their work.

This release includes a number of disk format changes from v0.8 and
also a small change from recent btrfs-unstable HG trees.  So, if you
have existing Btrfs filesystems, you will need to backup, reformat and
restore to try out v0.9.

You can find download links and other details here:

http://oss.oracle.com/projects/btrfs/

Since v0.8:

* Support for btree blocks larger than the page size.  mkfs.btrfs
defaults to 8k blocks, but -l and -n can be used to set the block size
for leaves and nodes.  Powers of 2 are required, example:

mkfs.btrfs -l 32768 -n 32768 /dev/xxxx

* Support for inline (packed into the btree) file data larger than the
page size.  Any file smaller than a btree block will probably be backed
into the btree.

* Xattr support (no ACLs yet) from Josef Bacik.  This works for generic
user xattrs and was tested with beagle among other things.

* Stripe size parameter to mkfs.btrfs (-s size_in_bytes).  Extents will
be aligned to the stripe size for performance.

* Many performance and stability fixes, especially on 32 bit x86
machines.

Unfixed:

ENOSPC handling.  Things are much more predicable now, and
Btrfs will work up until the disk is very close to full.

Concurrency: Everything is still protected by a single mutex, which is
held during IO.  Multi-threaded benchmarks will not perform well.

Database performance: Still very slow in database workloads.

You can get an idea of where Btrfs is headed from the TODO list:

http://oss.oracle.com/projects/btrfs/dist/documentation/todo.html

-chris
