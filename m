Return-Path: <linux-kernel-owner+w=401wt.eu-S965834AbXG3QZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965834AbXG3QZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938820AbXG3QPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:15:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765511AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:23 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 00/26] VFS based Union Mount (V2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is another post of the VFS based union mount implementation. Unlike the
traditional mount which hides the contents of the mount point, union mounts
present the merged view of the mount point and the mounted filesytem.

Recent changes:
- brand new union structure no longer tied to the dentryn, now works with bind
  mounts
- generic part of the whiteout patches extracted
- introduces MS_WHITEOUT to make the white-out patches independant of the
  union-mount stuff
- uses a singleton whiteout inode for the tmpfs filesystem (I need to fix this
  for ext2/3, too)
- renaming files on unions uses copyup now
- rewrote the union mount debugging code: it is now debugfs/relay based.
- random cleanups

I'm able to compile the kernel with this patches applied on a  3 layer union
mount with the seperate layers bind mounted to different locations. I haven't
done any performance tests since I think there is a more important topic
ahead: better readdir() support.

This series is against 2.6.22-rc6-mm1.

Comments are welcome,
Jan

-- 

