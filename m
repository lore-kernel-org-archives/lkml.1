Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYLGNsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYLGNsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 08:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYLGNsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 08:48:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:60867 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYLGNsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 08:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=WhwmJB0lKxnzxL06ayMq7/X0HmnwDO253kgCAValZxZrH7mMYcq/QVtBZR99ytJTDR
         CDiJdGHg3ALbBzhB44wsu8TG4gFAV6m9VGDNfcSHAA/SbCsLZQs04yOL3F2FNrNmOfuO
         XkM9tQl6NA1or6V7zVc4ymSgMa4ehWvktZmU4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x29/0x9e()
Date: Sun, 7 Dec 2008 14:47:12 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, petkovbb@gmail.com,
       linux-ide@vger.kernel.org
References: <Pine.SOC.4.64.0812050957050.13897@math.ut.ee> <20081207092111.GD24323@8bytes.org>
In-Reply-To: <20081207092111.GD24323@8bytes.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812071447.13117.bzolnier@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008, Joerg Roedel wrote:
> The IDE core is calling map_sg with invalid parameters. CC'ing the IDE
> maintainers.
> 
> On Fri, Dec 05, 2008 at 09:58:36AM +0200, Meelis Roos wrote:
> > Got this warning on yesterdays 2.6.28-rc7-00105-gfeaf384 with ide-cd and 
> > ali ide driver (full warning at the end of dmesg).

[...]

> > ------------[ cut here ]------------
> > WARNING: at arch/x86/kernel/pci-nommu.c:62 nommu_map_sg+0x29/0x9e()
> > Modules linked in: mga binfmt_misc rfcomm l2cap bluetooth ppdev lp xt_length xt_MARK iptable_mangle ipt_MASQUERADE iptable_nat nf_nat ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables powernow_k8 cpufreq_ondemand cpufreq_userspace cpufreq_powersave cls_fw cls_u32 sch_sfq sch_cbq sit tunnel4 fuse dm_crypt dm_mod ipv6 w83627hf hwmon_vid ide_cd_mod cdrom ide_gd_mod usbhid usblp pata_ali tuner_simple tuner_types tda9887 tda8290 tuner ns558 tvaudio gameport msp3400 rtc_cmos rtc_core rtc_lib snd_intel8x0 snd_ac97_codec ac97_bus bttv snd_bt87x videodev v4l1_compat pcspkr serio_raw ir_common k8temp hwmon snd_pcm snd_seq snd_timer snd_seq_device i2c_ali1535 compat_ioctl32 i2c_algo_bit ehci_hcd alim15x3 i2c_ali15x3 snd v4l2_common videobuf_dma_sg videobuf_core btcx_risc ohci_hcd ssb ide_pci_generic isp1760 soundcore tveeprom ide_core snd_page_alloc 8139too mii uli526x i2c_ali1563 usbcore i2c_core shpchp pci_hotplug parport_pc 
> >  parport ali_agp
> > Pid: 5298, comm: kcminit_startup Not tainted 2.6.28-rc7-00105-gfeaf384 #237
> > Call Trace:
> >  [<c02fc995>] ? printk+0xf/0x12
> >  [<c011cc8a>] warn_on_slowpath+0x41/0x62
> >  [<c0118e3e>] ? default_wake_function+0xb/0xd
> >  [<c0117f1d>] ? enqueue_entity+0x10b/0x113
> >  [<c011841a>] ? enqueue_task_fair+0x1c/0x5e
> >  [<c0107171>] nommu_map_sg+0x29/0x9e
> >  [<f811dfbd>] ide_build_sglist+0x48/0x50 [ide_core]
> >  [<f811e241>] ide_build_dmatable+0x30/0x154 [ide_core]
> >  [<f811e39b>] ide_dma_setup+0x36/0xc7 [ide_core]
> >  [<f804202f>] ali15x3_dma_setup+0x2f/0x35 [alim15x3]
> >  [<f8263f7a>] ide_cd_do_request+0x5fa/0x671 [ide_cd_mod]
> >  [<c01d784e>] ? delay_tsc+0x1d/0x5f
> >  [<f82644ac>] ? cdrom_do_newpc_cont+0x0/0x18 [ide_cd_mod]
> >  [<c01d77f8>] ? __const_udelay+0x18/0x1a
> >  [<f8117f15>] ? __ide_wait_stat+0x81/0xad [ide_core]
> >  [<f8118aa9>] ? ide_wait_stat+0x3f/0x6e [ide_core]
> >  [<f811703e>] ide_do_request+0x726/0x836 [ide_core]
> >  [<f8263978>] ? cdrom_end_request+0x171/0x179 [ide_cd_mod]
> >  [<f8264b5a>] ? cdrom_newpc_intr+0x5ef/0x5fd [ide_cd_mod]
> >  [<f8117ba0>] ? ide_input_data+0x0/0xda [ide_core]
> >  [<f8117307>] ide_intr+0x1b9/0x1f4 [ide_core]
> >  [<f826456b>] ? cdrom_newpc_intr+0x0/0x5fd [ide_cd_mod]
> >  [<c013c4f2>] handle_IRQ_event+0x21/0x48
> >  [<c013d450>] handle_edge_irq+0xc1/0x114
> >  [<c013d38f>] ? handle_edge_irq+0x0/0x114
> >  <IRQ>  [<c010388f>] ? common_interrupt+0x23/0x28
> > ---[ end trace 18d5008b2820bb67 ]---

Seeems to be the same issue as

http://bugzilla.kernel.org/show_bug.cgi?id=11732

I went through 2.6.26..2.6.27-rc7 ide-cd.c / ide-dma.c changes
and I don't see potential candidates.  I'm not even sure if IDE is
the main cause here.  Bisecting will definitely help.

Thanks,
Bart
 
