Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbXFTWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbXFTWRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXFTWRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:17:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXFTWQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:16:58 -0400
Message-ID: <4679A74F.4010901@redhat.com>
Date: Wed, 20 Jun 2007 18:16:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: oops with USB serial irda adapter
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241598]

Oops happens here in kernel 2.6.20.11:
drivers/usb/serial/ir-usb.c, line 557:

                /* Notify the tty driver that the termios have changed. */
                port->tty->ldisc.set_termios(port->tty, NULL);

(ldisc.set_termios is NULL)

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000 [#1]
SMP 
last sysfs file: /class/usb_device/usbdev2.2/dev
Modules linked in: irda_usb ir_usb usbserial irnet ppp_generic slhc irtty_sir sir_dev ircomm_tty ircomm irda crc_ccitt fuse radeon drm ipv6 autofs4 hidp rfcomm l2cap bluetooth sunrpc nf_conntrack_ftp nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables dm_multipath video sbs i2c_ec dock button battery ac lp floppy snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq tulip parport_pc snd_pcm_oss snd_mixer_oss parport snd_pcm pcspkr bt878 bttv snd_seq_device video_buf ir_common iTCO_wdt snd_timer compat_ioctl32 i2c_algo_bit snd_page_alloc btcx_risc iTCO_vendor_support snd_util_mem tveeprom videodev snd_hwdep v4l2_common snd v4l1_compat emu10k1_gp i2c_i801 ide_cd gameport serio_raw i2c_core soundcore cdrom dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd
 ohci_hcd uhci_hcd
CPU:    0
EIP:    0060:[<00000000>]    Not tainted VLI
EFLAGS: 00210246   (2.6.20-1.2948.fc6 #1)
EIP is at 0x0
eax: d1016800   ebx: 0000000d   ecx: d1016800   edx: 00000000
esi: d1016800   edi: c0805ed8   ebp: e2512800   esp: c6197e04
ds: 007b   es: 007b   ss: 0068
Process irattach (pid: 6007, ti=c6197000 task=d1d053b0 task.ti=c6197000)
Stack: f0f2bca1 00200286 00200286 d101680c c05357f5 00000005 0000000b e2512800 
       c6197e50 c0805ed8 d1016800 f0f0f249 7f1c0300 01000415 00000003 00000000 
       00000000 d1016800 f0d394b0 00000005 00000000 000008bd 00000000 7f1c030b 
Call Trace:
 [<f0f2bca1>] ir_set_termios+0x1e4/0x2a3 [ir_usb]
 [<c05357f5>] set_termios+0x2fc/0x312
 [<f0f0f249>] serial_set_termios+0x83/0x89 [usbserial]
 [<f0d394b0>] irtty_open+0x5f/0x113 [irtty_sir]
 [<c0532f38>] tty_ioctl+0x86f/0xae7
 [<c0533d11>] n_tty_open+0x0/0x8a
 [<c0533cec>] n_tty_close+0x0/0x25
 [<c0533bff>] n_tty_flush_buffer+0x0/0x43
 [<c0533b04>] n_tty_chars_in_buffer+0x0/0x57
 [<c0534dfd>] read_chan+0x0/0x543
 [<c0533d9b>] write_chan+0x0/0x28f
 [<c053580b>] n_tty_ioctl+0x0/0x411
 [<c05338e7>] n_tty_set_termios+0x0/0x1c3
 [<c0534cf0>] normal_poll+0x0/0x10d
 [<c053402a>] n_tty_receive_buf+0x0/0xcc6
 [<c0533aaa>] n_tty_write_wakeup+0x0/0x27
 [<c045d846>] __handle_mm_fault+0x898/0x8ba
 [<c045f26f>] unmap_region+0xd8/0xf7
 [<c0478445>] do_ioctl+0x4d/0x63
 [<c047869f>] vfs_ioctl+0x244/0x256
 [<c04786fd>] sys_ioctl+0x4c/0x67
 [<c0403fe0>] syscall_call+0x7/0xb
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:c6197e04
