Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbZGPP1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbZGPP1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbZGPP1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:27:24 -0400
Received: from mail.uni-paderborn.de ([131.234.142.9]:12083 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446AbZGPP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:27:23 -0400
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2009 11:27:22 EDT
Message-ID: <4A5F410A.7090300@scosu.org>
Date: Thu, 16 Jul 2009 17:02:34 +0200
From: scosu <scosu@scosu.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: XFS raid mount oops
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-IMT-Spam-Score: 0.0 ()
X-PMX-Version: 5.5.5.374460, Antispam-Engine: 2.7.1.369594, Antispam-Data: 2009.7.16.144817
X-IMT-Authenticated-Sender: mpargman@UNI-PADERBORN.DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel-oops when mounting a xfs raid.


Hi,

when i mount a hardware raid with xfs i get a kernel-oops. The raid is
already running for a longer time with xfs. After a reboot the mounting
fails. I can still copy from the device by using dd.

kernel-version:
open-suse patched kernel 2.6.25.18-0.2
vanilla kernel 2.6.30.1

Both with use of pae-extension.


the kernel-oops from dmesg:

XFS mounting filesystem dm-0
Starting XFS recovery on filesystem: dm-0 (logdev: internal)
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<fc5aa5c4>] xlog_recover_do_inode_trans+0x185/0x637 [xfs]
*pdpt = 000000003680e001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/online
Modules linked in: xfs md5 des_generic cbc nfsd exportfs nfs lockd
nfs_acl rpcsec_gss_krb5 auth_rpcgss sunrpc iptable_filter ip_tables
ip6table_filter ip6_tables x_tables ipv6 af_packet microcode fuse loop
dm_mod dcdbas rtc_cmos rtc_core i2c_piix4 tg3 rtc_lib shpchp button
i2c_core pci_hotplug sr_mod sworks_agp sg libphy cdrom agpgart ohci_hcd
sd_mod usbcore edd ext3 mbcache jbd fan thermal processor
pata_serverworks libata aacraid aic7xxx aic79xx scsi_transport_spi
scsi_mod [last unloaded: speedstep_lib]

Pid: 24692, comm: mount Not tainted (2.6.30.1-pae #1) PowerEdge
2650            
EIP: 0060:[<fc5aa5c4>] EFLAGS: 00210246 CPU: 0
EIP is at xlog_recover_do_inode_trans+0x185/0x637 [xfs]
EAX: f5aeeb20 EBX: f6887280 ECX: fc5bb73c EDX: f5aeeb40
ESI: 00000000 EDI: 00000010 EBP: f6c41c34 ESP: f6c41c08
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process mount (pid: 24692, ti=f6c40000 task=f59e25b0 task.ti=f6c40000)
Stack:
 f5aeeb40 f6d36500 f61d4000 f6c62a00 8000011a 00000000 00000000 f5aeeb40
 f5aeeb40 00000002 f5841d80 f6c41c54 fc5aac2a f6d36280 00000000 f5aeeb40
 00000000 f6d36280 f5841d80 f6c41c68 fc5aacc4 f7df8210 fc747874 f6d36280
Call Trace:
 [<fc5aac2a>] ? xlog_recover_do_trans+0x63/0xd8 [xfs]
 [<fc5aacc4>] ? xlog_recover_commit_trans+0x25/0x39 [xfs]
 [<fc5aadf7>] ? xlog_recover_process_data+0x11f/0x193 [xfs]
 [<fc5ab5ff>] ? xlog_do_recovery_pass+0x2a8/0x773 [xfs]
 [<c01fede2>] ? vsnprintf+0x7e/0x30d
 [<c013c5a0>] ? up+0x2b/0x2f
 [<c0128b37>] ? release_console_sem+0x17d/0x1aa
 [<fc5abb30>] ? xlog_do_log_recovery+0x66/0x83 [xfs]
 [<fc5abb60>] ? xlog_do_recover+0x13/0xd8 [xfs]
 [<fc5acb83>] ? xlog_recover+0x73/0x84 [xfs]
 [<fc5a81de>] ? xfs_log_mount+0xcb/0x124 [xfs]
 [<fc5af36a>] ? xfs_mountfs+0x2d4/0x54a [xfs]
 [<fc5b83d4>] ? kmem_zalloc+0xc/0x30 [xfs]
 [<fc5afcba>] ? xfs_mru_cache_create+0xf0/0x128 [xfs]
 [<fc5c0e9c>] ? xfs_fs_fill_super+0x1bc/0x30f [xfs]
 [<c018f683>] ? get_sb_bdev+0xe7/0x125
 [<fc5bf640>] ? xfs_fs_get_sb+0x13/0x15 [xfs]
 [<fc5c0ce0>] ? xfs_fs_fill_super+0x0/0x30f [xfs]
 [<c018f37f>] ? vfs_kern_mount+0x7e/0xe9
 [<c018f42e>] ? do_kern_mount+0x32/0xba
 [<c01a0eb1>] ? do_mount+0x651/0x68b
 [<c01906cd>] ? vfs_stat+0x13/0x15
 [<c016db02>] ? __get_free_pages+0x1e/0x24
 [<c019f525>] ? copy_mount_options+0x2a/0xf9
 [<c01a0f51>] ? sys_mount+0x66/0x9d
 [<c0102ab5>] ? syscall_call+0x7/0xb
Code: 00 00 00 b8 d8 51 5c fc ff 75 04 68 3a 09 00 00 68 8f 4e 5c fc e8
3b 00 ff ff 83 c4 28 e9 a3 04 00 00 8b 55 d4 8b 42 14 8b 70 0c <66> 81
3e 4e 49 74 50 83 7b 78 00 75 07 89 d8 e8 f9 ff 00 00 89
EIP: [<fc5aa5c4>] xlog_recover_do_inode_trans+0x185/0x637 [xfs] SS:ESP
0068:f6c41c08
CR2: 0000000000000000
---[ end trace b4f5a9560f6f1d08 ]---



cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Xeon(TM) CPU 2.40GHz
stepping        : 7
cpu MHz         : 2389.862
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe pebs bts cid
bogomips        : 4779.72
clflush size    : 64
power management:



cat /proc/modules
xfs 431016 3 - Live 0xfc56f000
md5 3836 0 - Live 0xfbb01000
des_generic 16440 1074 - Live 0xfbae1000
cbc 3176 1074 - Live 0xfbabe000
nfsd 210112 5 - Live 0xfba6c000
exportfs 3924 2 xfs,nfsd, Live 0xfb775000
nfs 223044 1 - Live 0xfb717000
lockd 59104 2 nfsd,nfs, Live 0xfb2ba000
nfs_acl 2784 2 nfsd,nfs, Live 0xfb0a9000
rpcsec_gss_krb5 8688 537 - Live 0xfb081000
auth_rpcgss 33684 3 nfsd,nfs,rpcsec_gss_krb5, Live 0xfafdb000
sunrpc 167276 20 nfsd,nfs,lockd,nfs_acl,rpcsec_gss_krb5,auth_rpcgss,
Live 0xfaf2
b000
iptable_filter 2440 0 - Live 0xfac47000
ip_tables 10448 1 iptable_filter, Live 0xfac12000
ip6table_filter 2356 0 - Live 0xfabd0000
ip6_tables 11576 1 ip6table_filter, Live 0xfab9c000
x_tables 14428 2 ip_tables,ip6_tables, Live 0xfab58000
ipv6 221792 26 - Live 0xfaaa4000
af_packet 15608 2 - Live 0xfa529000
microcode 8648 0 - Live 0xf9c7a000
fuse 48324 1 - Live 0xf9c2a000
loop 13868 0 - Live 0xf9b6a000
dm_mod 49376 4 - Live 0xf9a35000
dcdbas 6916 0 - Live 0xf96bb000
rtc_cmos 9608 0 - Live 0xf96b3000
rtc_core 16156 1 rtc_cmos, Live 0xf96aa000
i2c_piix4 9440 0 - Live 0xf96a2000
tg3 96108 0 - Live 0xf9685000
rtc_lib 2796 1 rtc_core, Live 0xf95f4000
shpchp 27712 0 - Live 0xf95c8000
button 5556 0 - Live 0xf9521000
i2c_core 21068 1 i2c_piix4, Live 0xf94ef000
pci_hotplug 24968 1 shpchp, Live 0xf94b3000
sr_mod 12568 0 - Live 0xf9428000
sworks_agp 6912 0 - Live 0xf93b5000
sg 25468 0 - Live 0xf938b000
libphy 19956 1 tg3, Live 0xf933c000
cdrom 30152 1 sr_mod, Live 0xf92b8000
agpgart 31516 1 sworks_agp, Live 0xf9269000
ohci_hcd 20240 0 - Live 0xf91dd000
sd_mod 24360 10 - Live 0xf9191000
usbcore 128732 2 ohci_hcd, Live 0xf912e000
edd 7344 0 - Live 0xf8ef1000
ext3 110808 4 - Live 0xf8ea2000
mbcache 7212 1 ext3, Live 0xf8c7c000
jbd 49520 1 ext3, Live 0xf8c43000
fan 4256 0 - Live 0xf8b7b000
thermal 14116 0 - Live 0xf8b4d000
processor 40596 0 - Live 0xf8b0e000
pata_serverworks 6176 0 - Live 0xf8a59000
libata 153676 1 pata_serverworks, Live 0xf8a00000
aacraid 61536 5 - Live 0xf888c000
aic7xxx 104508 1 - Live 0xf86f4000
aic79xx 119232 1 - Live 0xf8597000
scsi_transport_spi 19520 2 aic7xxx,aic79xx, Live 0xf8461000
scsi_mod 136452 8
sr_mod,sg,sd_mod,libata,aacraid,aic7xxx,aic79xx,scsi_transport
_spi, Live 0xf83fe000


Do you need more information?

Greetings
scosu
