Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXEFL5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXEFL5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 07:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXEFL5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 07:57:03 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:40541 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbXEFL5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 07:57:00 -0400
Date: Sun, 6 May 2007 13:56:58 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21] kernel panic
Message-ID: <20070506115651.GA13183@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon May  7 13:53:21 CEST 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few moments ago a system of mine running 2.6.21 on a P4 with
hyperthreading, 2GB ram, IDE disk, crashed:

[10371.128320] BUG: unable to handle kernel paging request at virtual address 00100100
[10371.128419]  printing eip:
[10371.128462] c118ebb3
[10371.128502] *pde = 00000000
[10371.128544] Oops: 0000 [#1]
[10371.128584] SMP
[10371.128691] Modules linked in: tuner tvaudio bttv video_buf ir_common i2c_algo_bit btcx_risc tveeprom wcfxo pl2303 zaptel usbserial pwc nfs w83627hf hwmon_vid eeprom plusb i2c_isa i2c_core usbnet snd_pcm_oss snd_mixer_oss snd_intel8x0 snd_ac97_codec sd_mod snd_pcm scsi_mod snd_timer snd ide_cd soundcore cdrom snd_page_alloc ac97_bus parport_pc parport microcode firmware_class netconsole nfsd exportfs lockd sunrpc ipt_owner ip6table_filter ip6_tables ipv6 ipt_recent xt_limit xt_state act_police sch_ingress cls_u32 sch_sfq sch_cbq ipt_REJECT ipt_MASQUERADE ipt_TOS xt_tcpudp iptable_mangle iptable_filter rtl8150 e1000 3c59x mii iptable_nat ip_tables nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink x_tables capability commoncap ppp_deflate zlib_deflate zlib_inflate ppp_async crc_ccitt ppp_generic slip slhc genrtc rd
[10371.131693] CPU:    0
[10371.131694] EIP:    0060:[<c118ebb3>]    Not tainted VLI
[10371.131696] EFLAGS: 00210046   (2.6.21 #3)
[10371.131825] EIP is at hiddev_send_event+0xa1/0xd3
[10371.131869] eax: 000ffaec   ebx: 000ffaec   ecx: 00020001   edx: 00100100
[10371.131917] esi: c133ee20   edi: f74042b0   ebp: c133ee18   esp: c133ee04
[10371.131963] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[10371.132008] Process snmpget (pid: 5471, ti=c133e000 task=ca0de030 task.ti=cc954000)
[10371.132052] Stack: 00000000 f7404280 c2725164 f7671000 c2725164 c133ee48 c118ec41 00000001
[10371.132418]        00000000 00000000 00000005 ffa10003 00000000 00200046 f7404288 f7671000
[10371.132800]        c118ebe5 c133ee64 c119df5a 00000000 c27250c0 e9518580 00000000 00000008
[10371.133169] Call Trace:
[10371.133251]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[10371.133336]  [<c1004e0a>] show_stack_log_lvl+0x8d/0xaa
[10371.133416]  [<c1005044>] show_registers+0x1cd/0x2cb
[10371.133496]  [<c10052a1>] die+0x11b/0x227
[10371.133575]  [<c121181f>] do_page_fault+0x319/0x57a
[10371.133662]  [<c120fdfc>] error_code+0x7c/0x84
[10371.133746]  [<c118ec41>] hiddev_hid_event+0x5c/0x63
[10371.133828]  [<c119df5a>] hid_process_event+0x6e/0x7b
[10371.133913]  [<c119e0f7>] hid_input_field+0x190/0x328
[10371.134003]  [<c119e671>] hid_input_report+0xb3/0xf6
[10371.134086]  [<c118cfe7>] hid_irq_in+0x164/0x169
[10371.134164]  [<c1173dba>] usb_hcd_giveback_urb+0x47/0xa4
[10371.134243]  [<c118b128>] uhci_giveback_urb+0x74/0x130
[10371.134322]  [<c118b271>] uhci_scan_qh+0x8d/0x1ed
[10371.134399]  [<c118b532>] uhci_scan_schedule+0x81/0x113
[10371.134476]  [<c118c215>] uhci_irq+0xb4/0x14d
[10371.134553]  [<c1173e3c>] usb_hcd_irq+0x25/0x5d
[10371.134632]  [<c104db36>] handle_IRQ_event+0x28/0x5b
[10371.134711]  [<c104ecb9>] handle_fasteoi_irq+0x67/0xbe
[10371.134788]  [<c1005dd7>] do_IRQ+0x86/0xe5
[10371.134867]  =======================
[10371.134908] Code: 00 06 00 00 b9 01 00 02 00 89 54 18 14 8d 83 0c 06 00 00 ba 1d 00 00 00 e8 7c be ee ff 8b 93 14 06 00 00 8d 82 ec f9 ff ff 89 c3 <8b> 80 14 06 00 00 0f 18 00 90 39 fa 75 80 8b 45 f0 b9 01 00 00
[10371.137290] EIP: [<c118ebb3>] hiddev_send_event+0xa1/0xd3 SS:ESP 0068:c133ee04
[10371.137413] Kernel panic - not syncing: Fatal exception in interrupt
[10371.137460] BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
[10371.137504]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
[10371.137583]  [<c1004d7b>] show_trace+0x12/0x14
[10371.137662]  [<c1004e75>] dump_stack+0x16/0x18
[10371.137740]  [<c100df63>] smp_call_function+0x10f/0x114
[10371.137819]  [<c100dfb9>] smp_send_stop+0x1e/0x31
[10371.137897]  [<c101ca83>] panic+0x50/0xf5
[10371.137976]  [<c100539e>] die+0x218/0x227
[10371.138054]  [<c121181f>] do_page_fault+0x319/0x57a
[10371.138136]  [<c120fdfc>] error_code+0x7c/0x84
[10371.138213]  [<c118ec41>] hiddev_hid_event+0x5c/0x63
[10371.138293]  [<c119df5a>] hid_process_event+0x6e/0x7b
[10371.138378]  [<c119e0f7>] hid_input_field+0x190/0x328
[10371.138458]  [<c119e671>] hid_input_report+0xb3/0xf6
[10371.138541]  [<c118cfe7>] hid_irq_in+0x164/0x169
[10371.138633]  [<c1173dba>] usb_hcd_giveback_urb+0x47/0xa4
[10371.138719]  [<c118b128>] uhci_giveback_urb+0x74/0x130

I reported other bugs on circular locks also happening in this show_trace_log_lvl part.


Folkert van Heusden

-- 
Temperature outside:    23.562500, temperature livingroom: 24.4
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
