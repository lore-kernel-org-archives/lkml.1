Return-Path: <linux-kernel-owner+w=401wt.eu-S965738AbXC1UIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbXC1UIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:08:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965743AbXC1UIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:08:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57299 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965742AbXC1UIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:08:09 -0400
Date: Wed, 28 Mar 2007 13:07:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Maneesh Soni <maneesh@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: tty OOPS (Re: 2.6.21-rc5-mm2)
Message-Id: <20070328130756.49ccbfcf.akpm@linux-foundation.org>
In-Reply-To: <20070328185632.GB5306@martell.zuzino.mipt.ru>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070328170214.GA13044@rhlx01.hs-esslingen.de>
	<20070328173310.GA4682@rhlx01.hs-esslingen.de>
	<20070328174524.GA25709@rhlx01.hs-esslingen.de>
	<20070328180446.GA7528@rhlx01.hs-esslingen.de>
	<20070328183814.GA5306@martell.zuzino.mipt.ru>
	<20070328185632.GB5306@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 22:56:32 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Mar 28, 2007 at 10:38:14PM +0400, Alexey Dobriyan wrote:
> > On Wed, Mar 28, 2007 at 08:04:46PM +0200, Andreas Mohr wrote:
> > > [unrelated maintainers removed, Alexey added]
> > >
> > > On Wed, Mar 28, 2007 at 07:45:24PM +0200, Andreas Mohr wrote:
> > > > Hi,
> > > >
> > > > just wanted to add that when analyzing the backtrace I found the comment
> > > > at drivers/char/vt.c/con_close() to be VERY suspicious...
> > > > (need to take tty_mutex to prevent concurrent thread tty access).
> > > > This might just be what happened here despite trying to protect against it.
> > >
> > > OK, can we assume that one of
> > >
> > > +protect-tty-drivers-list-with-tty_mutex.patch
> > > +tty-minor-merge-correction.patch
> > > +tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
> > >
> > > is responsible / not implemented fully?
> >
> > #2 is just comment removal.
> >
> > I may state the obvious, but __iget() in sysfs_drop_dentry() gets NULL
> > inode and you aren't failing on spin_lock one line above because of UP
> > without spinlock debugging.
> 
> The only suspicious new patch in -rc5-mm1 to me is
> fix-sysfs-reclaim-crash.patch which removes "sd->s_dentry = NULL;". Note
> that whole sysfs_drop_dentry() is NOP if ->s_dentry is NULL.
> 
> Could you try to revert it?
> 
> 	Alexey, who knows very little about sysfs internals

cc's added.


Also added is the sad little missive I sent to the USB guys last night,
which is similar-looking:



Begin forwarded message:

Date: Wed, 28 Mar 2007 00:34:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: usb/sysfs oops in 2.6.21-rc5-mm1



I think the connector wasn't pushed in terribly well, so there might have
been some contact bounce.


[15813.836000] ipw2200: Firmware error detected.  Restarting.
[17200.268000] hub 2-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
[17200.268000] usb 2-1: USB disconnect, address 4
[17200.268000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000024
[17200.268000]  printing eip:
[17200.268000] c016e447
[17200.268000] *pde = 00000000
[17200.268000] Oops: 0000 [#1]
[17200.268000] last sysfs file: block/sr0/size
[17200.268000] Modules linked in: udf i915 drm ipw2200 sonypi ipv6 autofs4 hidp l2cap sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables cpufreq_ondemand video sbs button battery asus_acpi ac nvram hci_usb bluetooth ieee80211 ohci1394 ieee1394 joydev ieee80211_crypt snd_hda_intel snd_hda_codec ehci_hcd uhci_hcd sg snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sr_mod cdrom piix soundcore i2c_i801 snd_page_alloc i2c_core pcspkr generic ext3 jbd ide_disk ide_core
[17200.268000] CPU:    0
[17200.268000] EIP:    0060:[<c016e447>]    Not tainted VLI
[17200.268000] EFLAGS: 00010246   (2.6.21-rc5-mm1 #1)
[17200.268000] EIP is at __iget+0x3/0x48
[17200.268000] eax: 00000000   ebx: 00000000   ecx: 00000000   edx: c8a90514
[17200.268000] esi: c8a90514   edi: 00000000   ebp: c8cea5e4   esp: c210fe5c
[17200.268000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[17200.268000] Process khubd (pid: 155, ti=c210e000 task=c209b6f0 task.ti=c210e000)
[17200.268000] Stack: c2493a14 c0192933 c8cea5e8 c0338373 c0338373 c8cea5e4 c0192a90 c889ba24 
[17200.268000]        c033836f c8a90514 c8cea58c c889ba08 c8556a40 df8918c0 c24e6418 c0230d46 
[17200.268000]        c889ba08 c889ba08 c0230dd8 c889ba08 c889ba00 df8918c0 c24e6418 c0230ffa 
[17200.268000] Call Trace:
[17200.268000]  [<c0192933>] sysfs_drop_dentry+0x2b/0xc3
[17200.268000]  [<c0192a90>] sysfs_hash_and_remove+0x86/0x12c
[17200.268000]  [<c0230d46>] device_remove_file+0x19/0x25
[17200.268000]  [<c0230dd8>] device_del+0x26/0x240
[17200.268000]  [<c0230ffa>] device_unregister+0x8/0x10
[17200.268000]  [<c026739a>] usb_remove_ep_files+0x4d/0x60
[17200.268000]  [<c0260031>] usb_new_device+0x199/0x1ab
[17200.268000]  [<c0266d14>] usb_remove_sysfs_intf_files+0x1e/0x43
[17200.268000]  [<c026312d>] usb_disable_device+0x55/0xbb
[17200.268000]  [<c0260415>] usb_disconnect+0x87/0x100
[17200.268000]  [<c0260842>] hub_thread+0x361/0xa70
[17200.268000]  [<c016d394>] d_lookup+0x16/0x31
[17200.268000]  [<c01174df>] __wake_up_common+0x31/0x4f
[17200.268000]  [<c0128754>] autoremove_wake_function+0x0/0x35
[17200.268000]  [<c02604e1>] hub_thread+0x0/0xa70
[17200.268000]  [<c01285f7>] kthread+0xa0/0xc9
[17200.268000]  [<c0128557>] kthread+0x0/0xc9
[17200.268000]  [<c010464f>] kernel_thread_helper+0x7/0x10
[17200.268000]  =======================
[17200.268000] Code: 00 00 00 89 d8 81 ce 00 02 00 00 e8 3e ba 01 00 8b 43 20 31 c9 89 f2 89 04 24 89 d8 e8 19 25 01 00 58 5b 5e c3 90 90 90 53 89 c3 <83> 78 24 00 74 05 ff 40 24 eb 38 ff 40 24 f6 80 2c 01 00 00 0f 
[17200.268000] EIP: [<c016e447>] __iget+0x3/0x48 SS:ESP 0068:c210fe5c
[17327.844000] ipw2200: Firmware error detected.  Restarting.

