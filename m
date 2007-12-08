Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbXLHDu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbXLHDu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXLHDuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:50:21 -0500
Received: from mta13.mail.adelphia.net ([68.168.78.44]:35644 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbXLHDuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:50:19 -0500
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Fri, 07 Dec 2007 19:49:52 -0800
To: linux-kernel@vger.kernel.org
From: jeffunit <jeff@jeffunit.com>
Subject: oops with 2.6.23.1, marvel, software raid, reiserfs and samba
In-Reply-To: <475A0EF4.1020502@am.sony.com>
References: <20071205151147.9db4640b.akpm@linux-foundation.org>
 <47573806.8000808@am.sony.com>
 <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
 <475A0EF4.1020502@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <20071208035018.JENM21128.mta13.adelphia.net@dual-xeon.jeffunit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am running linux kernel 2.6.23.1, which I compiled.
The base system was mandriva 2008.

I have a dual processor pentium III 933 system.
It has 3gb of ram, an intel stl-2 motherboard.
It also has a promise 100 tx2 pata controller,
a supermicro marvell based 8 port pcix sata controller,
and a nvidia pci based video card.

I have the os on a pata drive, and have made a software raid array
consisting of 4 sata drives attached to the pcix sata controller.
I created the array, and formatted with reiserfs 3.6
I have run bonnie++ (filesystem benchmark) on the array without incident.
When I use samba-3.0.25b-4.3 and copy files from a windows machine to 
the fileserver,
every so often, the fileserver crashes or hangs. It seems to happen
more often under heavy samba traffic.
Enclosed is the oops from syslog.
I also have a 'kernel bug' from syslog if that would be helpful.

jeff


Dec  7 17:20:52 sata_fileserver kernel: BUG: unable to handle kernel 
NULL pointer dereference at virtual address 0000000d
Dec  7 17:20:52 sata_fileserver kernel:  printing eip:
Dec  7 17:20:52 sata_fileserver kernel: c02cc820
Dec  7 17:20:52 sata_fileserver kernel: *pde = 00000000
Dec  7 17:20:52 sata_fileserver kernel: Oops: 0000 [#1]
Dec  7 17:20:52 sata_fileserver kernel: SMP
Dec  7 17:20:52 sata_fileserver kernel: Modules linked in: raid456 
async_xor async_memcpy async_tx xor iptable_raw xt_comment xt_policy 
xt_multiport ipt_ULOG ipt_TTL ipt_ttl ipt_TOS ipt_tos ipt_SAME 
ipt_REJECT ipt_REDIRECT ipt_recent ipt_owner ipt_NETMAP 
ipt_MASQUERADE ipt_LOG ipt_iprange ipt_ECN ipt_ecn ipt_CLUSTERIP 
ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip 
nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp 
nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp 
nf_conntrack_sip nf_conntrack_proto_sctp nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_netlink nf_conntrack_netbios_ns 
nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss 
xt_pkttype xt_physdev xt_NFQUEUE xt_NFLOG xt_MARK xt_mark xt_mac 
xt_limit xt_length xt_helper xt_hashlimit ip6_tables xt_dccp 
xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY nfsd xt_tcpudp 
exportfs auth_rpcgss xt_state iptable_nat nf_nat nf_conntrack_ipv4 
nf_conntrack nfs iptable_mangle lockd nfs_acl sunrpc nfnetlink 
iptable_filter ip_table
Dec  7 17:20:52 sata_fileserver kernel:  x_tables af_packet ipv6 
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss 
snd_mixer_oss ipmi_si ipmi_msghandler binfmt_misc loop nls_utf8 ntfs 
dm_mod usb_storage sg sd_mod sata_mv libata scsi_mod video output 
thermal sbs processor fan container button dock battery ac floppy 
snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep 
ehci_hcd snd ohci_hcd i2c_piix4 uhci_hcd soundcore e1000 sworks_agp 
i2c_core ide_cd usbcore agpgart emu10k1_gp gameport tsdev evdev 
reiserfs ide_disk serverworks pdc202xx_new ide_core
Dec  7 17:20:52 sata_fileserver kernel: CPU:    1
Dec  7 17:20:52 sata_fileserver kernel: 
EIP:    0060:[<c02cc820>]    Not tainted VLI
Dec  7 17:20:52 sata_fileserver kernel: EFLAGS: 00210202   (2.6.23.1 #1)
Dec  7 17:20:52 sata_fileserver kernel: EIP is at tcp_recvmsg+0x150/0xbf0
Dec  7 17:20:52 sata_fileserver kernel: eax: 00000000   ebx: 
f55c4b60   ecx: 784e2c7c   edx: f63f63d8
Dec  7 17:20:52 sata_fileserver kernel: esi: 784e2c7a   edi: 
f63f614c   ebp: e21fde24   esp: e21fddc4
Dec  7 17:20:52 sata_fileserver kernel: ds: 007b   es: 007b   fs: 
00d8  gs: 0033  ss: 0068
Dec  7 17:20:52 sata_fileserver kernel: Process smbd (pid: 9524, 
ti=e21fc000 task=f5109000 task.ti=e21fc000)
Dec  7 17:20:52 sata_fileserver kernel: Stack: 00000000 ffffffff 
00000000 c13e5740 f557b000 c03fa300 00000000 e21fde90
Dec  7 17:20:52 sata_fileserver kernel:        f63f60e0 00000000 
00000b64 f63f63d8 000005b4 00000001 00000000 00000000
Dec  7 17:20:52 sata_fileserver kernel:        00000000 000005b4 
e21fde4c 7fffffff e21fde28 00000000 c03a4de0 e21fde90
Dec  7 17:20:52 sata_fileserver kernel: Call Trace:
Dec  7 17:20:53 sata_fileserver kernel:  [<c010542a>] 
show_trace_log_lvl+0x1a/0x30
Dec  7 17:20:53 sata_fileserver kernel:  [<c01054eb>] 
show_stack_log_lvl+0xab/0xd0
Dec  7 17:20:53 sata_fileserver kernel:  [<c01056e1>] 
show_registers+0x1d1/0x2d0
Dec  7 17:20:53 sata_fileserver kernel:  [<c01058f6>] die+0x116/0x250
Dec  7 17:20:53 sata_fileserver kernel:  [<c011f52b>] do_page_fault+0x28b/0x6a0
Dec  7 17:20:53 sata_fileserver kernel:  [<c030938a>] error_code+0x72/0x78
Dec  7 17:20:53 sata_fileserver kernel:  [<c0295423>] 
sock_common_recvmsg+0x43/0x60
Dec  7 17:20:53 sata_fileserver kernel:  [<c029301c>] sock_aio_read+0x11c/0x130
Dec  7 17:20:53 sata_fileserver kernel:  [<c017db30>] do_sync_read+0xd0/0x110
Dec  7 17:20:53 sata_fileserver kernel:  [<c017e47d>] vfs_read+0x12d/0x140
Dec  7 17:20:53 sata_fileserver kernel:  [<c017e8bd>] sys_read+0x3d/0x70
Dec  7 17:20:53 sata_fileserver kernel:  [<c01042fe>] 
sysenter_past_esp+0x6b/0xa1
Dec  7 17:20:53 sata_fileserver kernel:  =======================
Dec  7 17:20:53 sata_fileserver kernel: Code: 6c 39 df 74 59 8d b6 00 
00 00 00 85 db 74 4f 8b 55 cc 8d 43 20 8b 0a 3b 48 18 0f 88 f4 05 00 
00 89 ce 2b 70 18 8b 83 90 00 00 00 <0f> b6 50 0d 89 d0 83 e0 02 3c 
01 8b 43 50 83 d6 ff 39 c6 0f 82
Dec  7 17:20:53 sata_fileserver kernel: EIP: [<c02cc820>] 
tcp_recvmsg+0x150/0xbf0 SS:ESP 0068:e21fddc4
Dec  7 17:21:11 sata_fileserver kernel: 
Shorewall:net2all:DROP:IN=eth0 OUT= 
MAC=00:04:23:a8:12:cf:00:11:2f:42:d4:32:08:00 SRC=192.168.47.120 
DST=192.168.47.101 LEN=60 TOS=0x00 PREC=0x00 TTL=32 ID=9964 
PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=24064
Dec  7 17:21:13 sata_fileserver kernel: 
Shorewall:net2all:DROP:IN=eth0 OUT= 
MAC=00:04:23:a8:12:cf:00:11:2f:42:d4:32:08:00 SRC=192.168.47.120 
DST=192.168.47.101 LEN=60 TOS=0x00 PREC=0x00 TTL=32 ID=9975 
PROTO=ICMP TYPE=8 CODE=0 ID=512 SEQ=24320 

