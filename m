Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZGGBz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZGGBz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 21:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZGGBzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 21:55:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44733 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752194AbZGGBzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 21:55:18 -0400
Date: Mon, 6 Jul 2009 21:55:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <dbrownell@users.sourceforge.net>
Subject: Re: 2.6.31-rc2 warning in drivers/usb/host/ehci-hcd.c
In-Reply-To: <20090706222651.GA6709@Pilar.aei.mpg.de>
Message-ID: <Pine.LNX.4.44L0.0907062152110.21717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Carlos R. Mafra wrote:

> I was looking at the 'dmesg' output for 2.6.31-rc2 and noticed
> this warning
> 
> ------------[ cut here ]------------
> WARNING: at drivers/usb/host/ehci-hcd.c:1048 ehci_endpoint_reset+0xfc/0x140 [ehci_hcd]()
> Hardware name: VGN-FZ240E
> clear_halt for a busy endpoint
> Modules linked in: usbhid nvram dvb_usb_dib0700 dib7000p dib7000m dvb_usb dib3000mc dibx000_common dib0070 option usb_storage usbserial uvc                                  video snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm iwlagn ehci_hcd sky2 snd_timer uhci_hcd i2c_i801 evdev snd_page_alloc                                   sg sr_mod ata_piix ahci libata sd_mod scsi_mod
> Pid: 5043, comm: comgt Not tainted 2.6.31-rc2 #109
> Call Trace:
>  [<ffffffffa00d2b6c>] ? ehci_endpoint_reset+0xfc/0x140 [ehci_hcd]
>  [<ffffffff8103f2b8>] warn_slowpath_common+0x78/0xd0
>  [<ffffffff8103f394>] warn_slowpath_fmt+0x64/0x70
>  [<ffffffff81264bd5>] ? usb_free_urb+0x15/0x20
>  [<ffffffff812660d7>] ? usb_start_wait_urb+0x97/0xe0
>  [<ffffffffa00d2b6c>] ehci_endpoint_reset+0xfc/0x140 [ehci_hcd]
>  [<ffffffff81261fed>] usb_hcd_reset_endpoint+0x1d/0x70
>  [<ffffffff812653f2>] usb_reset_endpoint+0x22/0x40
>  [<ffffffff81266556>] usb_clear_halt+0x66/0x80
>  [<ffffffffa0199d1c>] option_open+0xcc/0x180 [option]
>  [<ffffffffa0177986>] serial_open+0x176/0x240 [usbserial]
>  [<ffffffff811bd81a>] tty_open+0x1fa/0x530
>  [<ffffffff810ac755>] chrdev_open+0xf5/0x1a0
>  [<ffffffff810ac660>] ? chrdev_open+0x0/0x1a0
>  [<ffffffff810a77c5>] __dentry_open+0xd5/0x2f0
>  [<ffffffff810a7ae7>] nameidata_to_filp+0x57/0x70
>  [<ffffffff810b68ba>] do_filp_open+0x71a/0xb10
>  [<ffffffff810c06ea>] ? alloc_fd+0x4a/0x140
>  [<ffffffff810a75df>] do_sys_open+0x7f/0x140
>  [<ffffffff810a76cb>] sys_open+0x1b/0x20
>  [<ffffffff8100bdab>] system_call_fastpath+0x16/0x1b
> ---[ end trace f21382a71ff3302a ]---
> 
> 
> However I can still use a USB pendrive and everything seems to be fine.

This is definitely a bug in the option driver.  If you remove the call 
to usb_clear_halt() in drivers/usb/serial/option.c:option_open(), does 
the warning go away and does everything continue to work okay?

Alan Stern

