Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXD0VVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXD0VVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbXD0VVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:21:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48255 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbXD0VVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:21:09 -0400
Date: Fri, 27 Apr 2007 14:18:36 -0700
From: Greg KH <greg@kroah.com>
To: "VE (HOME)" <ve@vetienne.net>, jkosina@suse.cz
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, fubar@us.ibm.com
Subject: USB HID bug (was [PROBLEM] Bonding driver in linux-2.6.21-rc6-mm1)
Message-ID: <20070427211836.GC5917@kroah.com>
References: <200704262058.33087.ve@vetienne.net> <20070426211146.f370cf81.akpm@linux-foundation.org> <010a01c788ae$0a7d0140$5601a8c0@apws2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <010a01c788ae$0a7d0140$5601a8c0@apws2>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 11:25:46AM +0200, VE (HOME) wrote:
>  Andrew Morton wrote:
> > On Thu, 26 Apr 2007 20:58:32 +0200 Vincent ETIENNE <ve@vetienne.net>
> > wrote:
> >
> >
> > This was due to locking bustage in the net tree.  It should be fixed
> > in 2.6.21-rc7-mm2.
> 
>  I have tried this version. Same problem ( see 
>  http://mail1.vetienne.net/linux/dmesg-2.6.21-rc7-mm2.log )
>  But also a new problem with USB keyboard/mouse
> 
>  BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()
> 
>  Call Trace:
>  [<ffffffff8044bbcb>] usbhid_lookup_quirk+0x63/0xea
>  [<ffffffff8044ab12>] hid_probe+0x4d/0xbad
>  [<ffffffff8021d7cd>] default_wake_function+0x0/0xe
>  [<ffffffff8029d0b6>] sysfs_new_dirent+0x79/0xaa
>  [<ffffffff80403411>] usb_match_one_id+0x26/0x82
>  [<ffffffff80403fe6>] usb_probe_interface+0x7d/0xa5
>  [<ffffffff80391cb9>] driver_probe_device+0xf6/0x17f
>  [<ffffffff80391de4>] __driver_attach+0x0/0x93
>  [<ffffffff80391e3e>] __driver_attach+0x5a/0x93
>  [<ffffffff8039110c>] bus_for_each_dev+0x43/0x6e
>  [<ffffffff80391433>] bus_add_driver+0x7b/0x19d
>  [<ffffffff80403b06>] usb_register_driver+0x7e/0xe1
>  [<ffffffff8064d2d3>] hid_init+0x28/0x4e
>  [<ffffffff8063460b>] kernel_init+0x162/0x2d2
>  [<ffffffff8020a338>] child_rip+0xa/0x12
>  [<ffffffff80343d5c>] acpi_ds_init_one_object+0x0/0x7c
>  [<ffffffff806344a9>] kernel_init+0x0/0x2d2
>  [<ffffffff8020a32e>] child_rip+0x0/0x12
> 
>  input: ServerEngines SE USB Device as 
>  /devices/pci0000:00/0000:00:1d.2/usb4/4-2/4-2:1.0/input/input2
>  input: USB HID v1.11 Keyboard [ServerEngines SE USB Device] on 
>  usb-0000:00:1d.2-2
>  BUG: at drivers/hid/usbhid/hid-quirks.c:480 usbhid_exists_dquirk()
> 
>  Call Trace:
>  [<ffffffff8044bbcb>] usbhid_lookup_quirk+0x63/0xea
>  [<ffffffff8044ab12>] hid_probe+0x4d/0xbad
>  [<ffffffff8029d0b6>] sysfs_new_dirent+0x79/0xaa
>  [<ffffffff80403411>] usb_match_one_id+0x26/0x82
>  [<ffffffff80403fe6>] usb_probe_interface+0x7d/0xa5
>  [<ffffffff80391cb9>] driver_probe_device+0xf6/0x17f
>  [<ffffffff80391de4>] __driver_attach+0x0/0x93
>  [<ffffffff80391e3e>] __driver_attach+0x5a/0x93
>  [<ffffffff8039110c>] bus_for_each_dev+0x43/0x6e
>  [<ffffffff80391433>] bus_add_driver+0x7b/0x19d
>  [<ffffffff80403b06>] usb_register_driver+0x7e/0xe1
>  [<ffffffff8064d2d3>] hid_init+0x28/0x4e
>  [<ffffffff8063460b>] kernel_init+0x162/0x2d2
>  [<ffffffff8020a338>] child_rip+0xa/0x12
>  [<ffffffff80343d5c>] acpi_ds_init_one_object+0x0/0x7c
>  [<ffffffff806344a9>] kernel_init+0x0/0x2d2
>  [<ffffffff8020a32e>] child_rip+0x0/0x12

Jiri, any thoughts about this?  This looks like it comes from your tree
as 2.6.21 doesn't have the drivers/hid/usbhid/ directory...

thanks,

greg k-h
