Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZIDIJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZIDIJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 04:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbZIDIJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 04:09:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34024 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbZIDIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 04:09:33 -0400
To: gregkh@suse.de
CC: miklos@szeredi.hu, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@linux.intel.com, stern@rowland.harvard.edu
In-reply-to: <20090903183637.GA5140@suse.de> (message from Greg KH on Thu, 3
	Sep 2009 11:36:37 -0700)
Subject: Re: WARNINGs in usb-serial.c
References: <E1MjD4A-0002wi-KL@pomaz-ex.szeredi.hu> <20090903183637.GA5140@suse.de>
Message-Id: <E1MjTrP-0004S3-6B@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Sep 2009 10:09:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Greg KH wrote:
> On Thu, Sep 03, 2009 at 04:13:34PM +0200, Miklos Szeredi wrote:
> > I get the following warnings in 2.6.31-rc.  A lot of them:
> > 
> > WARNING: at drivers/usb/serial/usb-serial.c:414 serial_write_room+0x59/0x6e [usbserial]()
> > WARNING: at drivers/usb/serial/usb-serial.c:401 serial_write+0x77/0x9d [usbserial]()
> > 
> > This is a huawei-3565 modem.
> > 
> > The messages don't seem to hurt, but there's lot of trouble with this
> > gadget.  Sometimes it just doesn't work after a while and a reboot is
> > needed.  Sometimes it hangs the kernel after suspend, etc.  Not sure
> > if this is related to the warnings...
> 
> {sigh}
> 
> The tty layer changes are being a pain here :(
> 
> Alan Stern posted a set of patches to the linux-usb list to hopefully
> address stuff like this, is there any way you could test them out to see
> if they help or not?

Nope, it doesn't seem to help.  Still got the same warnings with the
patched kernel (latest git + ghk tree + usbserial patches).

Thanks,
Miklos


[ 1658.280527] ------------[ cut here ]------------
[ 1658.280546] WARNING: at drivers/usb/serial/usb-serial.c:421 serial_write_room+0x59/0x6e [usbserial]()
[ 1658.280552] Hardware name: 2007FUG
[ 1658.280556] Modules linked in: option usbserial usb_storage bnep rfcomm sco l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse iwl3945 iwlcore thinkpad_acpi mac80211 backlight btusb led_class bluetooth thermal ac battery processor button nsc_ircc irda crc_ccitt cfg80211 rfkill e1000e uinput [last unloaded: usbserial]
[ 1658.280629] Pid: 9, comm: events/0 Not tainted 2.6.31-rc8-gkh-00038-g37d0892-dirty #33
[ 1658.280634] Call Trace:
[ 1658.280650]  [<ffffffffa01ca72c>] ? serial_write_room+0x59/0x6e [usbserial]
[ 1658.280663]  [<ffffffff81041d0d>] warn_slowpath_common+0x7c/0xa9
[ 1658.280672]  [<ffffffff81041d4e>] warn_slowpath_null+0x14/0x16
[ 1658.280684]  [<ffffffffa01ca72c>] serial_write_room+0x59/0x6e [usbserial]
[ 1658.280695]  [<ffffffff811c273d>] tty_write_room+0x1d/0x1f
[ 1658.280702]  [<ffffffff811c0111>] process_echoes+0x59/0x289
[ 1658.280712]  [<ffffffff8131da65>] ? mutex_unlock+0xe/0x10
[ 1658.280720]  [<ffffffff811c2078>] n_tty_receive_buf+0xa28/0xebd
[ 1658.280731]  [<ffffffff81067ed8>] ? mark_held_locks+0x4d/0x6b
[ 1658.280740]  [<ffffffff8131fa88>] ? _spin_unlock_irqrestore+0x44/0x72
[ 1658.280748]  [<ffffffff8106814b>] ? trace_hardirqs_on_caller+0x10b/0x12f
[ 1658.280757]  [<ffffffff811c47ef>] flush_to_ldisc+0x12f/0x1d7
[ 1658.280767]  [<ffffffff810542f7>] worker_thread+0x234/0x350
[ 1658.280775]  [<ffffffff810542a0>] ? worker_thread+0x1dd/0x350
[ 1658.280783]  [<ffffffff811c46c0>] ? flush_to_ldisc+0x0/0x1d7
[ 1658.280791]  [<ffffffff81059226>] ? autoremove_wake_function+0x0/0x3d
[ 1658.280800]  [<ffffffff8106817c>] ? trace_hardirqs_on+0xd/0xf
[ 1658.280808]  [<ffffffff810540c3>] ? worker_thread+0x0/0x350
[ 1658.280815]  [<ffffffff81058e34>] kthread+0x94/0x9c
[ 1658.280824]  [<ffffffff8100c29a>] child_rip+0xa/0x20
[ 1658.280832]  [<ffffffff8100bc00>] ? restore_args+0x0/0x30
[ 1658.280839]  [<ffffffff81058da0>] ? kthread+0x0/0x9c
[ 1658.280846]  [<ffffffff8100c290>] ? child_rip+0x0/0x20
[ 1658.280851] ---[ end trace 644f4c2ff2fe597f ]---
[ 1658.280856] ------------[ cut here ]------------
[ 1658.280868] WARNING: at drivers/usb/serial/usb-serial.c:408 serial_write+0x77/0x9d [usbserial]()
[ 1658.280873] Hardware name: 2007FUG
[ 1658.280876] Modules linked in: option usbserial usb_storage bnep rfcomm sco l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse iwl3945 iwlcore thinkpad_acpi mac80211 backlight btusb led_class bluetooth thermal ac battery processor button nsc_ircc irda crc_ccitt cfg80211 rfkill e1000e uinput [last unloaded: usbserial]
[ 1658.280940] Pid: 9, comm: events/0 Tainted: G        W  2.6.31-rc8-gkh-00038-g37d0892-dirty #33
[ 1658.280945] Call Trace:
[ 1658.280957]  [<ffffffffa01ca7b8>] ? serial_write+0x77/0x9d [usbserial]
[ 1658.280966]  [<ffffffff81041d0d>] warn_slowpath_common+0x7c/0xa9
[ 1658.280974]  [<ffffffff81041d4e>] warn_slowpath_null+0x14/0x16
[ 1658.280986]  [<ffffffffa01ca7b8>] serial_write+0x77/0x9d [usbserial]
[ 1658.280994]  [<ffffffff811bc4b9>] tty_put_char+0x32/0x34
[ 1658.281002]  [<ffffffff811bff14>] do_output_char+0xb3/0x201
[ 1658.281016]  [<ffffffff811c0294>] process_echoes+0x1dc/0x289
[ 1658.281024]  [<ffffffff811c2078>] n_tty_receive_buf+0xa28/0xebd
[ 1658.281033]  [<ffffffff81067ed8>] ? mark_held_locks+0x4d/0x6b
[ 1658.281042]  [<ffffffff8131fa88>] ? _spin_unlock_irqrestore+0x44/0x72
[ 1658.281050]  [<ffffffff8106814b>] ? trace_hardirqs_on_caller+0x10b/0x12f
[ 1658.281059]  [<ffffffff811c47ef>] flush_to_ldisc+0x12f/0x1d7
[ 1658.281068]  [<ffffffff810542f7>] worker_thread+0x234/0x350
[ 1658.281103]  [<ffffffff810542a0>] ? worker_thread+0x1dd/0x350
[ 1658.281111]  [<ffffffff811c46c0>] ? flush_to_ldisc+0x0/0x1d7
[ 1658.281119]  [<ffffffff81059226>] ? autoremove_wake_function+0x0/0x3d
[ 1658.281128]  [<ffffffff8106817c>] ? trace_hardirqs_on+0xd/0xf
[ 1658.281136]  [<ffffffff810540c3>] ? worker_thread+0x0/0x350
[ 1658.281143]  [<ffffffff81058e34>] kthread+0x94/0x9c
[ 1658.281151]  [<ffffffff8100c29a>] child_rip+0xa/0x20
[ 1658.281159]  [<ffffffff8100bc00>] ? restore_args+0x0/0x30
[ 1658.281166]  [<ffffffff81058da0>] ? kthread+0x0/0x9c
[ 1658.281173]  [<ffffffff8100c290>] ? child_rip+0x0/0x20
[ 1658.281177] ---[ end trace 644f4c2ff2fe5980 ]---
[ 1658.281189] ------------[ cut here ]------------
[ 1658.281201] WARNING: at drivers/usb/serial/usb-serial.c:408 serial_write+0x77/0x9d [usbserial]()
[ 1658.281229] Hardware name: 2007FUG
[ 1658.281232] Modules linked in: option usbserial usb_storage bnep rfcomm sco l2cap acpi_cpufreq nf_conntrack_netbios_ns microcode fuse iwl3945 iwlcore thinkpad_acpi mac80211 backlight btusb led_class bluetooth thermal ac battery processor button nsc_ircc irda crc_ccitt cfg80211 rfkill e1000e uinput [last unloaded: usbserial]
[ 1658.281297] Pid: 9, comm: events/0 Tainted: G        W  2.6.31-rc8-gkh-00038-g37d0892-dirty #33
[ 1658.281302] Call Trace:
[ 1658.281314]  [<ffffffffa01ca7b8>] ? serial_write+0x77/0x9d [usbserial]
[ 1658.281323]  [<ffffffff81041d0d>] warn_slowpath_common+0x7c/0xa9
[ 1658.281332]  [<ffffffff81041d4e>] warn_slowpath_null+0x14/0x16
[ 1658.281344]  [<ffffffffa01ca7b8>] serial_write+0x77/0x9d [usbserial]
[ 1658.281352]  [<ffffffff811bc4b9>] tty_put_char+0x32/0x34
[ 1658.281359]  [<ffffffff811bff21>] do_output_char+0xc0/0x201
[ 1658.281367]  [<ffffffff811c0294>] process_echoes+0x1dc/0x289
[ 1658.281375]  [<ffffffff811c2078>] n_tty_receive_buf+0xa28/0xebd
[ 1658.281384]  [<ffffffff81067ed8>] ? mark_held_locks+0x4d/0x6b
[ 1658.281393]  [<ffffffff8131fa88>] ? _spin_unlock_irqrestore+0x44/0x72
[ 1658.281402]  [<ffffffff8106814b>] ? trace_hardirqs_on_caller+0x10b/0x12f
[ 1658.281410]  [<ffffffff811c47ef>] flush_to_ldisc+0x12f/0x1d7
[ 1658.281419]  [<ffffffff810542f7>] worker_thread+0x234/0x350
[ 1658.281426]  [<ffffffff810542a0>] ? worker_thread+0x1dd/0x350
[ 1658.281434]  [<ffffffff811c46c0>] ? flush_to_ldisc+0x0/0x1d7
[ 1658.281442]  [<ffffffff81059226>] ? autoremove_wake_function+0x0/0x3d
[ 1658.281450]  [<ffffffff8106817c>] ? trace_hardirqs_on+0xd/0xf
[ 1658.281458]  [<ffffffff810540c3>] ? worker_thread+0x0/0x350
[ 1658.281465]  [<ffffffff81058e34>] kthread+0x94/0x9c
[ 1658.281473]  [<ffffffff8100c29a>] child_rip+0xa/0x20
[ 1658.281481]  [<ffffffff8100bc00>] ? restore_args+0x0/0x30
[ 1658.281488]  [<ffffffff81058da0>] ? kthread+0x0/0x9c
[ 1658.281495]  [<ffffffff8100c290>] ? child_rip+0x0/0x20
[ 1658.281499] ---[ end trace 644f4c2ff2fe5981 ]---
