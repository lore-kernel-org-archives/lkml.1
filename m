Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYIZO77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYIZO77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 10:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYIZO7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 10:59:51 -0400
Received: from ext-nj2ut-4.online-age.net ([64.14.54.233]:18922 "EHLO
	ext-nj2ut-4.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYIZO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 10:59:49 -0400
X-Greylist: delayed 737 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 10:59:49 EDT
Date: Fri, 26 Sep 2008 16:47:22 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Pascal Terjan <pterjan@gmail.com>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
Message-ID: <20080926144722.GA1582@kipc2.localdomain>
References: <48CE217A.1080409@tuffmail.co.uk> <48CE52EC.9060505@yahoo.com> <48CE650B.6000708@tuffmail.co.uk> <e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8ca35370809251327x19dd4731n18aafc6ca4f40d70@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 080925, Pascal Terjan wrote:
> On Mon, Sep 15, 2008 at 3:37 PM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:
> > Sitsofe Wheeler wrote:
> > The "HC died" message is interesting.  Sounds like the controller for
> > these two USB devices stops working.  Maybe try unloading and reloading
> > the ehci module?  I don't think I can help any more though.
> 
> The issue also exist on 701 on 2.6.27-rc7 so the regression is in the
> kernel not in the hardware
> 
[ deleted ]

something like this happened to me on the latest Fedora 9 kernel
when I turned off my USB hard drive. The second USB drive got killed
by this until ehci reload. 
The F9 kernel is reported tainted (dont know the reason), perhaps can
somebody enlighten me:

Sep 23 19:06:12 kipc2 kernel: Modules linked in: vfat fat reiserfs
usb_storage nls_utf8 cifs nfs lockd nfs_acl tun ipt_MASQUERADE
iptable_nat nf_nat bridge bnep rfcomm l2cap bluetooth ib_iser rdma_cm
ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi
scsi_transport_iscsi fuse sunrpc ipv6 nf_conntrack_netbios_ns
nf_conntrack_ftp ipt_REJECT xt_tcpudp nf_conntrack_ipv4 xt_state
nf_conntrack iptable_filter ip_tables x_tables loop dm_multipath
snd_usb_audio snd_intel8x0 snd_ac97_codec snd_seq_dummy snd_bt87x
ac97_bus snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss
snd_mixer_oss snd_pcm sr_mod cdrom tvaudio snd_usb_lib snd_rawmidi
snd_seq_device snd_hwdep bttv videodev v4l1_compat snd_timer i915
firewire_ohci firewire_core snd ir_common compat_ioctl32 v4l2_common
pata_sil680 ppdev crc_itu_t i2c_i801 tg3 parport_pc videobuf_dma_sg
videobuf_core btcx_risc tveeprom drm i2c_algo_bit i2c_core parport
soundcore iTCO_wdt iTCO_vendor_support pcspkr snd_page_alloc sg floppy
dm_snapshot dm_zero dm_mirror dm_log dm_


Sep 23 19:05:31 kipc2 kernel: usb 1-5: USB disconnect, address 22
Sep 23 19:05:31 kipc2 kernel: usb 1-3: reset high speed USB device using ehci_hcd and address 21
Sep 23 19:05:31 kipc2 kernel: usb_storage: can't resubmit intr, 0000:00:1d.7-3/input0, retval -19
Sep 23 19:05:31 kipc2 kernel: ehci_hcd 0000:00:1d.7: HC died; cleaning up
Sep 23 19:05:31 kipc2 kernel: usb 1-3: USB disconnect, address 0
Sep 23 19:05:32 kipc2 kernel: usb 1-3: device not accepting address 21, error -22
Sep 23 19:05:32 kipc2 kernel: hub 1-0:1.0: cannot reset port 3 (err = -19)
Sep 23 19:05:32 kipc2 kernel: sd 24:0:0:0: [sde] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
Sep 23 19:05:32 kipc2 kernel: end_request: I/O error, dev sde, sector 452332487

.... lots of reiserfs messages...

Sep 23 19:05:42 kipc2 kernel: irq 23: nobody cared (try booting with the "irqpoll" option)
Sep 23 19:05:42 kipc2 kernel: Pid: 29944, comm: npviewer.bin Tainted: G D   2.6.26.3-29.fc9.i686 #1
Sep 23 19:05:42 kipc2 kernel: [<c045ed60>] __report_bad_irq+0x2e/0x6f
Sep 23 19:05:42 kipc2 kernel: [<c045ef63>] note_interrupt+0x1c2/0x217
Sep 23 19:05:42 kipc2 kernel: [<c045e5b8>] ? handle_IRQ_event+0x2a/0x5a
Sep 23 19:05:42 kipc2 kernel: [<c045f512>] handle_fasteoi_irq+0x8f/0xaf
Sep 23 19:05:42 kipc2 kernel: [<c045f483>] ? handle_fasteoi_irq+0x0/0xaf
Sep 23 19:05:42 kipc2 kernel: [<c0406f08>] do_IRQ+0x98/0xc4
Sep 23 19:05:42 kipc2 kernel: [<c04055eb>] common_interrupt+0x23/0x28
Sep 23 19:05:42 kipc2 kernel: [<c0630000>] ?
__down_interruptible+0x4/0x8d
Sep 23 19:05:42 kipc2 kernel: =======================
Sep 23 19:05:42 kipc2 kernel: handlers:
Sep 23 19:05:42 kipc2 kernel: [<c057afbe>] (usb_hcd_irq+0x0/0x7d)
Sep 23 19:05:42 kipc2 kernel: [<c057afbe>] (usb_hcd_irq+0x0/0x7d)
Sep 23 19:05:42 kipc2 kernel: Disabling IRQ #23

Karl

-- 
D.I. Karl Kiniger     mailto:karl.kiniger@med.ge.com
GE Medical Systems Kretztechnik GmbH & Co OHG
Tiefenbach 15         Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
A-4871 Zipf Austria   Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
