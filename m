Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbYLKTLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbYLKTLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbYLKTLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:11:20 -0500
Received: from mx1.suse.de ([195.135.220.2]:33194 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbYLKTLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:11:18 -0500
Date: Thu, 11 Dec 2008 11:10:14 -0800
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
Subject: [patch 00/83] 2.6.27.9-stable review
Message-ID: <20081211191014.GA5759@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 2.6.27.9 release.
There are 83 patches in this series, all will be posted as a response to
this one.  If anyone has any issues with these being applied, please let
us know.  If anyone is a maintainer of the proper subsystem, and wants
to add a Signed-off-by: line to the patch, please respond with it.

These patches are sent out with a number of different people on the Cc:
line.  If you wish to be a reviewer, please email stable@kernel.org to
add your name to the list.  If you want to be off the reviewer list,
also email us.

Responses should be made by December 13, 2008, 20:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc1.gz
and the diffstat can be found below.


thanks,

greg k-h

-----------------

 Makefile                              |    2 +-
 arch/powerpc/kernel/cpu_setup_44x.S   |    1 +
 arch/powerpc/kernel/cputable.c        |    3 +
 arch/powerpc/sysdev/mpic.c            |    9 +-
 arch/sparc/include/asm/uaccess_64.h   |    4 +-
 arch/sparc64/kernel/pci.c             |   10 +-
 arch/sparc64/kernel/ptrace.c          |    2 +-
 arch/sparc64/kernel/visemul.c         |    6 +-
 arch/sparc64/lib/user_fixup.c         |    2 +-
 arch/um/drivers/mconsole_kern.c       |    4 +-
 arch/x86/kernel/hpet.c                |    2 +-
 arch/x86/mm/init_64.c                 |    4 +-
 block/bsg.c                           |    2 +
 block/scsi_ioctl.c                    |    2 +
 drivers/acpi/osl.c                    |   36 ----
 drivers/acpi/sleep/main.c             |   40 ++++-
 drivers/ata/libata-sff.c              |   13 +-
 drivers/edac/cell_edac.c              |    3 +
 drivers/hid/usbhid/hid-quirks.c       |    2 +
 drivers/input/serio/i8042-x86ia64io.h |   29 +++
 drivers/net/cxgb3/adapter.h           |    1 +
 drivers/net/cxgb3/cxgb3_main.c        |    5 +
 drivers/net/cxgb3/l2t.c               |    1 +
 drivers/net/cxgb3/sge.c               |   56 ++----
 drivers/net/niu.c                     |    3 +-
 drivers/net/pppol2tp.c                |    1 +
 drivers/pci/pcie/aspm.c               |   29 +++-
 drivers/pci/slot.c                    |    1 +
 drivers/pnp/base.h                    |    2 +-
 drivers/pnp/quirks.c                  |    2 +-
 drivers/pnp/resource.c                |    4 +-
 drivers/spi/spidev.c                  |    4 +-
 drivers/usb/serial/option.c           |  176 +++++++++++++++---
 drivers/usb/storage/unusual_devs.h    |  334 ++++++++++++++++++++++++++++++--
 fs/binfmt_em86.c                      |    2 +-
 fs/binfmt_misc.c                      |    4 +-
 fs/binfmt_script.c                    |    5 +-
 fs/cifs/connect.c                     |   36 ++--
 fs/exec.c                             |   10 +-
 fs/fcntl.c                            |    7 +
 fs/ioctl.c                            |   12 +-
 fs/jbd/checkpoint.c                   |   49 ++++--
 fs/jbd/journal.c                      |   28 +++-
 fs/jbd/recovery.c                     |    7 +-
 fs/proc/task_mmu.c                    |    4 +-
 include/linux/binfmts.h               |    2 +
 include/linux/blkdev.h                |    1 +
 include/linux/jbd.h                   |    2 +-
 include/linux/pnp.h                   |    6 +-
 kernel/fork.c                         |   15 +-
 kernel/sched.c                        |    8 +-
 net/atm/svc.c                         |    6 +-
 net/ipv4/udp.c                        |   12 +-
 net/ipv6/udp.c                        |    8 +-
 net/unix/af_unix.c                    |    2 +-
 sound/pci/emu10k1/emu10k1_main.c      |    3 +
 sound/pci/hda/hda_proc.c              |    2 +-
 sound/pci/hda/patch_analog.c          |   10 +-
 sound/pci/hda/patch_realtek.c         |  152 +++++++++++++++-
 sound/pci/hda/patch_sigmatel.c        |   45 ++++-
 60 files changed, 1012 insertions(+), 221 deletions(-)
