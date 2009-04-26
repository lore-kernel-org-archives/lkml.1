Return-Path: <linux-kernel-owner+w=401wt.eu-S1753282AbZDZGgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbZDZGgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 02:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZDZGgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 02:36:16 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40363 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZDZGgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 02:36:16 -0400
Date: Sun, 26 Apr 2009 08:36:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Haskins <ghaskins@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Crash in v2.6.30-rc3 (regression from 30-rc2)
Message-ID: <20090426063615.GO4593@kernel.dk>
References: <49EFD2A4.6080801@novell.com> <20090422222031.17d9d72e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422222031.17d9d72e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22 2009, Andrew Morton wrote:
> On Wed, 22 Apr 2009 22:29:56 -0400 Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > Hi All,
> > 
> >  FYI: I am seeing this when moving from 30-rc2 to 30-rc3 on a 4-way
> > x86_64 box.
> > 
> > I have since reverted back to rc2, but can easily spin up the new kernel
> > again to decode more info or try a fix, if desired.
> > 
> > One data point I do have is that the box seemed to have booted when I
> > forgot to add console=ttyS0 to the kernel args.  I suspect the serial
> > console is just changing timing, but its 100% reproducible in this setup.
> > 
> > BUG: unable to handle kernel NULL pointer dereference at (null)
> > IP: [<ffffffff803863f8>] rb_erase+0x132/0x28c
> > PGD 13a11e067 PUD 13dd1d067 PMD 0
> > Oops: 0000 [#1] SMP
> > last sysfs file:
> > /sys/devices/pci0000:00/0000:00:1f.1/host6/target6:0:0/6:0:0:0/type
> > CPU 0
> > Modules linked in: i5000_edac shpchp rtc_core soundcore thermal sr_mod
> > parport_pc processor button libphy natsemi cdrom i2c_core edac_core
> > parport snd_page_alloc pcspkr serio_raw pci_hotplug rtc_lib kvm_intel sg
> > joydev kvm usbhid hid linear ehci_hcd uhci_hcd sd_mod crc_t10dif usbcore
> > dm_snapshot edd fan thermal_sys hwmon dm_mod ext3 mbcache jbd
> > ide_pci_generic piix ide_core ata_generic ata_piix ahci libata scsi_mod
> > Pid: 1561, comm: vgchange Not tainted 2.6.30-rc3-vbus #30 Precision
> > WorkStation 490   
> > RIP: 0010:[<ffffffff803863f8>]  [<ffffffff803863f8>] rb_erase+0x132/0x28c
> 
> I believe this is being worked on over in the thread titled "[BUG]
> rbtree bug with mmotm 2009-04-14-17-24".

It is, it is also fixed and in -git since yesterday (or friday, I
forget). The commit is:

3ac6c9f8a66726745136e46f63600550c3eb6cec

-- 
Jens Axboe

