Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYDCPJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYDCPJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 11:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYDCPJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 11:09:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758000AbYDCPJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:09:24 -0400
Date: Thu, 03 Apr 2008 11:08:25 -0500 (EST)
Message-Id: <20080403.110825.07645490.k-ueda@ct.jp.nec.com>
To: schwidefsky@de.ibm.com
Cc: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com,
       jens.axboe@oracle.com, zaitcev@redhat.com, k-ueda@ct.jp.nec.com,
       m-ikeda@ds.jp.nec.com
Subject: Re: kernel BUG at drivers/block/ub.c:820!
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <1207212156.5602.5.camel@localhost>
References: <1207212156.5602.5.camel@localhost>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

On Thu, 03 Apr 2008 10:42:36 +0200, Martin Schwidefsky wrote:
> kernel BUG at drivers/block/ub.c:820!
> invalid opcode: 0000 [#1] PREEMPT
> Modules linked in: usb_storage ub ipt_LOG xt_limit ipt_REJECT xt_tcpudp
> xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> iptable_filter ip_tables x_tables deflate zlib_deflate ctr twofish
> twofish_common camellia serpent blowfish des_generic cbc aes_i586
> aes_generic xcbc sha256_generic sha1_generic crypto_null af_key
> nls_iso8859_1 nsl_cp437 vfat fat fuse dm_crypt crypto_blkcipher
> dm_snapshot dm_mirror dm_mod freq_table ide_generic ide_disk irtty_sir
> mousedev sir_dev snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
> snd_mixer_oss snd_pcm snd_timer pcmcia nsc_ircc snd_ipw2200 psmouse
> sdhci irda ieee80211 ieee80211_crypt serio_raw soundcore i2c_i801 rtc
> crc_ccitt parport_pc parport 8250_pnp pcspkr snd_page_alloc i2c_core
> 8250_pci yenta_socket rsrc_nonstatic pcmcia_core mmc_core firmware_class
> video output intel_agp agpgart evdev thinkpad_acpi sg sr_mod sd_mod
> ide_pci_generic ata_piix floppy pata_acpi libata scsi_mod ehci_hcd
> uhci_hcd usbcore tg3 unix ide_cd_mod cdrom
> 
> Pid: 3893, comm: udevd Not tainted (2.6.25-rc8 #4)
> EIP: 0060:[<f8ca6b99>] EFLAGS: 00010002 CPU: 0
> EIP is at ub_end_rq+0x2b/0x33 [ub]
> EAX: 00000001 EBX: f78f296c ECX: 00000024 EDX: 00000001
> ESI: 00000000 EDI: f7bb5ad4 EBP: f79fde0c ESP: f79fde04
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process udevd (pid: 3893, ti=f79fc000 task=f64e01b0 task.ti=f79fc000)
> Stack: f7bb5ad4 00000000 f79fde34 f8ca6fa1 f7b6f400 f7bb5a00 f7bb5a34 f78f296c
>        00000086 f7b6f400 f7b6f400 f7bb5ad4 f79fde48 f8ca73b6 f7b6f400 c03ec2ec
>        0000000a f79fde6c f8ca7c06 f7b6f5c0 f7b6f550 00000286 f7bb5ad4 00000000
> Call Trace:
>  [<f8ca6fa1>] ? ub_rw_cmd_done+0x1c2/0x1d8 [ub]
>  [<f8ca73b6>] ? ub_scsi_urb_compl+0x31c/0x35b [ub]
>  [<f8ca7c06>] ? ub_scsi_action+0x18f/0x1c4 [ub]
>  [<c011e0bf>] ? tasklet_action+0x35/0x56
>  [<c011e01e>] ? __do_softirq+0x38/0x7a
>  [<c011e085>] ? do_softirq+0x25/0x2a
>  [<c011e1db>] ? irq_exit+0x28/0x61
>  [<c010630f>] ? do_IRQ+0x58/0x6d
>  [<c01052c3>] ? common_interrupt+0x23/0x28
>  [<c024cf52>] ? skb_dequeue+0x3d/0x50
>  [<c024d2a0>] ? skb_queue_purge+0x14/0x1b
>  [<f8843544>] ? unix_sock_destructor+0xe/0xb4 [unix]
>  [<f8841e65>] ? unix_release+0x1a/0x20 [unix]
>  [<c0248ee6>] ? sock_release+0x14/0x6f
>  [<c02492fe>] ? sock_close+0x29/0x30
>  [<c015afa5>] ? __fput+0x93/0x14a
>  [<c015b1e4>] ? fput+0x16/0x18
>  [<c0158aad>] ? filp_close+0x50/0x5a
>  [<c0159d1e>] ? sys_close+0x6f/0xb9
>  [<c01048b2>] ? sysenter_past_esp+0x5f/0x85
>  [<c02a0000>] ? __xfrm_state_bump_genids+0x22/0xfd
>  =======================
> Code: 55 89 e5 56 31 f6 85 d2 53 89 c3 74 08 89 50 7c be fb ff ff ff 89 d8 e8 75
>  b5 51 c7 89 f2 89 c1 89 d8 e8 30 c0 51 c7 85 c0 74 04 <0f> 0b eb fe 5b 5e 5d c3
>  55 89 e5 57 56 53 83 ec 14 89 45 e8 8b
> EIP: [<f8ca6b99>] ub_end_rq+0x2b/0x33 [ub] SS:ESP 0068:f79fde04
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> Looking at the code I find:
> 
> static void ub_end_rq(struct request *rq, unsigned int scsi_status)
> {
>         int error;
> 
> 	if (scsi_status == 0) {
> 		error = 0;
> 	} else {
> 		error = -EIO;
> 		rq->errors = scsi_status;
> 	}
> 	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> 		BUG();  <-- kernel crashes here.
> 	}
> }
> 
> With git bisect I could came up with:
> 610d8b0c972e3b75493efef8e96175518fd736d3 good
> 3bcddeac1c4c7e6fb90531b80f236b1a05dfe514 compile error
> 5450d3e1d68f10be087f0855d8bad5458b50ecbe compile error
> b8286239ddaf2632cec65c01e68a403ac4c3d079 compile error
> 7d699bafe258ebd8f9b4ec182c554200b369a504 bad

I believe the patch from Pete fixes this BUG():
    http://marc.info/?l=linux-usb&m=120613888005382&w=2

Could you try that?

Original ub driver was probably ignoring bio completion on BLOCK_PC,
and I missed the conversion to blk_end_request for BLOCK_PC.
Sorry about that.

Thanks,
Kiyoshi Ueda
