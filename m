Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbYLLFZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbYLLFZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 00:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbYLLFZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 00:25:08 -0500
Received: from kroah.org ([198.145.64.141]:36971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbYLLFZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 00:25:05 -0500
Date: Thu, 11 Dec 2008 21:19:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Jake Edge <jake@lwn.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       Chuck Wolber <chuckw@quantumlinux.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 00/83] 2.6.27.9-stable review
Message-ID: <20081212051955.GA9024@kroah.com>
References: <20081211191014.GA5759@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 11:10:14AM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.27.9 release.
> There are 83 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 
> These patches are sent out with a number of different people on the Cc:
> line.  If you wish to be a reviewer, please email stable@kernel.org to
> add your name to the list.  If you want to be off the reviewer list,
> also email us.
> 
> Responses should be made by December 13, 2008, 20:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc1.gz
> and the diffstat can be found below.

Well, -rc1 had a build error in it that I missed, so I dropped one
patch, and added 2 more that had come in.

So there is now a -rc2 at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.9-rc2.gz

and the diffstat is down below.

thanks,

greg k-h

 Makefile                              |    2 +-
 arch/powerpc/kernel/cpu_setup_44x.S   |    1 +
 arch/powerpc/kernel/cputable.c        |    3 +
 arch/powerpc/platforms/cell/smp.c     |   10 +-
 arch/powerpc/platforms/pseries/smp.c  |   13 +-
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
 fs/xfs/xfs_rename.c                   |    2 +-
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
 62 files changed, 1019 insertions(+), 238 deletions(-)
