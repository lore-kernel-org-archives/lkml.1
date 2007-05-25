Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbXEYVCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbXEYVCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXEYVCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:02:45 -0400
Received: from waste.org ([66.93.16.53]:42743 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbXEYVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:02:45 -0400
Date: Fri, 25 May 2007 16:01:52 -0500
From: Matt Mackall <mpm@selenic.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <gregkh@suse.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com
Subject: Re: 2.6.22-rc2-mm1: NetworkManager fails to find ipw2200 again
Message-ID: <20070525210152.GL11115@waste.org>
References: <20070525163621.GE11166@waste.org> <20070525164842.GA6220@suse.de> <3ae72650705251037p6b1632a5m45cdd999a294fcbd@mail.gmail.com> <20070525175319.GK11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525175319.GK11115@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2007 at 12:53:19PM -0500, Matt Mackall wrote:
> On Fri, May 25, 2007 at 07:37:46PM +0200, Kay Sievers wrote:
> > On 5/25/07, Greg KH <gregkh@suse.de> wrote:
> > >On Fri, May 25, 2007 at 11:36:22AM -0500, Matt Mackall wrote:
> > >> 2.6.22-rc2 works. CONFIG_SYSFS_DEPRECATED = y, though that shouldn't
> > >> matter. Bringing up the interface manually still works, so I suspect
> > >> this is sysfs or HAL related again. Again, Debian unstable so
> > >> userspace is quite up-to-date.
> > >
> > >I don't have any driver model changes that affect network devices in my
> > >tree.  Could you go through and bisect the -mm tree to see if you can
> > >find the patch that causes this?
> > 
> > Does it work, when you unload and load the kernel module?
> 
> rmmod followed by insmod had no effect.
> 
> > Does it work when you restart HAL and then NetworkManager?
> 
> I restarted dbus, which stopped and restarted HAL and NM. No effect.
> 
> > Can you compare the sections for the wireless card in the output of "lshal"?
> 
> The unhappy one looks like this:
> 
> udi = '/org/freedesktop/Hal/devices/pci_8086_4220'
>   info.udi = '/org/freedesktop/Hal/devices/pci_8086_4220'  (string)
>   linux.subsystem = 'pci'  (string)
>   linux.hotplug_type = 1  (0x1)  (int)
>   pci.subsys_product = 'Unknown (0x2711)'  (string)
>   pci.subsys_vendor = 'Intel Corporation'  (string)
>   info.product = 'PRO/Wireless 2200BG Network Connection'  (string)
>   pci.product = 'PRO/Wireless 2200BG Network Connection'  (string)
>   info.vendor = 'Intel Corporation'  (string)
>   pci.vendor = 'Intel Corporation'  (string)
>   pci.device_protocol = 0  (0x0)  (int)
>   pci.device_subclass = 128  (0x80)  (int)
>   pci.device_class = 2  (0x2)  (int)
>   pci.subsys_vendor_id = 32902  (0x8086)  (int)
>   pci.subsys_product_id = 10001  (0x2711)  (int)
>   pci.vendor_id = 32902  (0x8086)  (int)
>   pci.product_id = 16928  (0x4220)  (int)
>   info.linux.driver = 'ipw2200'  (string)
>   pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
>   info.parent = '/org/freedesktop/Hal/devices/pci_8086_2448'  (string)
>   info.bus = 'pci'  (string)
>   linux.sysfs_path_device = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
>   linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
> 
> Will let you know when my bisecting finds a happy one. 

Here's a happy one:

udi = '/org/freedesktop/Hal/devices/pci_8086_4220'
  info.udi = '/org/freedesktop/Hal/devices/pci_8086_4220'  (string)
  linux.subsystem = 'pci'  (string)
  linux.hotplug_type = 1  (0x1)  (int)
  pci.subsys_product = 'Unknown (0x2711)'  (string)
  pci.subsys_vendor = 'Intel Corporation'  (string)
  info.product = 'PRO/Wireless 2200BG Network Connection'  (string)
  pci.product = 'PRO/Wireless 2200BG Network Connection'  (string)
  info.vendor = 'Intel Corporation'  (string)
  pci.vendor = 'Intel Corporation'  (string)
  pci.device_protocol = 0  (0x0)  (int)
  pci.device_subclass = 128  (0x80)  (int)
  pci.device_class = 2  (0x2)  (int)
  pci.subsys_vendor_id = 32902  (0x8086)  (int)
  pci.subsys_product_id = 10001  (0x2711)  (int)
  pci.vendor_id = 32902  (0x8086)  (int)
  pci.product_id = 16928  (0x4220)  (int)
  info.linux.driver = 'ipw2200'  (string)
  pci.linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
  info.parent = '/org/freedesktop/Hal/devices/pci_8086_2448'  (string)
  info.bus = 'pci'  (string)
  linux.sysfs_path_device = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)
  linux.sysfs_path = '/sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0'  (string)

Look the same to me.

So far I'm down to:

patch 56: good
patch 113: bad

    56  powerpc-ps3-use-__maybe_unused.patch
    57  do-not-select-macintosh-drivers-by-default.patch
    58  powerpc-promc-remove-undef-printk.patch
    59  powerpc-fix-kconfig-select-warning-with-ucc_fast.patch
    60  8xx-mpc885ads-pcmcia-support.patch
    61  8xx-mpc885ads-pcmcia-support-fix.patch
    62  8xx-fix-whitespace-and-indentation.patch
    63  dts-kill-hardcoded-phandles.patch
    64  gregkh-driver-debugfs-add-rename-for-debugfs-files.patch
    65
    gregkh-driver-update-documentation-driver-model-platformtxt.patch
    66
    gregkh-driver-driver-core-keep-physdev-for-old-struct-class_device.patch
    67  gregkh-driver-driver-core-kill-unused-code.patch
    68  gregkh-driver-howto-removing-duplicated-entry.patch
    69  gregkh-driver-dmi-based-module-autoloading.patch
    70  gregkh-driver-uio.patch
    71  gregkh-driver-uio-documentation.patch
    72  gregkh-driver-uio-hilscher-cif-card-driver.patch
    73  gregkh-driver-idr-fix-obscure-bug-in-allocation-path.patch
    74  gregkh-driver-idr-separate-out-idr_mark_full.patch
    75  gregkh-driver-ida-implement-idr-based-id-allocator.patch
    76  gregkh-driver-sysfs-move-release_sysfs_dirent-to-dirc.patch
    77  gregkh-driver-sysfs-allocate-inode-number-using-ida.patch
    78  gregkh-driver-sysfs-make-sysfs_put-ignore-null-sd.patch
    79  gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
    80
    gregkh-driver-sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
    81
    gregkh-driver-sysfs-flatten-and-fix-sysfs_rename_dir-error-handling.patch
    82
    gregkh-driver-sysfs-consolidate-sysfs_dirent-creation-functions.patch
    83  gregkh-driver-sysfs-add-sysfs_dirent-s_parent.patch
    84  gregkh-driver-sysfs-add-sysfs_dirent-s_name.patch
    85  gregkh-driver-sysfs-make-sysfs_dirent-s_element-a-union.patch
    86  gregkh-driver-sysfs-implement-kobj_sysfs_assoc_lock.patch
    87
    gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
    88  gregkh-driver-sysfs-implement-bin_buffer.patch
    89
    gregkh-driver-sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
    90  gregkh-driver-sysfs-kill-attribute-file-orphaning.patch
    91  gregkh-driver-sysfs-separate-out-sysfs_attach_dentry.patch
    92  gregkh-driver-sysfs-reimplement-syfs_drop_dentry.patch
    93  gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
    94
    gregkh-driver-driver-core-make-devt_attr-and-uevent_attr-static.patch
    95  gregkh-driver-put_device-might_sleep.patch
    96  gregkh-driver-kobject-warn.patch
    97
    gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
    98  gregkh-driver-nozomi.patch
    99
    fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
   100  power-management-use-mutexes-instead-of-semaphores.patch
   101  sysdev-use-mutex-instead-of-semaphore.patch
   102  driver-core-check-return-code-of-sysfs_create_link.patch
   103  driver-core-check-return-code-of-sysfs_create_link-fix.patch
   104  driver-core-coding-style-cleanup.patch
   105  remove-odd-and-misleading-comments-from-uioh.patch
   106  drm-spinlock-initializer-cleanup.patch
   107  git-dvb.patch
   108  dvb_en_50221-convert-to-kthread-api.patch
   109  cinergyt2-fix-file-release-handler.patch
   110  saa7111-fix-picture-settings-cache-bug.patch
   111  saa7134-tvaudio-kthread-conversion.patch
   112  jdelvare-i2c-i2c-legacy-drivers-shouldnt-issue-uevents.patch
   113  jdelvare-i2c-i2c-kerneldoc.patch


-- 
Mathematics is the supreme nostalgia of our time.
