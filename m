Return-Path: <linux-kernel-owner+w=401wt.eu-S933503AbXCEPA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbXCEPA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXCEPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:00:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933503AbXCEPA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:00:58 -0500
Message-ID: <45EC3058.2010903@redhat.com>
Date: Mon, 05 Mar 2007 09:59:36 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Will Trives <will@trivescon.com.au>
CC: linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@austin.ibm.com>
Subject: Re: 2.6.21-rc2-git3 Unstable for me
References: <20070305150317.57e62d70@disher.kickcrew>
In-Reply-To: <20070305150317.57e62d70@disher.kickcrew>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Trives wrote:

[adding JFS maintainer to cc:]

Some kind of JFS problem?
fs/mpage.c line 535:
        BUG_ON(!PageUptodate(page));

> 
> It doesn't crash outright but this message pops up and then it slowly
> grinds to a halt. I've attached config and dmesg output. Asus P5B
> (intel 965) Core 2 Duo System. Stable on 2.6.20.1. I use JFS for all my
> disks. Starting a download in KTorrent is what seems to cause it.
> 
> Mar  5 14:51:57 disher kernel: ------------[ cut here ]------------
> Mar  5 14:51:57 disher kernel: kernel BUG at fs/mpage.c:535!
> Mar  5 14:51:57 disher kernel: invalid opcode: 0000 [#1]
> Mar  5 14:51:57 disher kernel: SMP 
> Mar  5 14:51:57 disher kernel: Modules linked in: af_packet ipt_LOG xt_tcpudp xt_state ppp_synctty iptable_nat nf_nat nf_conntrack_ipv4 iptable_filter ip_tables x_tables ppp_async crc_ccitt w83627ehf hwmon i2c_isa eeprom loop usbhid hid snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd sg soundcore 8139too intel_agp i2c_i801 psmouse sr_mod snd_page_alloc ehci_hcd e1000 uhci_hcd agpgart usbcore rtc i2c_core cdrom
> Mar  5 14:51:57 disher kernel: CPU:    1
> Mar  5 14:51:57 disher kernel: EIP:    0060:[<c0174733>]    Not tainted VLI
> Mar  5 14:51:57 disher kernel: EFLAGS: 00010246   (2.6.21-rc2-git3 #1)
> Mar  5 14:51:57 disher kernel: EIP is at __mpage_writepage+0x13a/0x48c
> Mar  5 14:51:57 disher kernel: eax: 72010021   ebx: c1e6b4c0   ecx: 00000000   edx: 00000000
> Mar  5 14:51:57 disher kernel: esi: c1e6b4c0   edi: 00000000   ebp: f721de6c   esp: c2273db8
> Mar  5 14:51:57 disher kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Mar  5 14:51:57 disher kernel: Process pdflush (pid: 192, ti=c2272000 task=c2258ab0 task.ti=c2272000)
> Mar  5 14:51:57 disher kernel: Stack: c01932f3 c019f852 c2273eac c0189266 00000000 0000000c f721df10 00000001 
> Mar  5 14:51:57 disher kernel:        f5de4000 00000080 00000001 00000000 f88e1990 00001f03 00000000 c2273e98 
> Mar  5 14:51:57 disher kernel:        0000003f 00000001 00000001 00000000 00000000 c2273e98 0000000e 00000000 
> Mar  5 14:51:57 disher kernel: Call Trace:
> Mar  5 14:51:57 disher kernel:  [<c01932f3>] diWrite+0x4ab/0x4b5
> Mar  5 14:51:57 disher kernel:  [<c019f852>] lmWriteRecord+0x277/0x313
> Mar  5 14:51:57 disher kernel:  [<c0189266>] jfs_get_block+0x0/0x26f
> Mar  5 14:51:57 disher kernel:  [<c013b778>] find_get_pages_tag+0x38/0x77
> Mar  5 14:51:57 disher kernel:  [<c0175239>] mpage_writepages+0x1e2/0x30b
> Mar  5 14:51:57 disher kernel:  [<c0188ecc>] jfs_writepage+0x0/0xc
> Mar  5 14:51:57 disher kernel:  [<c0189266>] jfs_get_block+0x0/0x26f
> Mar  5 14:51:57 disher kernel:  [<c01118de>] __wake_up+0x32/0x43
> Mar  5 14:51:57 disher kernel:  [<c01a2646>] txEnd+0x56/0x11d
> Mar  5 14:51:57 disher kernel:  [<c0188eb6>] jfs_writepages+0x0/0xa
> Mar  5 14:51:57 disher kernel:  [<c01404cf>] do_writepages+0x20/0x30
> Mar  5 14:51:57 disher kernel:  [<c016b8e5>] __writeback_single_inode+0x198/0x308
> Mar  5 14:51:57 disher kernel:  [<c016bd30>] sync_sb_inodes+0x168/0x211
> Mar  5 14:51:57 disher kernel:  [<c016c0fe>] writeback_inodes+0x63/0xa5
> Mar  5 14:51:57 disher kernel:  [<c0140936>] wb_kupdate+0x7b/0xdf
> Mar  5 14:51:57 disher kernel:  [<c0140c0e>] pdflush+0x0/0x19d
> Mar  5 14:51:57 disher kernel:  [<c0140d17>] pdflush+0x109/0x19d
> Mar  5 14:51:57 disher kernel:  [<c01408bb>] wb_kupdate+0x0/0xdf
> Mar  5 14:51:57 disher kernel:  [<c012693e>] kthread+0xb2/0xdc
> Mar  5 14:51:57 disher kernel:  [<c012688c>] kthread+0x0/0xdc
> Mar  5 14:51:57 disher kernel:  [<c01031af>] kernel_thread_helper+0x7/0x10
> Mar  5 14:51:57 disher kernel:  =======================
> Mar  5 14:51:57 disher kernel: Code: 70 43 8b 4a 18 8b 6c 24 1c 89 4c 24 24 8b 52 04 39 fa 0f 85 75 ff ff ff 85 ed 0f 85 1f 01 00 00 e9 dd 02 00 00 8b 06 a8 08 75 04 <0f> 0b eb fe 8b 7e 14 b9 0c 00 00 00 2b 4c 24 14 8b 44 24 34 8b 
> Mar  5 14:51:57 disher kernel: EIP: [<c0174733>] __mpage_writepage+0x13a/0x48c SS:ESP 0068:c2273db8

