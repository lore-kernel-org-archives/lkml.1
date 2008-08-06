Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYHFR6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYHFR6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 13:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYHFR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 13:58:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37497 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYHFR6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 13:58:44 -0400
Date: Wed, 6 Aug 2008 10:54:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.25.15
Message-ID: <20080806175457.GA27119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.25.15
kernel.

It contains lots of bugfixes, all over the map.  Any users of the 2.6.25
kernel series should upgrade to this version.  For details on the fixes,
see the changelog entries and the diffstat below.

I'll also be replying to this message with a copy of the patch between
2.6.25.14 and 2.6.25.15

The updated 2.6.25.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.25.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=summary

thanks,

greg k-h

-------------

 Makefile                              |    2 
 arch/powerpc/kernel/ppc32.h           |    2 
 arch/powerpc/kernel/ptrace32.c        |   27 ++++++++++
 arch/x86/mm/ioremap.c                 |    5 +
 drivers/acpi/bay.c                    |   16 +++--
 drivers/acpi/thermal.c                |   16 +++++
 drivers/input/mouse/appletouch.c      |   49 +++++++++++++++---
 drivers/input/serio/i8042-x86ia64io.h |   57 +++++++++++++++++----
 drivers/input/serio/i8042.c           |    8 ++
 drivers/net/wireless/ath5k/base.c     |    4 +
 drivers/pci/quirks.c                  |    1 
 drivers/ps3/ps3-lpm.c                 |    1 
 drivers/scsi/megaraid/megaraid_mbox.c |   17 ++++++
 drivers/scsi/megaraid/megaraid_mbox.h |    1 
 drivers/usb/core/quirks.c             |    3 +
 drivers/usb/host/ehci-hub.c           |    6 +-
 drivers/usb/host/ehci.h               |    2 
 fs/fat/inode.c                        |    2 
 fs/jbd/commit.c                       |   19 +------
 fs/jbd/transaction.c                  |   91 ++++++++++++++++++++++++++++++++--
 fs/namei.c                            |   31 +++++++++--
 fs/nfs/inode.c                        |    4 -
 fs/nfs/internal.h                     |    1 
 fs/nfs/nfs3acl.c                      |    9 ++-
 fs/nfs/nfs4proc.c                     |    6 +-
 fs/partitions/msdos.c                 |   20 ++++++-
 fs/romfs/inode.c                      |   37 ++++++++-----
 include/linux/msdos_fs.h              |    6 +-
 include/sound/ac97_codec.h            |    1 
 include/sound/emu10k1.h               |    1 
 mm/filemap.c                          |    3 -
 net/bluetooth/bnep/core.c             |    5 +
 net/bluetooth/hidp/core.c             |   10 +++
 sound/core/init.c                     |   36 +++++--------
 sound/core/oss/mixer_oss.c            |    2 
 sound/core/seq/oss/seq_oss_synth.c    |    3 +
 sound/pci/ac97/ac97_patch.c           |   48 ++++++++++++-----
 sound/pci/emu10k1/emu10k1_main.c      |    1 
 sound/pci/emu10k1/emumixer.c          |   13 +++-
 sound/pci/hda/patch_analog.c          |   33 ++++++++----
 sound/usb/usbaudio.c                  |   35 +++++++++----
 sound/usb/usbquirks.h                 |   75 ++++++++++++++--------------
 42 files changed, 524 insertions(+), 185 deletions(-)

Al Viro (1):
      return to old errno choice in mkdir() et.al.

Alan Stern (1):
      USB: EHCI: fix remote-wakeup regression

Andreas Schwab (1):
      Add compat handler for PTRACE_GETSIGINFO

Andrew Morton (1):
      FAT_VALID_MEDIA(): remove pointless test

Arjan van de Ven (1):
      ACPI: Reject below-freezing temperatures as invalid critical temperatures

FUJITA Tomonori (1):
      POWERPC: PS3: Add time include to lpm

Frank Seidel (1):
      fat: detect media without partition table correctly

Greg Kroah-Hartman (1):
      Linux 2.6.25.15

Hannes Reinecke (1):
      SCSI: megaraid_mbox: fix Dell CERC firmware problem

Holger Macht (1):
      bay: exit if notify handler cannot be installed

Ingo Molnar (1):
      x86: ioremap of 64-bit resource on 32-bit kernel fix

Jiri Kosina (6):
      Input: i8042 - retry failed CTR writes when resuming
      Input: i8042 - add Intel D845PESV to nopnp list
      Input: i8042 - add Gericom Bellagio to nomux blacklist
      Input: i8042 - add Fujitsu-Siemens Amilo Pro V2030 to nomux table
      Input: i8042 - add Fujitsu-Siemens Amilo Pro 2010 to nomux list
      Input: i8042 - add Acer Aspire 1360 to nomux blacklist

Josef Bacik (2):
      jbd: fix the way the b_modified flag is cleared
      jbd: fix possible journal overflow issues

Linus Torvalds (1):
      romfs_readpage: don't report errors for pages beyond i_size

Luis R. Rodriguez (1):
      ath5k: Use software encryption for now

Marcel Holtmann (1):
      Bluetooth: Signal user-space for HIDP and BNEP socket errors

Miklos Szeredi (1):
      vfs: fix lookup on deleted directory

Mingming Cao (1):
      jbd: fix race between free buffer and commit transaction

Oliver Neukum (1):
      Input: appletouch - implement reset-resume logic

Takashi Iwai (6):
      ALSA: ac97 - Fix ASUS A9T laptop output
      ALSA: Add more fallbacks to OSS PHONEOUT mixer map
      ALSA: emu10k1 - Fix inverted Analog/Digital mixer switch on Audigy2
      ALSA: Fix Oops with usb-audio reconnection
      ALSA: hda - Add missing Thinkpad Z60m support
      ALSA: hda - Fix wrong volumes in AD1988 auto-probe mode

Tejun Heo (1):
      pci: VT3336 can't do MSI either

Trond Myklebust (1):
      NFS: Ensure we zap only the access and acl caches when setting new acls

Willy Tarreau (1):
      sound: ensure device number is valid in snd_seq_oss_synth_make_info

Zhang, Rui (1):
      ACPI: update thermal temperature

