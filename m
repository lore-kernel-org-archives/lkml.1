Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbZCZTta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbZCZTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758436AbZCZTtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:49:21 -0400
Received: from vena.lwn.net ([206.168.112.25]:51396 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291AbZCZTtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:49:20 -0400
Date: Thu, 26 Mar 2009 13:49:17 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PULL] bkl-removal (fasync stuff)
Message-ID: <20090326134917.350c916d@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

I've got a handful of BKL-removal patches at:

  git://git.lwn.net/linux-2.6.git bkl-removal

These are the much-discussed and much-revised fasync() fixup series.
After this, ->fasync() is no longer called with the BKL held, some
longstanding (minor) races have been closed, and the internal fasync()
API has been cleaned up and made consistent.

Thanks,

jon

Jonathan Corbet (4):
      Rename struct file->f_ep_lock
      Use f_lock to protect f_flags
      Move FASYNC bit handling to f_op->fasync()
      Rationalize fasync return values

 Documentation/filesystems/Locking  |    7 +++++--
 drivers/char/sonypi.c              |    7 +------
 drivers/char/tty_io.c              |    5 ++---
 drivers/gpu/drm/drm_fops.c         |    6 +-----
 drivers/hid/usbhid/hiddev.c        |    5 +----
 drivers/ieee1394/dv1394.c          |    6 +-----
 drivers/input/evdev.c              |    5 +----
 drivers/input/joydev.c             |    5 +----
 drivers/input/mousedev.c           |    5 +----
 drivers/input/serio/serio_raw.c    |    4 +---
 drivers/net/wan/cosa.c             |    4 ++--
 drivers/platform/x86/sony-laptop.c |    7 +------
 drivers/scsi/sg.c                  |    4 +---
 drivers/usb/gadget/file_storage.c  |    7 ++++++-
 fs/eventpoll.c                     |   12 +++++++-----
 fs/fcntl.c                         |   33 ++++++++++++++++++++-------------
 fs/file_table.c                    |    1 +
 fs/ioctl.c                         |   18 ++++--------------
 fs/nfsd/vfs.c                      |    5 ++++-
 fs/pipe.c                          |   16 +++-------------
 include/linux/eventpoll.h          |    1 -
 include/linux/fs.h                 |    2 +-
 ipc/mqueue.c                       |    2 ++
 net/socket.c                       |    7 +++++++
 sound/core/control.c               |    7 ++-----
 sound/core/oss/pcm_oss.c           |    2 ++
 sound/core/pcm_native.c            |    4 +---
 sound/core/timer.c                 |    6 +-----
 sound/oss/au1550_ac97.c            |    2 ++
 sound/oss/audio.c                  |    2 ++
 sound/oss/sh_dac_audio.c           |    2 ++
 sound/oss/swarm_cs4297a.c          |    2 ++
 sound/oss/vwsnd.c                  |    2 ++
 33 files changed, 90 insertions(+), 113 deletions(-)
