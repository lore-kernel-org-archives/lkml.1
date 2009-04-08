Return-Path: <linux-kernel-owner+w=401wt.eu-S934456AbZDHSlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456AbZDHSlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934551AbZDHSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:41:07 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40308 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667AbZDHSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:41:01 -0400
Date: Wed, 8 Apr 2009 20:43:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, mingo@redhat.com, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] x86: remove dupilcated #include
Message-ID: <20090408184305.GA332@uranus.ravnborg.org>
References: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com> <20090408122121.GB18581@elte.hu> <20090408135803.GA21624@uranus.ravnborg.org> <20090408141228.GD12931@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408141228.GD12931@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > I assume you are aware that when you minimize the # of include 
> > file in the various .c files, then you implicitly add dependency 
> > on the includes the individual .h files have.
> 
> Yes. Look at the commit -tip that does the above change (also 
> attached below):
> 
>   a2bcd47: x86/mm: further cleanups of fault.c's include file section
> 
> that commit uncovered a masked-until-then dependency bug in one of 
> the x86 include files.

We have plenty of header files that needs other header files to be
included in order to build.

I tried to do a simple build check with a i386 defconfig.
It revealed that the appended list of header files did not build.

What I did was to create a simple:

module.h.c file containing:
#include <linux/module.h>

And then I used kbuild to build the file,
adding "obj-y += module.h.o" to Kbuild.

I did so for all header files in include/linux/
and result was that 172 header files failed to build.

Some of these was expected since they are not supposed to be
included direct. But the rest should build have
build with no errors?

I can automate the above included some way to say which header files
we should NOT build.
But eliminating the includes that are not needed is a bigger challenge
and also the biggest win :-(
Is it worthwhile to make the header files buildable alone?

	Sam

include/linux/ac97_codec.h
include/linux/adfs_fs.h
include/linux/adfs_fs_i.h
include/linux/adfs_fs_sb.h
include/linux/arcdevice.h
include/linux/atalk.h
include/linux/ata_platform.h
include/linux/ath9k_platform.h
include/linux/atmel_pwm.h
include/linux/atm_zatm.h
include/linux/bit_spinlock.h
include/linux/bsg.h
include/linux/cgroup_subsys.h
include/linux/chio.h
include/linux/coda_fs_i.h
include/linux/coda_psdev.h
include/linux/compiler-gcc3.h
include/linux/compiler-gcc4.h
include/linux/compiler-gcc.h
include/linux/compiler-intel.h
include/linux/console_struct.h
include/linux/cramfs_fs_sb.h
include/linux/cryptohash.h
include/linux/cyclades.h
include/linux/cycx_drv.h
include/linux/cycx_x25.h
include/linux/dca.h
include/linux/dio.h
include/linux/dirent.h
include/linux/dlm_netlink.h
include/linux/dlm_plock.h
include/linux/dm9000.h
include/linux/eeprom_93cx6.h
include/linux/efs_vh.h
include/linux/elfcore-compat.h
include/linux/eventpoll.h
include/linux/ext2_fs.h
include/linux/ext3_fs.h
include/linux/ext3_fs_i.h
include/linux/ext3_fs_sb.h
include/linux/f75375s.h
include/linux/fault-inject.h
include/linux/fiemap.h
include/linux/filter.h
include/linux/flat.h
include/linux/fscache-cache.h
include/linux/fs_struct.h
include/linux/fs_uart_pd.h
include/linux/genalloc.h
include/linux/hayesesp.h
include/linux/hid-debug.h
include/linux/hiddev.h
include/linux/hpet.h
include/linux/hp_sdc.h
include/linux/htirq.h
include/linux/hwmon-sysfs.h
include/linux/hwmon-vid.h
include/linux/i2c-ocores.h
include/linux/i2c-pnx.h
include/linux/ibmtr.h
include/linux/if_ec.h
include/linux/if_ppp.h
include/linux/if_tunnel.h
include/linux/init_ohci1394_dma.h
include/linux/ioc3.h
include/linux/iommu.h
include/linux/iommu-helper.h
include/linux/ip6_tunnel.h
include/linux/ipv6_route.h
include/linux/irda.h
include/linux/irq_cpustat.h
include/linux/iscsi_ibft.h
include/linux/isdn_ppp.h
include/linux/istallion.h
include/linux/ixjuser.h
include/linux/jhash.h
include/linux/kdev_t.h
include/linux/kernelcapi.h
include/linux/kmalloc_sizes.h
include/linux/kvm_host.h
include/linux/kvm_para.h
include/linux/leds-bd2802.h
include/linux/leds_pwm.h
include/linux/libps2.h
include/linux/license.h
include/linux/llc.h
include/linux/lmb.h
include/linux/lzo.h
include/linux/maple.h
include/linux/mbcache.h
include/linux/mbus.h
include/linux/mc6821.h
include/linux/mm_inline.h
include/linux/mpage.h
include/linux/mroute6.h
include/linux/mv643xx_eth.h
include/linux/ncp_fs_i.h
include/linux/netrom.h
include/linux/nfs4_mount.h
include/linux/nfs_fs_sb.h
include/linux/nfs.h
include/linux/nfs_page.h
include/linux/nfs_xdr.h
include/linux/nilfs2_fs.h
include/linux/nls.h
include/linux/n_r3964.h
include/linux/nsc_gpio.h
include/linux/nubus.h
include/linux/of_device.h
include/linux/of.h
include/linux/of_platform.h
include/linux/of_spi.h
include/linux/page_cgroup.h
include/linux/pagevec.h
include/linux/parport_pc.h
include/linux/parser.h
include/linux/patchkey.h
include/linux/pci-acpi.h
include/linux/pcieport_if.h
include/linux/pci_hotplug.h
include/linux/pda_power.h
include/linux/phonet.h
include/linux/phy_fixed.h
include/linux/pipe_fs_i.h
include/linux/pm_wakeup.h
include/linux/prio_tree.h
include/linux/qnx4_fs.h
include/linux/ramfs.h
include/linux/rcuclassic.h
include/linux/rcupreempt.h
include/linux/reiserfs_fs_i.h
include/linux/reiserfs_fs_sb.h
include/linux/reiserfs_xattr.h
include/linux/romfs_fs.h
include/linux/rose.h
include/linux/rwsem-spinlock.h
include/linux/scc.h
include/linux/scx200_gpio.h
include/linux/sdla.h
include/linux/selection.h
include/linux/selinux.h
include/linux/serial167.h
include/linux/serialP.h
include/linux/sh_intc.h
include/linux/signalfd.h
include/linux/slab_def.h
include/linux/slob_def.h
include/linux/slub_def.h
include/linux/smb_fs_sb.h
include/linux/smb_mount.h
include/linux/spinlock_api_smp.h
include/linux/spinlock_api_up.h
include/linux/spinlock_types_up.h
include/linux/spinlock_up.h
include/linux/splice.h
include/linux/srcu.h
include/linux/stallion.h
include/linux/svga.h
include/linux/swapops.h
include/linux/sysv_fs.h
include/linux/task_io_accounting.h
include/linux/tick.h
include/linux/tty_driver.h
include/linux/tty_flip.h
include/linux/un.h
include/linux/usb_usual.h
include/linux/videotext.h
include/linux/virtio_net.h
include/linux/vmstat.h
include/linux/vt_buffer.h
include/linux/x25.h
include/linux/zorro.h


