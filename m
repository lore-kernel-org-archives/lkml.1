Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbYKQRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbYKQRog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYKQRoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:44:11 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:39041 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYKQRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:44:09 -0500
Date: Mon, 17 Nov 2008 12:44:01 -0500
From: "Jeffrey J. Kosowsky" <linux-kernel@kosowsky.org>
Subject: NFS directory corruption with Ext3 but not Ext2 (in older   embedded
 kernel)
To: linux-kernel@vger.kernel.org
Message-id: <18721.44385.649149.611080@consult.pretender>
MIME-version: 1.0
X-Mailer: VM 8.0.11 under Emacs 22.1.1 (i386-redhat-linux-gnu)
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have encountered the following interaction issue between NFS and
Ext3 (but not Ext2) on an embedded 2.6.12.6 kernel (yes, I know it is
old but I can't upgrade it because of hardware interface issues).

Problem:
When accessing files from the NFS client, various files and
subdirectories on the NFS mount randomly seem to disappear, resulting
in errors when either they or their parent directory is listed.

Specifically, I repeatedly find that after some mildly intensive
directory access operations (e.g. ls'ing several large directories or
using find on root), that subsequent file or directory access
operations to the same directories return file/directory access areas
on a subset of their contents. Thus "chunks" of the NFS filesystem
seem to randomly be dropped.

- This behavior persists until either the NFS server is restarted or
  until the same file/directory is accessed from the NFS
  server. Remounting the NFS share does not fix the problem.

- Note that at all times the files/directories remain accessible from
  the NFS server under the normal ext3 (or ext2) filesystem.

- The timing and selection of which files "disappear" appears to be
  random, though once a file is inaccessible, it stays that way until
  its presence is reset as above.

- This behaviour only occurs when the partition is mounted as ext3 but
  not as ext2. Also, it only happens with kernel-space nfsd (not with
  user-space unfsd).

- Changing the various nfs settings such as turning on/off caching,
  changing the rsize/wsize, using sync vs. async or hard vs. soft have
  no effect.

- There doesn't seem to be any (permanent) filesystem corruption
  except as a direct side effect of NFS-client side programs
  potentially operating on missing files/directories.

To my layman's eyes, this behavior suggests that there is something
wrong with how ext3 is caching (or marking as cached) directory/file
lookups and sharing this information with other kernel processes (like
nfsd) requiring access to the filesystem directory.

Has anybody seen this problem before and if so is it possible to
fix/patch?

Again, I can't upgrade the kernel because of compatibility with the
embedded hardware.

Thanks!
