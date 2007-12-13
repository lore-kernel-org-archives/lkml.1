Return-Path: <linux-kernel-owner+w=401wt.eu-S1764757AbXLMREw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764757AbXLMREw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 12:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762562AbXLMREj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 12:04:39 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:40566 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbXLMREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 12:04:37 -0500
Date: Thu, 13 Dec 2007 15:04:23 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: info@crossnet.co.jp
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.24-rc5: mtd: PNC-2000 oops
Message-ID: <20071213150423.4bf278c1@mandriva.com.br>
Organization: Mandriva
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hi there,

 If I run:

# modprobe pnc2000

 In a machine w/o mtd hardware, I get the following oops:

Photron PNC-2000 flash mapping: 400000 at bf000000
BUG: unable to handle kernel paging request at virtual address bf000000
printing eip: e0bfe05b *pde = 00000000 
Oops: 0002 [#1] 
Modules linked in: cfi_probe gen_probe pnc2000 mtd chipreg map_funcs nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss ipv6 snd_mixer_oss binfmt_misc loop dm_mirror dm_mod sata_via libata scsi_mod floppy cpufreq_ondemand cpufreq_conservative cpufreq_powersave freq_table firewire_ohci firewire_core crc_itu_t snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device i2c_viapro ehci_hcd snd uhci_hcd i2c_core soundcore 8139cp ide_cd cdrom ohci1394 usbcore ieee1394 via_agp 8139too mii agpgart shpchp pci_hotplug evdev ext3 jbd ide_disk ide_generic via82cxxx ide_core

Pid: 4067, comm: modprobe Not tainted (2.6.24-0.rc5.1mdv #1)
EIP: 0060:[<e0bfe05b>] EFLAGS: 00010286 CPU: 0
EIP is at simple_map_write+0x2a/0x34 [map_funcs]
EAX: 00000004 EBX: e0c3f5d0 ECX: bf000000 EDX: 00f000f0
ESI: e0c3f5d0 EDI: 00000002 EBP: dc913dbc ESP: dc913db8
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 4067, ti=dc912000 task=df0409f0 task.ti=dc912000)
Stack: 00000004 dc913e18 e0cc1277 dc913e30 c012b89b 00000000 00000001 00000002 
       c04a2b7c 00000008 00000000 00000000 c043cde4 00000000 c0357ccb dc913e1c 
       dc913e1c 00000204 00000000 00000000 e0c00a54 e0cc119d 00000002 00000002 
Call Trace:
 [<c01054f2>] show_trace_log_lvl+0x1a/0x2f
 [<c01055a2>] show_stack_log_lvl+0x9b/0xa3
 [<c0105650>] show_registers+0xa6/0x177
 [<c0105823>] die+0x102/0x1ee
 [<c02cb4d2>] do_page_fault+0x561/0x63f
 [<c02c9d1a>] error_code+0x6a/0x70
 [<e0cc1277>] cfi_probe_chip+0xda/0x9c7 [cfi_probe]
 [<e0c43123>] mtd_do_chip_probe+0x77/0x2d4 [gen_probe]
 [<e0cc119b>] cfi_probe+0xd/0xf [cfi_probe]
 [<e0c00142>] do_map_probe+0x3d/0x5a [chipreg]
 [<e0c4103b>] init_pnc2000+0x3b/0x68 [pnc2000]
 [<c0140d10>] sys_init_module+0x12c6/0x1394
 [<c0103e42>] sysenter_past_esp+0x6b/0xc9
 =======================
Code: c3 55 89 e5 53 89 c3 8b 40 18 83 f8 01 75 07 03 4b 10 88 11 eb 17 83 f8 02 75 08 03 4b 10 66 89 11 eb 0a 83 f8 04 75 05 03 4b 10 <89> 11 f0 83 04 24 00 5b 5d c3 55 89 e5 57 89 d7 8b 55 08 56 89 
EIP: [<e0bfe05b>] simple_map_write+0x2a/0x34 [map_funcs] SS:ESP 0068:dc913db8

-- 
Luiz Fernando N. Capitulino
