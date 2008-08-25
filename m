Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYHYPy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYHYPy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 11:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYHYPyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 11:54:19 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:56047 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbYHYPyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 11:54:18 -0400
X-Greylist: delayed 1157 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 11:54:17 EDT
Message-ID: <48B2D141.3000205@Think-Future.de>
Date: Mon, 25 Aug 2008 17:35:29 +0200
From: Nils Radtke <Nils.Radtke@Think-Future.de>
Reply-To: lkml@think-future.com
Organization: TF
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: scsi 3:0:0:0: Device offlined - not ready after error recovery
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello everyone,

This is what killed today's backup:

[179890.707759] __ratelimit: 1 messages suppressed
[179890.707759] iwl4965: Can not allocate SKB buffers
[179893.597080] usb 1-3: reset high speed USB device using ehci_hcd and address 4
[179897.768211] __ratelimit: 3 messages suppressed
[179912.139833] iwl4965: Can not allocate SKB buffers
[179923.957095] usb 1-3: reset high speed USB device using ehci_hcd and address 4
[179924.059546] usb 1-3: device descriptor read/64, error -71
[179924.262420] usb 1-3: device descriptor read/64, error -71
[179924.466063] usb 1-3: reset high speed USB device using ehci_hcd and address 4
[179924.568938] usb 1-3: device descriptor read/64, error -71
[179924.771430] usb 1-3: device descriptor read/64, error -71
[179924.974590] usb 1-3: reset high speed USB device using ehci_hcd and address 4
[179925.378430] usb 1-3: device not accepting address 4, error -71
[179925.480512] usb 1-3: reset high speed USB device using ehci_hcd and address 4
[179925.883572] usb 1-3: device not accepting address 4, error -71
[179925.883683] usb 1-3: USB disconnect, address 4
[179925.891869] scsi 3:0:0:0: Device offlined - not ready after error recovery
[179925.895794] scsi 3:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[179925.895810] end_request: I/O error, dev sdb, sector 983000743
[179925.895833] __ratelimit: 1 messages suppressed
[179925.895839] Buffer I/O error on device dm-4, logical block 122874956
[179925.895848] lost page write due to I/O error on dm-4
[179925.895871] Buffer I/O error on device dm-4, logical block 122874957
[179925.895877] lost page write due to I/O error on dm-4
[179925.895891] Buffer I/O error on device dm-4, logical block 122874958
[179925.895897] lost page write due to I/O error on dm-4
[179925.897159] scsi 3:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[179925.897170] end_request: I/O error, dev sdb, sector 983000983
[179925.923837] EXT3-fs error (device dm-4): read_block_bitmap: Cannot read block bitmap - block_group = 3750, block_bitmap = 122880000
[179926.008885] usb 1-3: new high speed USB device using ehci_hcd and address 5
[179926.014597] Aborting journal on device dm-4.
[179926.116010] usb 1-3: device descriptor read/64, error -71
[179926.133120] ext3_abort called.
[179926.133127] EXT3-fs error (device dm-4): ext3_journal_start_sb: Detected aborted journal
[179926.133132] Remounting filesystem read-only
[179926.133250] EXT3-fs error (device dm-4) in ext3_write_begin: IO failure
[179926.148672] __journal_remove_journal_head: freeing b_frozen_data
[179926.324256] usb 1-3: device descriptor read/64, error -71
[179926.527912] usb 1-3: new high speed USB device using ehci_hcd and address 6
[179926.631312] usb 1-3: device descriptor read/64, error -71
[179926.835117] usb 1-3: device descriptor read/64, error -71
[179927.040333] usb 1-3: new high speed USB device using ehci_hcd and address 7
[179927.252621] ------------[ cut here ]------------
[179927.252621] WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x5f/0x80()
[179927.252621] Modules linked in: iwl4965 uvcvideo snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi snd_hwdep vboxdrv iptable_mangle ipt_LOG xt_tcpudp 
xt_state xt_multiport iptable_filter ip_tables x_tables af_packet hdaps tp_smapi thinkpad_ec iwlcore e1000e hci_usb [last unloaded: iwl4965]
[179927.252621] Pid: 9322, comm: umount Tainted: G        W 2.6.26-rc7 #10
[179927.252621]  [<c012f57f>] warn_on_slowpath+0x5f/0x90
[179927.252621]  [<c0146742>] enqueue_hrtimer+0x72/0xf0
[179927.252621]  [<c074b62a>] _spin_unlock_irqrestore+0x2a/0x50
[179927.252621]  [<c0146f00>] hrtimer_start+0xe0/0x190
[179927.252621]  [<c0127374>] hrtick_set+0x84/0x130
[179927.252621]  [<c0748b45>] schedule+0x415/0x9a0
[179927.252621]  [<c01245dd>] try_to_wake_up+0x7d/0x200
[179927.252621]  [<c01b25af>] mark_buffer_dirty+0x5f/0x80
[179927.252621]  [<c020b01f>] journal_update_superblock+0x6f/0xd0
[179927.252621]  [<c020b6fd>] journal_destroy+0x15d/0x1b0
[179927.252621]  [<c0143740>] autoremove_wake_function+0x0/0x50
[179927.252621]  [<c01fe552>] ext3_put_super+0x22/0x1d0
[179927.252621]  [<c01a3df1>] invalidate_inodes+0xd1/0xe0
[179927.252621]  [<c0190805>] generic_shutdown_super+0x55/0xf0
[179927.252621]  [<c01c7f60>] vfs_quota_off+0x0/0x640
[179927.252621]  [<c074a1b9>] down_write+0x39/0x60
[179927.252621]  [<c01c7f60>] vfs_quota_off+0x0/0x640
[179927.252621]  [<c01908ac>] kill_block_super+0xc/0x20
[179927.252621]  [<c0190980>] deactivate_super+0x70/0x90
[179927.252621]  [<c01a6aad>] sys_umount+0x5d/0x370
[179927.252621]  [<c018212d>] free_pages_and_swap_cache+0x8d/0xb0
[179927.252621]  [<c017c6a7>] remove_vma+0x47/0x60
[179927.252621]  [<c017c6a7>] remove_vma+0x47/0x60
[179927.252621]  [<c017d2d6>] do_munmap+0x1a6/0x200
[179927.252621]  [<c0103d9e>] syscall_call+0x7/0xb
[179927.252621]  =======================
[179927.252621] ---[ end trace ecd99c28485ef390 ]---
[179927.267301] EXT3-fs error (device dm-4): ext3_find_entry: reading directory #2 offset 0
[179927.447633] usb 1-3: device not accepting address 7, error -71
[179927.549880] usb 1-3: new high speed USB device using ehci_hcd and address 8
[179927.952878] usb 1-3: device not accepting address 8, error -71
[179927.952919] hub 1-0:1.0: unable to enumerate USB device on port 3
[179928.282788] usb 4-1: new full speed USB device using uhci_hcd and address 2
[179928.395001] usb 4-1: device descriptor read/64, error -71
[179928.609348] usb 4-1: device descriptor read/64, error -71
[179928.812082] usb 4-1: new full speed USB device using uhci_hcd and address 3
[179928.926418] usb 4-1: device descriptor read/64, error -71
[179929.143276] usb 4-1: device descriptor read/64, error -71
[179929.347407] usb 4-1: new full speed USB device using uhci_hcd and address 4
[179929.758001] usb 4-1: device not accepting address 4, error -71
[179929.860600] usb 4-1: new full speed USB device using uhci_hcd and address 5
[179930.269953] usb 4-1: device not accepting address 5, error -71
[179930.270003] hub 4-0:1.0: unable to enumerate USB device on port 1
[179957.558842] __ratelimit: 5044 messages suppressed
[179957.558860] Buffer I/O error on device dm-4, logical block 30
[179957.558868] lost page write due to I/O error on dm-4
[179957.559846] Buffer I/O error on device dm-4, logical block 85196802
[179957.559846] Buffer I/O error on device dm-4, logical block 85196802
[179957.559853] lost page write due to I/O error on dm-4
[179957.559869] Buffer I/O error on device dm-4, logical block 85196803
[179957.559875] lost page write due to I/O error on dm-4
[179957.559892] Buffer I/O error on device dm-4, logical block 85393410
[179957.559897] lost page write due to I/O error on dm-4
[179957.559931] Buffer I/O error on device dm-4, logical block 85590018
[179957.559936] lost page write due to I/O error on dm-4
[179957.559954] Buffer I/O error on device dm-4, logical block 85786626
[179957.559960] lost page write due to I/O error on dm-4
[180103.423035] __ratelimit: 200 messages suppressed
[180103.423035] iwl4965: Can not allocate SKB buffers
[180678.578748] iwl4965: Can not allocate SKB buffers
[181512.696198] __journal_remove_journal_head: freeing b_frozen_data
[181512.696198] __journal_remove_journal_head: freeing b_frozen_data
[181512.696198] __journal_remove_journal_head: freeing b_frozen_data
[181512.696198] __journal_remove_journal_head: freeing b_committed_data
[181512.696198] __journal_remove_journal_head: freeing b_frozen_data
[181512.698618] Buffer I/O error on device dm-4, logical block 1545
[181512.698628] lost page write due to I/O error on dm-4

Some system info:

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz
stepping        : 11
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc 
arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips        : 3610.16
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     L7700  @ 1.80GHz
stepping        : 11
cpu MHz         : 800.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc 
arch_perfmon pebs bts pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm ida
bogomips        : 3591.16
clflush size    : 64
power management:

  17:33:18 up 4 days,  6:51,  8 users,  load average: 0.28, 0.29, 0.26
Linux mypole 2.6.26-rc7 #10 SMP PREEMPT Wed Jun 25 01:15:19 CEST 2008 i686 GNU/Linux
              total       used       free     shared    buffers     cached
Mem:       2042492    1823504     218988          0      43236     769832
-/+ buffers/cache:    1010436    1032056
Swap:      1951856     621164    1330692
Module                  Size  Used by
iwl4965               109048  0
uvcvideo               53688  0
snd_usb_audio          77984  0
snd_usb_lib            15120  1 snd_usb_audio
snd_seq_midi            6528  0
snd_rawmidi            19488  2 snd_usb_lib,snd_seq_midi
snd_hwdep               7052  1 snd_usb_audio
vboxdrv                71632  0
iptable_mangle          2944  0
ipt_LOG                 6144  5
xt_tcpudp               3072  167
xt_state                2176  202
xt_multiport            3200  10
iptable_filter          2816  1
ip_tables              11024  2 iptable_mangle,iptable_filter
x_tables               13332  5 ipt_LOG,xt_tcpudp,xt_state,xt_multiport,ip_tables
af_packet              16784  4
hdaps                  11740  0
tp_smapi               21776  0
thinkpad_ec             6032  2 hdaps,tp_smapi
iwlcore                15232  1 iwl4965
e1000e                 96460  0
hci_usb                13748  0
lenny/sid



The backup is about 100GB (it's the full one..), so not that big.. ;)
The box is a Lenovo Thinkpad X61s.
Need more feedback? Please ask in case there's some crucial information lacking.
I once had a nifty script to collect the data but couldn't find it for some time..
I am not subscribed to lkml, please CC.
This error happened after 2 (or more) hours of backup running to the USBN-disk (sata).
Reproduceability not yet known.

Thank you for your help and have a nice day,

Nils


