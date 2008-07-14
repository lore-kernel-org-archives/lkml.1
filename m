Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYGNXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYGNXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759410AbYGNXdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:33:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759409AbYGNXdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:33:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 14
Date: Tue, 15 Jul 2008 01:35:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20080714201249.947400d0.sfr@canb.auug.org.au>
In-Reply-To: <20080714201249.947400d0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807150135.38701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of July 2008, Stephen Rothwell wrote:
> Hi all,

Hi,

> With the opening of the merge window, I am hoping my job becomes easier
> again ... :-)

I get something like this on one of my test boxes (full dmesg at
http://www.sisk.pl/kernel/debug/20080714/dmesg-asus_L5D.log):

------------[ cut here ]------------
WARNING: at /home/rafael/src/linux-next/arch/x86/mm/pageattr.c:592 __change_page_attr_set_clr+0x8bf/0x9d0()
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device dm_crypt reiserfs dm_mod arc4 ecb crypto_blkcipher b43 rfkill pcmcia mac80211 cfg80211 input_polldev ppdev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm joydev yenta_socket rtc_cmos sr_mod ohci1394 snd_timer rsrc_nonstatic snd skge pcmcia_core ieee1394 ssb asus_laptop cdrom sg video i2c_nforce2 parport_pc soundcore output backlight parport ac battery button snd_page_alloc led_class i2c_core evdev usbhid ff_memless sd_mod ehci_hcd ohci_hcd amd74xx ext3 jbd fan pata_amd libata scsi_mod dock thermal processor
Pid: 3873, comm: acpidump Not tainted 2.6.26-next #21

Call Trace:
 [<ffffffff8023ab6f>] warn_on_slowpath+0x5f/0x80
 [<ffffffff8023bd67>] ? printk+0x67/0x70
 [<ffffffff802c52dd>] ? __d_lookup+0xcd/0x190
 [<ffffffff80225c9f>] __change_page_attr_set_clr+0x8bf/0x9d0
 [<ffffffff802b9b34>] ? do_lookup+0x84/0x210
 [<ffffffff802b9587>] ? permission+0xc7/0x130
 [<ffffffff802c5d71>] ? dput+0x81/0x110
 [<ffffffff802ab621>] ? check_poison_obj+0x31/0x1f0
 [<ffffffff80226c28>] ? reserve_memtype+0xf8/0x310
 [<ffffffff80225e4f>] change_page_attr_set_clr+0x9f/0x1d0
 [<ffffffff8049dbb6>] ? _spin_unlock+0x26/0x30
 [<ffffffff80226073>] _set_memory_uc+0x13/0x20
 [<ffffffff80224b45>] ioremap_change_attr+0x25/0x40
 [<ffffffff80226f49>] phys_mem_access_prot_allowed+0x109/0x170
 [<ffffffff802abea9>] ? cache_alloc_debugcheck_after+0x99/0x230
 [<ffffffff803915a5>] mmap_mem+0x35/0xb0
 [<ffffffff8029c09a>] mmap_region+0x17a/0x4c0
 [<ffffffff8049d6ba>] ? __down_write_nested+0x1a/0xc0
 [<ffffffff8029cb6b>] do_mmap_pgoff+0x3ab/0x3d0
 [<ffffffff80210e1c>] sys_mmap+0xfc/0x130
 [<ffffffff8020b6ab>] system_call_after_swapgs+0x7b/0x80

---[ end trace f1b1c6f21f48e09f ]---
acpidump:3873 /dev/mem ioremap_change_attr failed uncached-minus for 5ff40000-5ff41000
