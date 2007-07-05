Return-Path: <linux-kernel-owner+w=401wt.eu-S1759969AbXGETbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbXGETbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757594AbXGETa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:30:59 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48178 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbXGETa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:30:57 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, marcel@holtmann.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>, greg@kroah.com
In-Reply-To: <1183661171.2756.13.camel@shinybook.infradead.org>
References: <468A7D14.1050505@googlemail.com>
	 <1183599771.2740.19.camel@shinybook.infradead.org>
	 <alpine.LFD.0.98.0707050921000.9434@woody.linux-foundation.org>
	 <1183661171.2756.13.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 15:31:27 -0400
Message-Id: <1183663888.2756.19.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 14:46 -0400, David Woodhouse wrote:
> Oh, I suck. I failed to noticed that it had oopsed earlier, in slab
> debugging. I shall look at my 'obviously correct' slab patch a little
> harder, now that I'm not distracted by the fireworks.

Hm, it's not something new. It's an oops I saw occasionally in 2.6.21-rc
too, whenever we had CONFIG_SYSFS_DEPRECATED set.

 Unable to handle kernel paging request for data at address 0x6b6b6b6b
 Faulting instruction address: 0xc001870c
 Oops: Kernel access of bad area, sig: 11 [#1]
 PowerMac
 Modules linked in: radeon(U) drm(U) hidp(U) hci_usb(U) rfcomm(U) l2cap(U) bluetooth(U) ipv6(U) nls_utf8(U) hfsplus(U) dm_mirror(U) dm_mod(U) therm_adt746x(U) parport_pc(U) lp(U) parport(U) loop(U) snd_aoa_i2sbus(U) snd_powermac(U) snd_seq_dummy(U) snd_seq_oss(U) snd_seq_midi_event(U) snd_seq(U) ide_cd(U) cdrom(U) snd_seq_device(U) pmac_zilog(U) snd_pcm_oss(U) snd_mixer_oss(U) snd_pcm(U) snd_timer(U) snd_page_alloc(U) snd(U) soundcore(U) snd_aoa_soundbus(U) firewire_ohci(U) firewire_core(U) crc_itu_t(U) sungem(U) sungem_phy(U) bcm43xx(U) ieee80211softmac(U) ieee80211(U) ieee80211_crypt(U) ext3(U) jbd(U) mbcache(U) ehci_hcd(U) ohci_hcd(U) uhci_hcd(U)
 NIP: c001870c LR: c0134fec CTR: c01d5078
 REGS: eed5bdc0 TRAP: 0300   Not tainted  (2.6.22-0.9.rc7.git3.fc8)
 MSR: 00009032 <EE,ME,IR,DR>  CR: 22000224  XER: 20000000
 DAR: 6b6b6b6b, DSISR: 40000000
 TASK = ef72a950[1753] 'khidpd_00000000' THREAD: eed5a000
 GPR00: 6b6b6b6b eed5be70 ef72a950 6b6b6b6b 6b6b6b6a ef18a3a0 0000001a ec8701c6 
 GPR08: 000007aa 00000014 00000000 00000005 00000000 2002163c 100d0000 00000000 
 GPR16: 00000000 7fb9a006 00000003 00000000 ee12cb08 c038cf20 ec870170 c037bf38 
 GPR24: ef6bab08 ec8701c6 0000001a 000007aa 00000001 ef6babb0 ef6babb0 000000d0 
 NIP [c001870c] strlen+0x4/0x18
 LR [c0134fec] kobject_get_path+0x34/0xc4
 Call Trace:
 [eed5be70] [c0098030] __kmalloc_track_caller+0x13c/0x164 (unreliable)
 [eed5be90] [c01d5124] class_uevent+0xac/0x1bc
 [eed5bed0] [c01357e4] kobject_uevent_env+0x23c/0x460
 [eed5bf20] [c01d485c] class_device_del+0x178/0x1a0
 [eed5bf40] [c01d489c] class_device_unregister+0x18/0x30
 [eed5bf60] [c021f820] input_unregister_device+0xf4/0x130
 [eed5bf70] [c0242f4c] hidinput_disconnect+0x2c/0x60
 [eed5bf90] [f27f2bac] hidp_session+0x550/0x584 [hidp]
 [eed5bff0] [c0013e28] kernel_thread+0x44/0x60
 Instruction dump:
 4082fff4 4e800020 38a3ffff 3884ffff 8c650001 2c830000 8c040001 7c601851 
 4d860020 4182ffec 4e800020 3883ffff <8c040001> 2c000000 4082fff8 7c632050 


-- 
dwmw2

