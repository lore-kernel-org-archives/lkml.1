Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbZENXN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbZENXN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 19:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762322AbZENW71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:59:27 -0400
Received: from kroah.org ([198.145.64.141]:46263 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762379AbZENW70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:59:26 -0400
Date: Thu, 14 May 2009 15:54:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 00/28] 2.6.27.24-stable review
Message-ID: <20090514225413.GA705@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for the 2.6.27.24 release.
There are 28 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by Saturday, May 16, 20:00:00 UTC.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.24-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

 Documentation/filesystems/Locking |   26 +++--
 Makefile                          |    2 +-
 drivers/i2c/algos/i2c-algo-bit.c  |    2 +-
 drivers/i2c/algos/i2c-algo-pca.c  |   11 ++
 drivers/md/bitmap.c               |   29 ++--
 drivers/md/md.c                   |    7 +-
 drivers/md/raid10.c               |   12 +-
 drivers/net/ehea/ehea_main.c      |   31 +++--
 drivers/serial/mpc52xx_uart.c     |    2 +-
 drivers/usb/gadget/usbstring.c    |    6 +-
 drivers/video/fb_defio.c          |    3 +-
 fs/buffer.c                       |   20 ++-
 fs/cifs/cifs_unicode.h            |    7 +
 fs/cifs/cifssmb.c                 |   17 +--
 fs/cifs/connect.c                 |    6 +-
 fs/cifs/misc.c                    |    5 +-
 fs/cifs/readdir.c                 |    2 +-
 fs/cifs/sess.c                    |   44 +++---
 fs/eventpoll.c                    |    2 +-
 fs/ext4/ext4.h                    |    2 +-
 fs/ext4/inode.c                   |    5 +-
 fs/fcntl.c                        |    6 +-
 fs/fuse/file.c                    |    3 +-
 fs/gfs2/ops_file.c                |    7 +-
 fs/nfs/dir.c                      |    9 +-
 fs/nfs/file.c                     |    9 +-
 fs/nfsd/nfs4xdr.c                 |   16 ++-
 fs/ocfs2/file.c                   |   94 ++++++++++---
 fs/ocfs2/mmap.c                   |    6 +-
 fs/splice.c                       |  276 +++++++++++++++++++++++--------------
 fs/ubifs/file.c                   |    9 +-
 fs/xfs/linux-2.6/xfs_file.c       |    4 +-
 include/linux/buffer_head.h       |    2 +-
 include/linux/mm.h                |    3 +-
 include/linux/splice.h            |   12 ++
 mm/memory.c                       |  132 +++++++++++++-----
 36 files changed, 547 insertions(+), 282 deletions(-)
