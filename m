Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZI2FBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZI2FBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZI2FBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1263 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZI2FBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:10 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com
Subject: [PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and use it
Date: Mon, 28 Sep 2009 22:01:02 -0700
Message-Id: <cover.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes an x86 defconfig smaller compiled with gcc 4.4 smaller too

old:
$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
6981105	 678300	1359668	9019073	 899ec1	vmlinux

new:
$ size vmlinux
   text	   data	    bss	    dec	    hex	filename
6980770	 678380	1359668	9018818	 899dc2	vmlinux

Joe Perches (9):
  lib/vsprintf.c: Add %pU to print UUID/GUIDs
  efi.h: Use %pUr to print UUIDs
  random.c: Use %pU to print UUIDs
  drivers/firmware/dmi_scan.c: Use %pUX to print UUIDs
  drivers/md/md.c: Use %pU to print UUIDs
  drivers/media/video/uvc: Use %pUr to print UUIDs
  fs/gfs2/sys.c: Use %pUX to print UUIDs
  fs/ubifs: Use %pUX to print UUIDs
  fs/xfs/xfs_log_recover.c: Use %pU to print UUIDs

 drivers/char/random.c                |   10 +---
 drivers/firmware/dmi_scan.c          |    5 +--
 drivers/md/md.c                      |   16 ++------
 drivers/media/video/uvc/uvc_ctrl.c   |   69 ++++++++++++++++------------------
 drivers/media/video/uvc/uvc_driver.c |    7 +--
 drivers/media/video/uvc/uvcvideo.h   |   10 -----
 fs/gfs2/sys.c                        |   16 +------
 fs/ubifs/debug.c                     |    9 +---
 fs/ubifs/super.c                     |    7 +---
 fs/xfs/xfs_log_recover.c             |   14 ++-----
 include/linux/efi.h                  |    6 +--
 lib/vsprintf.c                       |   58 ++++++++++++++++++++++++++++-
 12 files changed, 111 insertions(+), 116 deletions(-)

