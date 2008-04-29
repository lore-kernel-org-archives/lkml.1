Return-Path: <linux-kernel-owner+w=401wt.eu-S1761044AbYD2PxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044AbYD2PxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYD2PxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:53:14 -0400
Received: from ns.suse.de ([195.135.220.2]:53903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbYD2PxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:53:12 -0400
Date: Tue, 29 Apr 2008 17:54:19 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Solid freezes with 2.6.25
Message-ID: <20080429175419.6c8a0ebf@strauss.suse.de>
In-Reply-To: <20080428092513.495378af.akpm@linux-foundation.org>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
	<20080428092513.495378af.akpm@linux-foundation.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Andrew Morton [2008-04-28 09:25]:
> > 
> > NMI Watchdog detected LOCKUP on CPU 1
> > CPU 1 
> > Modules linked in: edd netconsole configfs i915 radeon drm rfcomm l2cap bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 aead ah4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipt_ULOG microcode ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_x86_64 aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_mod coretemp w83627ehf hwmon_vid snd_hda_intel snd_pcm 8250_pnp snd_timer 8250 sg snd 8139too serial_core video r8169 snd_page_alloc usbhid i2c_i801 sr_mod iTCO_wdt floppy cdrom [last unloaded: netconsole]
> > Pid: 2535, comm: postgres Not tainted 2.6.25 #11
> > RIP: 0010:[<ffffffff8021aa54>]  [<ffffffff8021aa54>] hpet_rtc_interrupt+0x11a/0x2fd
> > RSP: 0000:ffff81012fc77ec8  EFLAGS: 00200097
> > RAX: 0000000000000000 RBX: 0000000000200002 RCX: 0000000000000000
> > RDX: 000000000000c6c6 RSI: 0000000000200002 RDI: ffffffff80655ef8
> > RBP: 000000010011144c R08: ffffffffff5fc128 R09: 0000000000000000
> > R10: 0000000000200046 R11: 0000000000000000 R12: 00000000000000a6
> > R13: ffff81012fcf8800 R14: 0000000000000000 R15: 0000000000000000
> > FS:  0000000000000000(0000) GS:ffff81012fc0f480(0063) knlGS:00000000f7f228e0
> > CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> > CR2: 00000000f1559000 CR3: 0000000128cd8000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process postgres (pid: 2535, threadinfo ffff810128d18000, task ffff81012cbb6930)
> > Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> >  ffffffff00000000 0000000000000001 ffffffff806432c0 ffff81012fe25bc0
> >  0000000000000000 0000000000000000 0000000000000008 ffffffff8025d6d0
> > Call Trace:
> >  <IRQ>  [<ffffffff8025d6d0>] ? handle_IRQ_event+0x25/0x53
> >  [<ffffffff8025ec3a>] ? handle_edge_irq+0xdd/0x11c
> >  [<ffffffff8020c0cc>] ? call_softirq+0x1c/0x28
> >  [<ffffffff8020e26a>] ? do_IRQ+0xf1/0x15f
> >  [<ffffffff8020b451>] ? ret_from_intr+0x0/0xa
> >  <EOI> 
> > 
> > Code: a0 28 00 bf 0a 00 00 00 48 89 c3 e8 73 6b ff ff 48 89 de 41 88 c4 48 c7 c7 f8 5e 65 80 e8 14 a1 28 00 45 84 e4 78 04 eb 12 f3 90 <48> 8b 05 25 1e 3e 00 48 29 e8 48 83 f8 04 76 ee 48 c7 c7 f8 5e 
> > ---[ end trace 8625c90c6582673f ]---
> > Kernel panic - not syncing: Aiee, killing interrupt handler!
> > 
> > Also, I have these messages in syslog:
> > 
> > Apr 28 13:13:31 boogie kernel: rtc: lost 157 interrupts
> > Apr 28 13:13:32 boogie kernel: rtc: lost 37 interrupts
> > Apr 28 13:25:37 boogie kernel: rtc: lost 60 interrupts
> > 
> > More info about the machine is attached. I've also seen similar hangs with
> > 2.6.25-rc6 on an nforce4/Athlon64 box but I'm reluctant to re-test there
> > because RAID rebuild takes too long.
> 
> I don't see any loop in hpet_rtc_interrupt() which can lock up so I assume
> that for some reason we stop clearing the interrupt source and we
> continuously reenter the interrupt handler.

Hm ..., can you mail /proc/interrupts of the affected system? According
to the HPET specification 
 

  General Interrupt Status Register Field Definitions
  --------------------------------------------------------

  T2_INT_STS  Timer 2 Interrupt Active: Same functionality as Timer 0.
  T1_INT_STS  Timer 1 Interrupt Active: Same functionality as Timer 0.
  T0_INT_STS  Timer 0 Interrupt Active:
  
               The functionality of this bit depends on whether the edge
               or level-triggered mode is used for this timer:

               If set to level-triggered mode:
                       This bit defaults to 0. This bit will be set by
                       hardware if the corresponding timer interrupt is
                       active. Once the bit is set, it can be cleared by
                       software writing a 1 to the same bit position.
                       Writes of 0 to this bit will have no effect. For
                       example, if the bit is already set a write of 0
                       will not clear the bit.

               If set to edge-triggered mode:
                       This bit should be ignored by software. Software
                       should always write 0 to this bit.

  --------------------------------------------------------

On all systems I checked the interrupt is edge-triggered. So, if your
interrupt is level triggered, that might be the cause.

> Suspicion would have to be directed at the 2.6.25 CONFIG_HPET_EMULATE_RTC
> changes.

Well, can you disable CONFIG_HPET_EMULATE_RTC entirely and try again?

> I think our best bet here would be to persuade someone who knows what's
> going on in there to prepare a debugging patch for you to run with
> (please).  See if we can find out what the code is doing at the time when
> it freezes up.

Can you try that patch and see if the IRQ handler is really called
repeatedly in that case?


        Bernhard


--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -679,6 +679,9 @@ irqreturn_t hpet_rtc_interrupt(int irq,
 {
        struct rtc_time curr_time;
        unsigned long rtc_int_flag = 0;
+       struct hpet __iomem *hpet = hpet_virt_address;
+
+       printk(KERN_INFO "status=%d\n", readl(&hpet->hpet_isr));
 
        hpet_rtc_timer_reinit();
        memset(&curr_time, 0, sizeof(struct rtc_time));
--- a/include/asm-x86/hpet.h
+++ b/include/asm-x86/hpet.h
@@ -35,6 +35,10 @@
 #define        HPET_LEGACY_8254        2
 #define        HPET_LEGACY_RTC         8
 
+#define HPET_T0_INT_STS                (1<<0)
+#define HPET_T1_INT_STS                (1<<1)
+#define HPET_T2_INT_STS                (1<<2)
+
 #define HPET_TN_LEVEL          0x0002
 #define HPET_TN_ENABLE         0x0004
 #define HPET_TN_PERIODIC       0x0008

