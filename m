Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbYJXVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbYJXVo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYJXVn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:43:58 -0400
Received: from kroah.org ([198.145.64.141]:39507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755130AbYJXVn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:43:57 -0400
Date: Fri, 24 Oct 2008 14:38:52 -0700
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       torvalds@linux-foundation.org, Eugene Teo <eteo@redhat.com>,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>
Subject: Re: [stable] [patch 00/27] 2.6.27.4-stable review
Message-ID: <20081024213852.GA20713@kroah.com>
References: <20081024043303.GA30828@kroah.com> <20081024054111.GB17405@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024054111.GB17405@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 10:41:11PM -0700, Greg KH wrote:
> On Thu, Oct 23, 2008 at 09:33:03PM -0700, Greg KH wrote:
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc1.gz
> > and the diffstat can be found below.
> 
> There was a build error in this release, so I've now put up a -rc2
> version at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc2.gz

And there was an error in this release as well, the ath5k patch was
dropped as it was found to cause regressions itself.

Also a pvrusb2 patch was added to let the device work again with the
2.6.27 kernel, which is always a nice thing to have.  I'll follow up
this message with that patch.

I've now put up a -rc3 version at:
	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.27.4-rc3.gz

and the diffstat is below.

thanks,

greg k-h

 Makefile                                       |    2 
 arch/x86/kernel/acpi/sleep.c                   |    3 +
 arch/x86/kernel/amd_iommu_init.c               |    2 
 drivers/acpi/hardware/hwsleep.c                |   37 ++++-----------
 drivers/acpi/sleep/main.c                      |   10 ++++
 drivers/char/hvc_console.c                     |   10 ++--
 drivers/edac/cell_edac.c                       |    2 
 drivers/gpio/gpiolib.c                         |    2 
 drivers/md/dm-kcopyd.c                         |   13 +++++
 drivers/md/dm-snap.c                           |   10 +---
 drivers/media/video/pvrusb2/pvrusb2-hdw.c      |    6 --
 drivers/pci/hotplug/cpqphp_core.c              |    2 
 drivers/scsi/device_handler/scsi_dh_rdac.c     |    2 
 drivers/usb/atm/speedtch.c                     |   12 +++++
 drivers/usb/class/cdc-acm.c                    |    3 -
 drivers/usb/class/cdc-wdm.c                    |    2 
 drivers/usb/core/driver.c                      |    3 -
 drivers/usb/core/hub.c                         |    2 
 fs/cifs/readdir.c                              |    3 -
 fs/ext2/dir.c                                  |   60 ++++++++++++++-----------
 fs/ext3/dir.c                                  |   10 ++--
 fs/ext4/dir.c                                  |   11 +++-
 fs/proc/task_mmu.c                             |   34 +++++++++-----
 kernel/sched_stats.h                           |    2 
 mm/rmap.c                                      |   42 +++++++++++++----
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    1 
 net/netfilter/xt_iprange.c                     |    8 +--
 28 files changed, 184 insertions(+), 112 deletions(-)
