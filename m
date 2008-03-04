Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYCDHtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYCDHtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYCDHtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:49:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbYCDHtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:49:19 -0500
Date: Mon, 3 Mar 2008 23:49:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       linux-usb@vger.kernel.org
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
Message-Id: <20080303234913.f63e5fcb.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803030058280.5974@sheep.housecafe.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 01:05:53 +0100 (CET) Christian Kujau <lists@nerdbynature.de> wrote:

> Hi,
> 
> after upgrading to 2.6.25-rc3, kern.log shows:

>From which kernel version did you upgrade?

> [ 1535.884848] ------------[ cut here ]------------
> [ 1535.884855] WARNING: at drivers/usb/host/ehci-hcd.c:287 ehci_iaa_watchdog+0x7a/0x80()
> [ 1535.884858] Modules linked in: sha256_generic xt_tcpudp ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_nat_ftp nf_nat nf_conntrack_ftp xt_conntrack nf_conntrack iptable_filter ip_tables ipt_ULOG x_tables nfsd lockd nfs_acl auth_rpcgss exportfs tun sunrpc fuse twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid hwmon snd_pcm_oss snd_mixer_oss zd1211rw firmware_class snd_intel8x0 snd_ac97_codec mac80211 ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc cfg80211 pl2303 usbserial i2c_nforce2 i2c_core
> [ 1535.884901] Pid: 4272, comm: FahCore_78.exe Not tainted 2.6.25-rc3 #6
> [ 1535.884906]  [<c0119f9f>] warn_on_slowpath+0x5f/0x90
> [ 1535.884918]  [<f8d868b5>] sta_info_get+0x55/0x60 [mac80211]
> [ 1535.884940]  [<c0139285>] __lock_acquire+0x4e5/0xfd0
> [ 1535.884950]  [<c0139285>] __lock_acquire+0x4e5/0xfd0
> [ 1535.884955]  [<c0165487>] kmem_cache_free+0xa7/0xf0
> [ 1535.884964]  [<c0102f17>] restore_nocheck+0x12/0x15
> [ 1535.884970]  [<c01388c6>] trace_hardirqs_on+0x66/0x110
> [ 1535.884978]  [<c04410df>] _spin_lock_irqsave+0x3f/0x50
> [ 1535.884987]  [<c036369a>] ehci_iaa_watchdog+0x7a/0x80
> [ 1535.884991]  [<c0122cc8>] run_timer_softirq+0x128/0x190
> [ 1535.884998]  [<c02b8e3c>] blk_done_softirq+0x3c/0x70
> [ 1535.885004]  [<c0363620>] ehci_iaa_watchdog+0x0/0x80
> [ 1535.885010]  [<c011f232>] __do_softirq+0x52/0xa0
> [ 1535.885014]  [<c01056c8>] do_softirq+0x98/0xd0
> [ 1535.885020]  [<c0144df0>] handle_level_irq+0x0/0xe0
> [ 1535.885027]  [<c011f1bd>] irq_exit+0x4d/0x70
> [ 1535.885031]  [<c0105790>] do_IRQ+0x90/0xf0
> [ 1535.885034]  [<c01388fc>] trace_hardirqs_on+0x9c/0x110
> [ 1535.885040]  [<c01038c6>] common_interrupt+0x2e/0x34
> [ 1535.885049]  =======================
> [ 1535.885051] ---[ end trace b6c2a2178c98c162 ]---
> 
> 
> There's no oops, and the box is running fine. The only USB devices in use 
> is the zd1211rw WLAN adapter and some mp3 player attached as usb-storage.
> 
> I've seen http://lkml.org/lkml/2008/2/13/566 with the same warning and a 
> real problem, but nothing happened. Linas, is this freeze still present?
> 
> Full dmesg and .config: http://nerdbynature.de/bits/2.6.25-rc3/
> 
