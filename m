Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbXLEUpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbXLEUpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXLEUpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:45:04 -0500
Received: from ns1.q-leap.de ([153.94.51.193]:41672 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbXLEUo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:44:57 -0500
From: Bernd Schubert <bs@q-leap.de>
To: linux-kernel@vger.kernel.org, bernd-schubert@gmx.de
Subject: everything in wait_for_completion, what is my system doing?
Date: Wed, 5 Dec 2007 21:44:54 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_G3wVHT4Gd17Nwut"
Message-Id: <200712052144.54399.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_G3wVHT4Gd17Nwut
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

after scsi-recovery a system here went into some kind lock-up, everything 
seems to be in wait_for_completion(). Please see the attached 
blocked_states.txt and all_states.txt files.
This is 2.6.22.12, I can easily find out the line numbers if required.

Any help is highly appreciated.


Thanks in advance,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH

--Boundary-00=_G3wVHT4Gd17Nwut
Content-Type: text/plain;
  charset="us-ascii";
  name="blocked_states.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="blocked_states.txt"

[generate break]
[ 1818.566436] SysRq : Show Blocked State
[ 1818.570260]
[ 1818.570261]                                  free                        sibling
[ 1818.579253]   task                 PC        stack   pid father child younger older
[ 1818.586987] events/7      D 00000155dd642280     0    26      2 (L-TLB)
[ 1818.593747]  ffff81012b529ac0 0000000000000046 0000000000000000 ffff810128280d18
[ 1818.601321]  ffff8100ba2376f8 ffff81012b689630 ffff81012aff76b0 000000078023e215
[ 1818.608870]  000000010003ca14 0000000000000000 ffff810001065400 0000000780430c13
[ 1818.616222] Call Trace:
[ 1818.618925]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1818.624207]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1818.630112]  [<ffffffff8036e5a1>] blk_get_request+0x36/0x6b
[ 1818.635755]  [<ffffffff8042f5cb>] scsi_execute+0x51/0x129
[ 1818.641240]  [<ffffffff880cc11b>] :scsi_transport_spi:spi_execute+0x87/0xf8
[ 1818.648271]  [<ffffffff880cd5ae>] :scsi_transport_spi:spi_dv_device_echo_buffer+0x181/0x27d
[ 1818.656739]  [<ffffffff880cd801>] :scsi_transport_spi:spi_dv_retrain+0x4e/0x240
[ 1818.664139]  [<ffffffff880ce008>] :scsi_transport_spi:spi_dv_device+0x615/0x69c
[ 1818.671542]  [<ffffffff880f16d1>] :mptspi:mptspi_dv_device+0xb3/0x14b
[ 1818.678042]  [<ffffffff880f27d3>] :mptspi:mptspi_dv_renegotiate_work+0xcb/0xef
[ 1818.685348]  [<ffffffff80245bb8>] run_workqueue+0x8e/0x120
[ 1818.690905]  [<ffffffff80245d50>] worker_thread+0x106/0x117
[ 1818.696540]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1818.701474]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1818.706495]
[ 1818.708022] unionfs-fuse- D 000001a76ef63463     0  1119      1 (NOTLB)
[ 1818.714764]  ffff810129765988 0000000000000082 0000000000000000 ffffffff80337e22
[ 1818.722329]  ffff8101297658c8 ffff81012b652f20 ffff810129eec810 0000000600000000
[ 1818.729895]  000000010005204e 0000000000000000 ffff81000105c400 0000000680337c3e
[ 1818.737249] Call Trace:
[ 1818.739953]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1818.745673]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1818.751664]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1818.757300]  [<ffffffff80269b24>] balance_dirty_pages_ratelimited_nr+0x196/0x22f
[ 1818.764781]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1818.771641]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
[ 1818.778852]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
[ 1818.785101]  [<ffffffff8032eb94>] nfs_file_write+0x138/0x1b7
[ 1818.790822]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1818.796372]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1818.801575]  [<ffffffff8028d5df>] sys_pwrite64+0x68/0x96
[ 1818.806959]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1818.812250]  [<00002b4eeec3ea73>]
[ 1818.815620]
[ 1818.817150] syslogd       D 000001a768c4d4d8     0  4160      1 (NOTLB)
[ 1818.823902]  ffff8101259a7928 0000000000000082 0000000000000000 0000000000000000
[ 1818.831467]  ffff81012608eb80 ffff81012b546e60 ffff81012608e9d0 00000002ffffffff
[ 1818.839033]  0000000100052040 0000000000000000 ffff810001038400 0000000200000001
[ 1818.846361] Call Trace:
[ 1818.849074]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1818.854795]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1818.860786]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1818.866421]  [<ffffffff80269b24>] balance_dirty_pages_ratelimited_nr+0x196/0x22f
[ 1818.873910]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1818.880760]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
[ 1818.887964]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
[ 1818.894214]  [<ffffffff8028d70c>] do_sync_readv_writev+0xc1/0x10b
[ 1818.900378]  [<ffffffff8028d9ed>] do_readv_writev+0xda/0x234
[ 1818.906107]  [<ffffffff8028dbe1>] vfs_writev+0x4b/0x50
[ 1818.911318]  [<ffffffff8028dcc3>] sys_writev+0x53/0x8a
[ 1818.916522]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1818.921820]  [<00002b7f7c91cb4c>]
[ 1818.925174]
[ 1818.926697] md4_raid5     D ffffffff8022b582     0  4725      2 (L-TLB)
[ 1818.933455]  ffff810124ebbb60 0000000000000046 0000000000011200 0000000000011210
[ 1818.941013]  ffff8101286018c0 ffff81012afb14f0 ffff810127033160 ffffffff802668c6
[ 1818.948579]  0000000000000020 ffff810128280dd8 ffff8100ba2376f8 000000010003ca03
[ 1818.955931] Call Trace:
[ 1818.958620]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1818.963906]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1818.969811]  [<ffffffff8036f7aa>] __make_request+0x54f/0x611
[ 1818.975533]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1818.981787]  [<ffffffff88194e5b>] :raid456:handle_stripe+0x17cd/0x2c39
[ 1818.988395]  [<ffffffff88197010>] :raid456:raid5d+0x3c2/0x409
[ 1818.994213]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1819.000204]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.005133]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.010162]
[ 1819.011686] md4_resync    D 00000155d5a21578     0  4726      2 (L-TLB)
[ 1819.018431]  ffff810117f9bba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1819.026004]  ffff81012b679c00 ffff81012b510750 ffff81012676b570 0000000128280d18
[ 1819.033571]  000000010003c9e4 0000000000000000 ffff81000102f400 0000000100000005
[ 1819.040906] Call Trace:
[ 1819.043606]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.050376]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1819.056724]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1819.062788]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1819.068782]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.073718]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.078739]
[ 1819.080256] md5_raid5     D 00000155dab12e61     0  4735      2 (L-TLB)
[ 1819.086999]  ffff81010bb7bb60 0000000000000046 0000000000000000 0000000000011210
[ 1819.094555]  ffff8101276d2940 ffff81012b546e60 ffff810126784810 00000002802668c6
[ 1819.102113]  000000010003c9fe 0000000000000000 ffff810001038400 000000020003ca09
[ 1819.109457] Call Trace:
[ 1819.112163]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1819.117450]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1819.123345]  [<ffffffff8036f7aa>] __make_request+0x54f/0x611
[ 1819.129068]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1819.135313]  [<ffffffff88194e5b>] :raid456:handle_stripe+0x17cd/0x2c39
[ 1819.141911]  [<ffffffff88197010>] :raid456:raid5d+0x3c2/0x409
[ 1819.147732]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1819.153721]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.158649]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.163662]
[ 1819.165186] md5_resync    D 00000155d597e77a     0  4736      2 (L-TLB)
[ 1819.171939]  ffff81010b197ba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1819.179504]  ffff810117faa400 ffffffff8068d100 ffff810126784140 0000000028280d18
[ 1819.187045]  000000010003c9f3 0000000000000000 ffff810001026400 0000000000000005
[ 1819.194398] Call Trace:
[ 1819.197105]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.203874]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1819.210207]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1819.216297]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1819.222290]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.227219]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.232247]
[ 1819.235348] md3_resync    D 00000155d1ba400d     0  5024      2 (L-TLB)
[ 1819.242091]  ffff8100ce715ba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1819.249657]  ffff81012860a600 ffff81012b689630 ffff8101260596f0 0000000728280d18
[ 1819.257223]  000000010003c9c9 0000000000000000 ffff810001065400 0000000700000005
[ 1819.264567] Call Trace:
[ 1819.267267]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.274045]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1819.280385]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1819.286467]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1819.292442]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.297363]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.302391]
[ 1819.303909] xfssyncd      D 0000015e2ed14f60     0  5162      2 (L-TLB)
[ 1819.310660]  ffff8100cd679ab0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1819.318226]  ffff810117faa400 ffff81012b5f8810 ffff81012a254180 0000000528280d18
[ 1819.325784]  000000010003ed03 0000000000000000 ffff810001053400 0000000500000005
[ 1819.333128] Call Trace:
[ 1819.335835]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.342605]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1819.348932]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1819.355180]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1819.360402]  [<ffffffff8826794a>] :xfs:_xfs_buf_ioapply+0x2a4/0x2d2
[ 1819.366822]  [<ffffffff882679bf>] :xfs:xfs_buf_iorequest+0x47/0x7a
[ 1819.373157]  [<ffffffff8824b048>] :xfs:xlog_bdstrat_cb+0x16/0x42
[ 1819.379283]  [<ffffffff8824c25a>] :xfs:xlog_sync+0x29f/0x48f
[ 1819.385067]  [<ffffffff8824c4e4>] :xfs:xlog_state_release_iclog+0x9a/0xad
[ 1819.391978]  [<ffffffff8824cf80>] :xfs:xlog_state_sync_all+0xec/0x263
[ 1819.398549]  [<ffffffff8824dcb2>] :xfs:_xfs_log_force+0x5c/0x6b
[ 1819.404591]  [<ffffffff8825bef0>] :xfs:xfs_syncsub+0x5d/0x2e4
[ 1819.410480]  [<ffffffff8825c290>] :xfs:xfs_sync+0x11/0x16
[ 1819.416016]  [<ffffffff8826eeab>] :xfs:vfs_sync+0x25/0x2b
[ 1819.421556]  [<ffffffff8826e4f0>] :xfs:vfs_sync_worker+0x1c/0x39
[ 1819.427711]  [<ffffffff8826e668>] :xfs:xfssyncd+0x15b/0x1af
[ 1819.433416]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1819.438335]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1819.443364]
[ 1819.444881] fstest        D 000001a635c55e02     0  5182   5165 (NOTLB)
[ 1819.451632]  ffff8100cd847298 0000000000000086 0000000000000000 0000000000000000
[ 1819.459198]  00000004cd8472b8 ffff81012b59f570 ffff8101267430e0 00000003cd847580
[ 1819.466756]  00000001000518d4 0000000000000000 ffff810001041400 000000038024ca2f
[ 1819.474108] Call Trace:
[ 1819.476806]  [<ffffffff804ee2f7>] __down+0x97/0x108
[ 1819.481753]  [<ffffffff804ee0f3>] __down_failed+0x35/0x3a
[ 1819.487235]  [<ffffffff88266aa2>] :xfs:xfs_buf_lock+0x4a/0x4c
[ 1819.493124]  [<ffffffff8825380a>] :xfs:xfs_getsb+0x2a/0x3a
[ 1819.498738]  [<ffffffff88258a26>] :xfs:xfs_trans_getsb+0x52/0xa1
[ 1819.504873]  [<ffffffff882573fd>] :xfs:xfs_trans_apply_sb_deltas+0x1c/0x2c4
[ 1819.511972]  [<ffffffff88257ee8>] :xfs:_xfs_trans_commit+0x12a/0x332
[ 1819.518464]  [<ffffffff8824889c>] :xfs:xfs_iomap_write_allocate+0x302/0x402
[ 1819.525554]  [<ffffffff8824798c>] :xfs:xfs_iomap+0x2f5/0x393
[ 1819.531343]  [<ffffffff8826da1a>] :xfs:xfs_bmap+0x10/0x15
[ 1819.536899]  [<ffffffff88264a24>] :xfs:xfs_map_blocks+0x43/0x81
[ 1819.542960]  [<ffffffff88265830>] :xfs:xfs_page_state_convert+0x297/0x58e
[ 1819.549898]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1819.556199]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1819.561395]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1819.567371]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1819.573275]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1819.579585]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1819.585057]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1819.591656]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1819.597377]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1819.603092]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1819.610571]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1819.617448]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1819.623246]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1819.629649]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1819.635185]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1819.640387]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1819.645512]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1819.650802]  [<000000000049c100>]
[ 1819.654165]
[ 1819.655693] fstest        D ffffffff8022b582     0  5217   5183 (NOTLB)
[ 1819.662446]  ffff810054a134b8 0000000000000086 ffff81012a04e800 ffffffff803d7ae7
[ 1819.670012]  ffff81012b679c00 ffff81012a38d020 ffff810127e288d0 ffff810128280d18
[ 1819.677577]  0000000000000005 ffff810129b80400 ffff81012b679c00 0000000000000005
[ 1819.684939] Call Trace:
[ 1819.687639]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.694417]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1819.700752]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1819.707001]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1819.712220]  [<ffffffff88264ac4>] :xfs:xfs_submit_ioend_bio+0x1e/0x28
[ 1819.718801]  [<ffffffff88264c54>] :xfs:xfs_submit_ioend+0xc5/0xe2
[ 1819.725042]  [<ffffffff88265ad5>] :xfs:xfs_page_state_convert+0x53c/0x58e
[ 1819.731980]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1819.738272]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1819.743473]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1819.749458]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1819.755371]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1819.761682]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1819.767153]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1819.773752]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1819.779481]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1819.785204]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1819.792701]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1819.799579]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1819.805385]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1819.811771]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1819.817307]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1819.822500]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1819.827617]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1819.832907]  [<000000000049c100>]
[ 1819.836270]
[ 1819.837798] fstest        D 00000155d8b9cf27     0  5243   5218 (NOTLB)
[ 1819.844550]  ffff810027ddb4b8 0000000000000082 0000000000000000 ffffffff803d7ae7
[ 1819.852116]  ffff810117faa400 ffff81012b510750 ffff810129df71e0 0000000128280d18
[ 1819.859665]  000000010003c9e9 0000000000000000 ffff81000102f400 0000000100000005
[ 1819.867018] Call Trace:
[ 1819.869725]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1819.876496]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1819.882831]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1819.889080]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1819.894307]  [<ffffffff88264ac4>] :xfs:xfs_submit_ioend_bio+0x1e/0x28
[ 1819.900906]  [<ffffffff88264c54>] :xfs:xfs_submit_ioend+0xc5/0xe2
[ 1819.907156]  [<ffffffff88265ad5>] :xfs:xfs_page_state_convert+0x53c/0x58e
[ 1819.914085]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1819.920394]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1819.925595]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1819.931580]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1819.937493]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1819.943795]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1819.949257]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1819.955874]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1819.961604]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1819.967326]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1819.974815]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1819.981700]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1819.987500]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1819.993901]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1819.999454]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1820.004657]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1820.009765]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1820.015047]  [<000000000049c100>]
[ 1820.018409]
[ 1820.019946] pdflush       D 00000155c27e6608     0  5268      2 (L-TLB)
[ 1820.026690]  ffff810038b85cf0 0000000000000046 0000000000000000 0000000000000000
[ 1820.034255]  0000000000000001 ffff81012b510750 ffff8101277f8fe0 0000000100001000
[ 1820.041813]  000000010003c9a2 0000000000000000 ffff81000102f400 0000000100000000
[ 1820.049166] Call Trace:
[ 1820.051881]  [<ffffffff88267458>] :xfs:xfs_buf_wait_unpin+0xd7/0x109
[ 1820.058382]  [<ffffffff882679a5>] :xfs:xfs_buf_iorequest+0x2d/0x7a
[ 1820.064701]  [<ffffffff8826d9db>] :xfs:xfs_bdstrat_cb+0x19/0x48
[ 1820.070767]  [<ffffffff882641b2>] :xfs:xfs_bwrite+0x73/0xed
[ 1820.076488]  [<ffffffff8825c027>] :xfs:xfs_syncsub+0x194/0x2e4
[ 1820.082460]  [<ffffffff8825c290>] :xfs:xfs_sync+0x11/0x16
[ 1820.087997]  [<ffffffff8826eeab>] :xfs:vfs_sync+0x25/0x2b
[ 1820.093528]  [<ffffffff8826e7d6>] :xfs:xfs_fs_write_super+0x22/0x28
[ 1820.099934]  [<ffffffff8028ecf8>] sync_supers+0x75/0xc9
[ 1820.105225]  [<ffffffff80269e47>] wb_kupdate+0x29/0x11e
[ 1820.110523]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1820.115639]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1820.120573]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1820.125594]
[ 1820.127111] pdflush       D 0000000000000019     0  5269      2 (L-TLB)
[ 1820.133863]  ffff810015f4fd70 0000000000000046 0000000000000000 ffffffff803385ae
[ 1820.141429]  ffff810015f4fcb0 ffff81012608e9d0 ffff810129f001c0 0000000200000000
[ 1820.148987]  000000010004419b 0000000000000000 ffff810001038400 0000000280249d77
[ 1820.157922] Call Trace:
[ 1820.160612]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1820.166339]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1820.172340]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1820.177975]  [<ffffffff80269dc6>] background_writeout+0xba/0xcb
[ 1820.183949]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1820.189056]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1820.193991]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1820.199019]
[ 1820.200544] pdflush       D 000001a76887cb15     0  5270      2 (L-TLB)
[ 1820.207288]  ffff810035be1d70 0000000000000046 0000000000000000 ffffffff803385ae
[ 1820.214854]  ffff810035be1cb0 ffff81012b546e60 ffff810126063060 0000000200000000
[ 1820.222403]  000000010005203f 0000000000000000 ffff810001038400 0000000280249d77
[ 1820.229747] Call Trace:
[ 1820.232444]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1820.238171]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1820.244164]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1820.249798]  [<ffffffff80269dc6>] background_writeout+0xba/0xcb
[ 1820.255799]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1820.260906]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1820.265848]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1820.270878]
[ 1820.272395] dmesg         D 0000015465378de7     0  5271   5244 (NOTLB)
[ 1820.279155]  ffff8100cabcd7c8 0000000000000082 0000000000000000 ffff81012b593440
[ 1820.286729]  0000000000000001 ffff81012b652f20 ffff8101274937b0 000000068022b21f
[ 1820.294297]  000000010003c3ea 0000000000000000 ffff81000105c400 000000068022b4a5
[ 1820.301632] Call Trace:
[ 1820.304345]  [<ffffffff804ece02>] wait_for_completion+0x9d/0xe3
[ 1820.310334]  [<ffffffff80245e53>] flush_cpu_workqueue+0x71/0x82
[ 1820.316324]  [<ffffffff80245e9a>] flush_workqueue+0x36/0x4c
[ 1820.321975]  [<ffffffff80246197>] flush_scheduled_work+0x10/0x15
[ 1820.328047]  [<ffffffff804d59d0>] xs_connect+0xeb/0xfe
[ 1820.333232]  [<ffffffff804d2f6d>] xprt_connect+0x12e/0x147
[ 1820.338781]  [<ffffffff804d1316>] call_connect+0x7f/0x8e
[ 1820.344166]  [<ffffffff804d6fec>] __rpc_execute+0x7f/0x25d
[ 1820.349734]  [<ffffffff804d71e8>] rpc_execute+0x1e/0x20
[ 1820.355024]  [<ffffffff804d0c65>] rpc_call_sync+0x7b/0xa1
[ 1820.360496]  [<ffffffff80339cf9>] nfs3_rpc_wrapper+0x29/0x6d
[ 1820.366219]  [<ffffffff8033a342>] nfs3_proc_access+0x11b/0x18b
[ 1820.372114]  [<ffffffff8032e337>] nfs_permission+0x172/0x23b
[ 1820.377838]  [<ffffffff8029472a>] permission+0xbe/0xcf
[ 1820.383032]  [<ffffffff8029474e>] vfs_permission+0x13/0x18
[ 1820.388572]  [<ffffffff80295004>] __link_path_walk+0x151/0xe91
[ 1820.394477]  [<ffffffff80295d93>] link_path_walk+0x4f/0xcc
[ 1820.400035]  [<ffffffff80294d55>] path_walk+0x1c/0x21
[ 1820.405159]  [<ffffffff80295fc7>] do_path_lookup+0x1b7/0x1db
[ 1820.410866]  [<ffffffff802960f4>] __path_lookup_intent_open+0x65/0xbd
[ 1820.417378]  [<ffffffff8029615b>] path_lookup_open+0xf/0x14
[ 1820.423013]  [<ffffffff80296cdf>] open_namei+0x7f/0x6cf
[ 1820.428301]  [<ffffffff8028c4a9>] do_filp_open+0x1c/0x3d
[ 1820.433686]  [<ffffffff8028c813>] do_sys_open+0x5e/0x102
[ 1820.439054]  [<ffffffff8028c8d2>] sys_open+0x1b/0x20
[ 1820.444083]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1820.449374]  [<00002b27c7948327>]
[ 1820.452736]


--Boundary-00=_G3wVHT4Gd17Nwut
Content-Type: text/plain;
  charset="us-ascii";
  name="all_states.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="all_states.txt"

[generate break]
[ 1861.393610] SysRq : Show State
[ 1861.396733]
[ 1861.396734]                                  free                        sibling
[ 1861.405745]   task                 PC        stack   pid father child younger older
[ 1861.413484] init          S 000001b0689139a0     0     1      0 (NOTLB)
[ 1861.420230]  ffff81012b507a28 0000000000000082 0000000000000000 00000000000012c8
[ 1861.427787]  0000000000001200 ffff81012b652f20 ffff81012b5054b0 0000000600000000
[ 1861.435344]  00000001000545c6 0000000000000000 ffff81000105c400 00000006473b86e0
[ 1861.442696] Call Trace:
[ 1861.445404]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1861.451113]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1861.456385]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1861.462187]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1861.467467]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1861.472766]  [<00002b0958cbf053>]
[ 1861.476127]
[ 1861.477656] kthreadd      S 00000111615b2382     0     2      0 (L-TLB)
[ 1861.484408]  ffff81012b509f00 0000000000000046 0000000000000000 0000000400000001
[ 1861.491966]  0000000300000000 ffff81012b59e100 ffff81012b504de0 0000000400000001
[ 1861.499532]  000000010002aa8a 0000000000000000 ffff81000104a400 0000000400000000
[ 1861.506876] Call Trace:
[ 1861.509574]  [<ffffffff8024996e>] kthreadd+0x9c/0x17e
[ 1861.514686]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.519721]
[ 1861.521248] migration/0   S ffffffff8022b582     0     3      2 (L-TLB)
[ 1861.528008]  ffff81012b50deb0 0000000000000046 0000000000000000 0000000000000086
[ 1861.535574]  ffff8101260596f0 ffff81012afa54b0 ffff81012b504710 000000008021a74c
[ 1861.543123]  000000010002af6b 0000000000000000 ffff81012b50deb0 ffffffff8022c883
[ 1861.550476] Call Trace:
[ 1861.553181]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1861.559083]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.564015]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.569028]
[ 1861.570552] ksoftirqd/0   S 000001123cf1b160     0     4      2 (L-TLB)
[ 1861.577305]  ffff81012b50ff00 0000000000000046 0000000000000000 0000000000000000
[ 1861.584854]  ffff81012b50ff20 ffffffff8068d100 ffff81012b504040 0000000000000001
[ 1861.592420]  000000010002ae21 0000000000000000 ffff810001026400 0000000000000001
[ 1861.599764] Call Trace:
[ 1861.602470]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1861.607669]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.612611]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.617632]
[ 1861.619148] migration/1   S 00000112ce761f14     0     5      2 (L-TLB)
[ 1861.625892]  ffff81012b513eb0 0000000000000046 0000000000000000 0000000000000086
[ 1861.633458]  ffff810126784810 ffff81012b510750 ffff81012b5114f0 000000018021a74c
[ 1861.641024]  000000010002b084 0000000000000000 ffff81000102f400 000000018022c883
[ 1861.648376] Call Trace:
[ 1861.651074]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1861.656975]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.661908]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.666936]
[ 1861.668462] ksoftirqd/1   S 0000011154325766     0     6      2 (L-TLB)
[ 1861.675206]  ffff81012b517f00 0000000000000046 0000000000000000 0000000000000000
[ 1861.682762]  ffff81012b517f20 ffff81012b510750 ffff81012b510e20 0000000100000001
[ 1861.690320]  000000010002aa53 0000000000000000 ffff81000102f400 0000000100000001
[ 1861.697664] Call Trace:
[ 1861.700362]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1861.705552]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.710495]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.715523]
[ 1861.717040] migration/2   S ffffffff8022b582     0     7      2 (L-TLB)
[ 1861.723783]  ffff81012b543eb0 0000000000000046 0000000000000000 0000000000000000
[ 1861.731341]  0000000300000000 ffff81012afa4710 ffff81012b510080 0000000200000001
[ 1861.738907]  000000010002af77 0000000000000000 ffff81012b543eb0 ffffffff8022c883
[ 1861.746269] Call Trace:
[ 1861.748973]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1861.754875]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.759817]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.764837]
[ 1861.766354] ksoftirqd/2   S 00000112c02bbf11     0     8      2 (L-TLB)
[ 1861.773106]  ffff81012b54df00 0000000000000046 0000000000000000 0000000000000000
[ 1861.780671]  ffff81012b54df20 ffff81012b546e60 ffff81012b547530 0000000200000001
[ 1861.788230]  000000010002b04a 0000000000000000 ffff810001038400 0000000200000001
[ 1861.795582] Call Trace:
[ 1861.798280]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1861.803487]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.808430]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.813459]
[ 1861.814976] migration/3   S 00000112f8231a66     0     9      2 (L-TLB)
[ 1861.821728]  ffff81012b577eb0 0000000000000046 0000000000000000 0000000300000001
[ 1861.829293]  0000000300000000 ffff81012b59f570 ffff81012b546790 0000000300000001
[ 1861.836850]  000000010002b137 0000000000000000 ffff810001041400 000000038022c883
[ 1861.844212] Call Trace:
[ 1861.846917]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1861.852819]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.857744]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.862780]
[ 1861.864315] ksoftirqd/3   S 00000102911af47d     0    10      2 (L-TLB)
[ 1861.871093]  ffff81012b59df00 0000000000000046 0000000000000000 0000000000000000
[ 1861.880252]  ffff81012b59df20 ffff81012b59f570 ffff81012b5460c0 0000000300000001
[ 1861.887810]  0000000100026c55 0000000000000000 ffff810001041400 0000000300000001
[ 1861.895197] Call Trace:
[ 1861.897903]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1861.903102]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.908045]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.913065]
[ 1861.914590] migration/4   S ffffffff8022b582     0    11      2 (L-TLB)
[ 1861.921342]  ffff81012b5c9eb0 0000000000000046 0000000000000000 0000000000000086
[ 1861.928891]  ffff8101260596f0 ffff810129d90280 ffff81012b59eea0 000000048021a74c
[ 1861.936457]  000000010002aed1 0000000000000000 ffff81012b5c9eb0 ffffffff8022c883
[ 1861.943810] Call Trace:
[ 1861.946507]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1861.952408]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1861.957341]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1861.962370]
[ 1861.963896] ksoftirqd/4   S 00000110fd567117     0    12      2 (L-TLB)
[ 1861.970647]  ffff81012b5d1f00 0000000000000046 0000000000000000 0000000000000000
[ 1861.978213]  ffff81012b5d1f20 ffff81012b59e100 ffff81012b59e7d0 0000000400000001
[ 1861.985762]  000000010002a8e7 0000000000000000 ffff81000104a400 0000000400000001
[ 1861.993107] Call Trace:
[ 1861.995813]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1862.001011]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.005954]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.010974]
[ 1862.012499] migration/5   S ffffffff8022b582     0    13      2 (L-TLB)
[ 1862.019252]  ffff81012b5fbeb0 0000000000000046 0000000000000000 0000000000000086
[ 1862.026817]  ffff810127033160 ffff81012afb0e20 ffff81012b5f95b0 000000058021a74c
[ 1862.034367]  000000010002afec 0000000000000000 ffff81012b5fbeb0 ffffffff8022c883
[ 1862.041709] Call Trace:
[ 1862.044407]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1862.050309]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.055250]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.060270]
[ 1862.061787] ksoftirqd/5   S 0000010ec85e50c1     0    14      2 (L-TLB)
[ 1862.068531]  ffff81012b5fff00 0000000000000046 0000000000000000 0000000000000000
[ 1862.076096]  ffff81012b5fff20 ffff81012b5f8810 ffff81012b5f8ee0 0000000500000001
[ 1862.083654]  0000000100029f91 0000000000000000 ffff810001053400 0000000500000001
[ 1862.090989] Call Trace:
[ 1862.093687]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1862.098886]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.103829]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.108848]
[ 1862.110365] migration/6   S 000001693fe793ea     0    15      2 (L-TLB)
[ 1862.117127]  ffff81012b62deb0 0000000000000046 0000000000000000 0000000000000000
[ 1862.124691]  0000000300000000 ffff81012b652f20 ffff81012b5f8140 0000000600000001
[ 1862.132249]  0000000100041b6d 0000000000000000 ffff81000105c400 000000068022c883
[ 1862.139585] Call Trace:
[ 1862.142290]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1862.148183]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.153116]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.158137]
[ 1862.159654] ksoftirqd/6   S 0000010fd1bba5b5     0    16      2 (L-TLB)
[ 1862.166406]  ffff81012b655f00 0000000000000046 0000000000000000 0000000000000000
[ 1862.173972]  ffff81012b655f20 ffff81012b652f20 ffff81012b6535f0 0000000600000001
[ 1862.181529]  000000010002a3fd 0000000000000000 ffff81000105c400 0000000600000001
[ 1862.188882] Call Trace:
[ 1862.191587]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1862.196794]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.201738]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.206767]
[ 1862.208284] migration/7   S ffffffff8022b582     0    17      2 (L-TLB)
[ 1862.215043]  ffff81012b67feb0 0000000000000046 0000000000000000 0000000700000001
[ 1862.222609]  0000000300000000 ffff81012afb0080 ffff81012b652850 0000000700000001
[ 1862.230168]  000000010002ab06 0000000000000000 ffff81012b67feb0 ffffffff8022c883
[ 1862.237520] Call Trace:
[ 1862.240225]  [<ffffffff8022f236>] migration_thread+0x1eb/0x2d8
[ 1862.246110]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.251051]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.256072]
[ 1862.257589] ksoftirqd/7   S 00000112d5786227     0    18      2 (L-TLB)
[ 1862.264324]  ffff81012b683f00 0000000000000046 0000000000000000 0000000000000000
[ 1862.271897]  ffff81012b683f20 ffff81012b689630 ffff81012b652180 0000000700000001
[ 1862.279455]  000000010002b09a 0000000000000000 ffff810001065400 0000000700000001
[ 1862.286807] Call Trace:
[ 1862.289513]  [<ffffffff8023a94c>] ksoftirqd+0x5c/0x13a
[ 1862.294704]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.299646]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.304667]
[ 1862.306184] events/0      S 000001b17ebf1613     0    19      2 (L-TLB)
[ 1862.312944]  ffff81012a8bfeb0 0000000000000046 0000000000000000 ffff810001027e60
[ 1862.320493]  00000000000001f4 ffffffff8068d100 ffff81012b688f60 0000000080789d38
[ 1862.328051]  0000000100054a51 0000000000000000 ffff810001026400 0000000080245b25
[ 1862.335403] Call Trace:
[ 1862.338100]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.343654]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.348597]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.353618]
[ 1862.355143] events/1      S 000001b192c08c9f     0    20      2 (L-TLB)
[ 1862.361894]  ffff81012b64feb0 0000000000000046 0000000000000000 ffff810001030e00
[ 1862.369452]  ffffffff8026f982 ffff81012b510750 ffff81012b688890 000000018023e178
[ 1862.377010]  0000000100054a9b 0000000000000000 ffff81000102f400 0000000101030e00
[ 1862.384362] Call Trace:
[ 1862.387060]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.392614]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.397548]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.402577]
[ 1862.404101] events/2      S 000001b14834a74c     0    21      2 (L-TLB)
[ 1862.410854]  ffff81012b651eb0 0000000000000046 0000000000000000 ffffffff8022dcd2
[ 1862.418419]  00000000000001f4 ffff81012b546e60 ffff81012b6881c0 000000022a7e2800
[ 1862.425977]  0000000100054948 0000000000000000 ffff810001038400 00000002803b6747
[ 1862.433338] Call Trace:
[ 1862.436036]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.441590]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.446533]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.451561]
[ 1862.453078] events/3      S ffffffff8022b582     0    22      2 (L-TLB)
[ 1862.459839]  ffff81012b0bfeb0 0000000000000046 ffffffff80789d38 ffff810001042e00
[ 1862.467396]  ffffffff8026f982 ffff81012a38d020 ffff81012b571670 ffffffff8023e178
[ 1862.474970]  0000000000000286 ffff810001042de0 ffffffff8026f982 ffff810001042e00
[ 1862.482332] Call Trace:
[ 1862.485021]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.490575]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.495517]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.500537]
[ 1862.502054] events/4      S 000001b171e2b0b7     0    23      2 (L-TLB)
[ 1862.508806]  ffff81012a8abeb0 0000000000000046 0000000000000000 ffff81000104be00
[ 1862.516363]  ffffffff8026f982 ffff81012b59e100 ffff81012b570fa0 000000048023e178
[ 1862.523913]  0000000100054a22 0000000000000000 ffff81000104a400 000000040104be00
[ 1862.531256] Call Trace:
[ 1862.533954]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.539490]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.544432]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.549453]
[ 1862.550970] events/5      S ffffffff8022b582     0    24      2 (L-TLB)
[ 1862.557722]  ffff81012aff1eb0 0000000000000046 ffffffff80789d38 ffff810001054e00
[ 1862.565287]  ffffffff8026f982 ffff81012afb0e20 ffff81012b5708d0 ffffffff8023e178
[ 1862.572845]  0000000000000286 ffff810001054de0 ffffffff8026f982 ffff810001054e00
[ 1862.580190] Call Trace:
[ 1862.582887]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.588432]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.593383]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.598404]
[ 1862.599929] events/6      S ffff81012b640640     0    25      2 (L-TLB)
[ 1862.606681]  ffff81012aff3eb0 0000000000000046 0000000000000000 ffff81000105de00
[ 1862.615830]  ffffffff8026f982 ffff810129eec810 ffff81012b570200 ffffffff8023e178
[ 1862.623380]  0000000000000286 ffff81000105dde0 ffffffff8026f982 ffff81000105de00
[ 1862.630724] Call Trace:
[ 1862.633422]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.638966]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.643909]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.648937]
[ 1862.650454] events/7      D 00000155dd642280     0    26      2 (L-TLB)
[ 1862.657190]  ffff81012b529ac0 0000000000000046 0000000000000000 ffff810128280d18
[ 1862.664763]  ffff8100ba2376f8 ffff81012b689630 ffff81012aff76b0 000000078023e215
[ 1862.672322]  000000010003ca14 0000000000000000 ffff810001065400 0000000780430c13
[ 1862.679674] Call Trace:
[ 1862.682371]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1862.687665]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1862.693571]  [<ffffffff8036e5a1>] blk_get_request+0x36/0x6b
[ 1862.699198]  [<ffffffff8042f5cb>] scsi_execute+0x51/0x129
[ 1862.704664]  [<ffffffff880cc11b>] :scsi_transport_spi:spi_execute+0x87/0xf8
[ 1862.711696]  [<ffffffff880cd5ae>] :scsi_transport_spi:spi_dv_device_echo_buffer+0x181/0x27d
[ 1862.720129]  [<ffffffff880cd801>] :scsi_transport_spi:spi_dv_retrain+0x4e/0x240
[ 1862.727521]  [<ffffffff880ce008>] :scsi_transport_spi:spi_dv_device+0x615/0x69c
[ 1862.734923]  [<ffffffff880f16d1>] :mptspi:mptspi_dv_device+0xb3/0x14b
[ 1862.741434]  [<ffffffff880f27d3>] :mptspi:mptspi_dv_renegotiate_work+0xcb/0xef
[ 1862.748755]  [<ffffffff80245bb8>] run_workqueue+0x8e/0x120
[ 1862.754295]  [<ffffffff80245d50>] worker_thread+0x106/0x117
[ 1862.759914]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.764831]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.769860]
[ 1862.771376] khelper       S ffff81012b6404c0     0    27      2 (L-TLB)
[ 1862.778128]  ffff81012b52beb0 0000000000000046 ffffffff806983a0 00000000fffffffc
[ 1862.785694]  ffff810127e39ac0 ffff810127470750 ffff81012aff6fe0 0000000000000001
[ 1862.793252]  ffff81012a8abe58 ffff81012b52a000 0000000000001408 ffff81012b6404c8
[ 1862.800605] Call Trace:
[ 1862.803310]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.808855]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.813798]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.818827]
[ 1862.820344] kblockd/0     S 00000155d86e972a     0    66      2 (L-TLB)
[ 1862.827096]  ffff81012afa7eb0 0000000000000046 0000000000000000 ffff810127ff57a8
[ 1862.834653]  ffff81012a001800 ffffffff8068d100 ffff81012afa54b0 0000000080379049
[ 1862.842219]  000000010003ca01 0000000000000000 ffff810001026400 0000000080431275
[ 1862.849581] Call Trace:
[ 1862.852278]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.857832]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.862775]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.867804]
[ 1862.869321] kblockd/1     S ffff81012af8bf40     0    67      2 (L-TLB)
[ 1862.876080]  ffff81012afa9eb0 0000000000000046 ffff810128e2c000 ffff8101276e13e0
[ 1862.883637]  ffff81012a7fc800 ffff810129df71e0 ffff81012afa4de0 ffffffff80379049
[ 1862.891205]  ffff81012a7fc800 ffffffff803d7ae7 ffff8100cd981b58 ffffffff80431275
[ 1862.898557] Call Trace:
[ 1862.901255]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.906808]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.911758]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.916779]
[ 1862.918297] kblockd/2     S ffff81012af8bec0     0    68      2 (L-TLB)
[ 1862.925048]  ffff81012afabeb0 0000000000000046 ffff8101277d5000 ffff8101276e19a8
[ 1862.932622]  ffff810129ee1000 ffff810126784810 ffff81012afa4710 ffffffff80379049
[ 1862.940190]  ffff810129ee1000 ffffffff803d7ae7 ffff8100cd8ba4c8 ffffffff80431275
[ 1862.947541] Call Trace:
[ 1862.950239]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1862.955785]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1862.960718]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1862.965747]
[ 1862.967256] kblockd/3     S ffff81012af8be40     0    69      2 (L-TLB)
[ 1862.974007]  ffff81012afadeb0 0000000000000046 ffff810127548000 ffff810127ff57a8
[ 1862.981581]  ffff81012a001800 ffff810127e288d0 ffff81012afa4040 ffffffff80379049
[ 1862.989140]  ffff81012a001800 ffffffff803d7ae7 ffff8100cdfb1ea0 ffffffff80431275
[ 1862.996501] Call Trace:
[ 1862.999215]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.004761]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.009711]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.014732]
[ 1863.016249] kblockd/4     S 00000155d9eb468e     0    70      2 (L-TLB)
[ 1863.023001]  ffff81012afb3eb0 0000000000000046 0000000000000000 ffff810129984d98
[ 1863.030558]  ffff810129045000 ffff81012b59e100 ffff81012afb14f0 0000000480379049
[ 1863.038125]  000000010003c9fe 0000000000000000 ffff81000104a400 0000000480431275
[ 1863.045477] Call Trace:
[ 1863.048183]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.053728]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.058670]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.063699]
[ 1863.065216] kblockd/5     S 000001b1c7634b72     0    71      2 (L-TLB)
[ 1863.071968]  ffff81012afb5eb0 0000000000000046 0000000000000000 ffff810128280d18
[ 1863.079533]  0000000000000008 ffff81012b5f8810 ffff81012afb0e20 0000000580379049
[ 1863.087109]  0000000100054b60 0000000000000000 ffff810001053400 0000000580431275
[ 1863.094462] Call Trace:
[ 1863.097168]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.102721]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.107672]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.112701]
[ 1863.114212] kblockd/6     S 00000155db36d938     0    72      2 (L-TLB)
[ 1863.120962]  ffff81012afb7eb0 0000000000000046 0000000000000000 ffff810128280d18
[ 1863.128536]  0000000000000008 ffff81012b652f20 ffff81012afb0750 0000000680379049
[ 1863.136103]  000000010003ca0d 0000000000000000 ffff81000105c400 0000000680431275
[ 1863.143447] Call Trace:
[ 1863.146145]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.151698]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.156631]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.161644]
[ 1863.163161] kblockd/7     S 0000015e2ed10439     0    73      2 (L-TLB)
[ 1863.169914]  ffff81012afbbeb0 0000000000000046 0000000000000000 ffff810128280d18
[ 1863.177486]  0000000000000008 ffff81012b689630 ffff81012afb0080 0000000780379049
[ 1863.185044]  000000010003ed03 0000000000000000 ffff810001065400 0000000780431275
[ 1863.192389] Call Trace:
[ 1863.195102]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.200648]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.205599]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.210628]
[ 1863.212145] kacpid        S ffff81012af8b940     0    74      2 (L-TLB)
[ 1863.218897]  ffff81012afbfeb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.226471]  0000000000000000 ffff81012afbce60 ffff81012afbd530 ffff81012afbd530
[ 1863.234038]  ffff81012afbd530 ffff810001026488 ffffffff8068e640 ffff810001026400
[ 1863.241399] Call Trace:
[ 1863.244097]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.249650]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.254601]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.259622]
[ 1863.261139] kacpi_notify  S 00000029914d4c43     0    75      2 (L-TLB)
[ 1863.267882]  ffff81012a8c1eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.275447]  0000000000000000 ffff81012b546e60 ffff81012afbce60 000000022afbce60
[ 1863.283023]  00000000fffedd3e 0000000000000000 ffff810001038400 0000000201038400
[ 1863.290375] Call Trace:
[ 1863.293073]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.298618]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.303560]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.308581]
[ 1863.310098] ata/0         S ffff81012af95340     0   202      2 (L-TLB)
[ 1863.316850]  ffff81012b6c1eb0 0000000000000046 ffff810127f7c000 ffffffff8043ea2b
[ 1863.324415]  0000000000000002 ffff810129c7e950 ffff81012b6ba340 0000000100200200
[ 1863.331974]  00000000fffef250 ffffffff8023e6fb ffff81012b6ba340 ffffffff80782680
[ 1863.339325] Call Trace:
[ 1863.342031]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.347576]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.352519]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.359124]
[ 1863.360641] ata/1         S 000000299a0533e2     0   203      2 (L-TLB)
[ 1863.367385]  ffff81012b6c3eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.374958]  ffff81012b0c30b8 ffff81012b510750 ffff81012b5657f0 000000012b5657f0
[ 1863.382516]  00000000fffedd63 0000000000000000 ffff81000102f400 000000010102f400
[ 1863.389861] Call Trace:
[ 1863.392566]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.398102]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.403037]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.408058]
[ 1863.409575] ata/2         S 000000299a055c67     0   204      2 (L-TLB)
[ 1863.416326]  ffff81012b6d5eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.423892]  ffff81012b0cd7c8 ffff81012b546e60 ffff81012b565120 000000022b565120
[ 1863.431459]  00000000fffedd63 0000000000000000 ffff810001038400 0000000201038400
[ 1863.438811] Call Trace:
[ 1863.441516]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.447070]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.452004]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.457025]
[ 1863.458534] ata/3         S ffff81012af951c0     0   205      2 (L-TLB)
[ 1863.465285]  ffff81012b6ddeb0 0000000000000046 ffff810127e78000 ffffffff8043ea2b
[ 1863.472850]  0000000000000002 ffff810127dda790 ffff81012b564a50 0000000100200200
[ 1863.480408]  00000000fffef250 ffffffff8023e6fb ffff81012b564a50 ffff81012b57c000
[ 1863.487753] Call Trace:
[ 1863.490459]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.496012]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.500954]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.505975]
[ 1863.507492] ata/4         S ffff81012af95140     0   206      2 (L-TLB)
[ 1863.514236]  ffff81012b6dfeb0 0000000000000046 ffff810127e78000 ffffffff8043ea2b
[ 1863.521800]  0000000000000002 ffff810127dda790 ffff81012af338f0 0000000100200200
[ 1863.529368]  00000000fffef250 ffffffff8023e6fb ffff81012af338f0 ffff81012b5cc000
[ 1863.536728] Call Trace:
[ 1863.539417]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.544963]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.549904]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.554926]
[ 1863.556443] ata/5         S 000000299a05dd25     0   207      2 (L-TLB)
[ 1863.563185]  ffff81012b0c5eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.570760]  ffff81012b0d7808 ffff81012b5f8810 ffff81012af28440 000000052af28440
[ 1863.578326]  00000000fffedd63 0000000000000000 ffff810001053400 0000000501053400
[ 1863.585678] Call Trace:
[ 1863.588377]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.593930]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.598873]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.603901]
[ 1863.605418] ata/6         S 000000299a060477     0   208      2 (L-TLB)
[ 1863.612170]  ffff81012b0c9eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.619719]  ffff81012b0d6a68 ffff81012b652f20 ffff81012af28b10 000000062af28b10
[ 1863.627277]  00000000fffedc11 0000000000000000 ffff81000105c400 000000060105c400
[ 1863.634637] Call Trace:
[ 1863.637336]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.642889]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.647815]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.652835]
[ 1863.654352] ata/7         S ffff81012b5e0ec0     0   209      2 (L-TLB)
[ 1863.661103]  ffff81012b0cbeb0 0000000000000046 ffff810127f7c000 ffffffff8043ea2b
[ 1863.668668]  0000000000000002 ffff810129c7e950 ffff81012af291e0 0000000100200200
[ 1863.676226]  00000000fffef250 ffffffff8023e6fb ffff81012af291e0 ffff81012b684000
[ 1863.683571] Call Trace:
[ 1863.686276]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.691822]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.696764]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.701777]
[ 1863.703301] ata_aux       S ffff81012b5e0dc0     0   210      2 (L-TLB)
[ 1863.710053]  ffff81012b0d1eb0 0000000000000046 ffff81012a8fd5f0 ffffffff8022b21f
[ 1863.717620]  ffff81012a8fd688 ffff81012af1e400 ffff81012af298b0 ffff81012af298b0
[ 1863.725177]  ffff81012af298b0 ffff810001026488 ffffffff8068e640 ffff810001026400
[ 1863.732530] Call Trace:
[ 1863.735235]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.740781]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.745732]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.750753]
[ 1863.752278] kseriod       S 0000002e76313846     0   211      2 (L-TLB)
[ 1863.759030]  ffff81012b0e5e80 0000000000000046 0000000000000000 ffff810129f178b8
[ 1863.766596]  ffffffff88073030 ffff81012b546e60 ffff81012af1e400 00000002806bdb48
[ 1863.774154]  00000000fffef1c1 0000000000000000 ffff810001038400 00000002804ead27
[ 1863.781506] Call Trace:
[ 1863.784212]  [<ffffffff8044c4ee>] serio_thread+0x313/0x374
[ 1863.789759]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.794691]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.799728]
[ 1863.801245] kswapd0       S ffffffff8022b582     0   274      2 (L-TLB)
[ 1863.807988]  ffff81012a0fde40 0000000000000046 0000000000000001 0000000000000001
[ 1863.815546]  0000000f00000000 ffff81012b504040 ffff81012af1f870 ffff810128e54b40
[ 1863.823112]  0000000000000000 ffff81000000e700 00000000000000d0 0000000000000002
[ 1863.830473] Call Trace:
[ 1863.833170]  [<ffffffff8026dee5>] kswapd+0x129/0x536
[ 1863.838188]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.843140]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.848168]
[ 1863.849685] aio/0         S ffffffff8022b582     0   275      2 (L-TLB)
[ 1863.856437]  ffff81012a11feb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.864002]  0000000000000000 ffff81012b504de0 ffff81012af143c0 ffff81012af143c0
[ 1863.871560]  ffff81012af143c0 ffff810001026488 ffffffff8068e640 ffff810001026400
[ 1863.878905] Call Trace:
[ 1863.881610]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.887155]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.892098]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.897128]
[ 1863.898653] aio/1         S 00000029b5726b6b     0   276      2 (L-TLB)
[ 1863.905405]  ffff81012a121eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.912969]  0000000000000000 ffff81012b510750 ffff81012af14a90 000000012af14a90
[ 1863.920546]  00000000fffeddd6 0000000000000000 ffff81000102f400 000000010102f400
[ 1863.927890] Call Trace:
[ 1863.930579]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.936132]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.941066]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.946094]
[ 1863.947611] aio/2         S 00000029b572be02     0   277      2 (L-TLB)
[ 1863.954346]  ffff81012a125eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1863.961920]  0000000000000000 ffff81012b546e60 ffff81012af15160 000000022af15160
[ 1863.969478]  00000000fffeddd6 0000000000000000 ffff810001038400 0000000201038400
[ 1863.976840] Call Trace:
[ 1863.979545]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1863.985091]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1863.990016]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1863.995036]
[ 1863.996553] aio/3         S 00000029b5731190     0   278      2 (L-TLB)
[ 1864.003314]  ffff81012a127eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.010879]  0000000000000000 ffff81012b59f570 ffff81012afde3c0 000000032afde3c0
[ 1864.018437]  00000000fffedd67 0000000000000000 ffff810001041400 0000000301041400
[ 1864.025790] Call Trace:
[ 1864.028487]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.034033]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.038975]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.043996]
[ 1864.045521] aio/4         S 00000029b573690a     0   279      2 (L-TLB)
[ 1864.052264]  ffff81012a129eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.059829]  0000000000000000 ffff81012b59e100 ffff81012afdea90 000000042afdea90
[ 1864.067397]  00000000fffeddd6 0000000000000000 ffff81000104a400 000000040104a400
[ 1864.074741] Call Trace:
[ 1864.077446]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.082991]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.087934]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.094535]
[ 1864.096064] aio/5         S 00000029b573b587     0   280      2 (L-TLB)
[ 1864.102808]  ffff81012a12deb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.110381]  0000000000000000 ffff81012b5f8810 ffff81012afdf160 000000052afdf160
[ 1864.117957]  00000000fffeddd6 0000000000000000 ffff810001053400 0000000501053400
[ 1864.125318] Call Trace:
[ 1864.128016]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.133569]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.138504]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.143532]
[ 1864.145049] aio/6         S 00000029b5740be8     0   281      2 (L-TLB)
[ 1864.151793]  ffff81012a12feb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.159366]  0000000000000000 ffff81012b652f20 ffff81012afdf830 000000062afdf830
[ 1864.166933]  00000000fffedc11 0000000000000000 ffff81000105c400 000000060105c400
[ 1864.174277] Call Trace:
[ 1864.176976]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.182545]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.187488]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.192509]
[ 1864.194034] aio/7         S 00000029b7065c67     0   282      2 (L-TLB)
[ 1864.200778]  ffff81012a131eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.208343]  0000000000000000 ffff81012b689630 ffff81012b564380 000000072b564380
[ 1864.215901]  00000000fffeddd6 0000000000000000 ffff810001065400 0000000701065400
[ 1864.223236] Call Trace:
[ 1864.225943]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.231495]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.236438]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.241467]
[ 1864.242984] ksnapd        S 00000029e18422e0     0   950      2 (L-TLB)
[ 1864.249728]  ffff81012b0ebeb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.257301]  ffff810129d207e8 ffffffff8068d100 ffff81012b6bb0e0 000000002b6bb0e0
[ 1864.264859]  00000000fffede8f 0000000000000000 ffff810001026400 0000000001026400
[ 1864.272221] Call Trace:
[ 1864.274910]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.280463]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.285415]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.290452]
[ 1864.291969] kondemand/0   S ffffffff8022b582     0   951      2 (L-TLB)
[ 1864.298721]  ffff810129df5eb0 0000000000000046 ffff810129dec400 ffffffff8022b21f
[ 1864.306287]  ffff810129dec498 ffff81012b504de0 ffff81012b6bb7b0 ffff81012b6bb7b0
[ 1864.313845]  ffff81012b6bb7b0 ffff810001026488 ffffffff8068e640 ffff810001026400
[ 1864.321206] Call Trace:
[ 1864.323903]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.329448]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.334391]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.339411]
[ 1864.340928] kondemand/1   S 00000029e184f5ab     0   952      2 (L-TLB)
[ 1864.347680]  ffff810129de1eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.355246]  ffff810129dd8418 ffff81012b510750 ffff81012b6b0300 000000012b6b0300
[ 1864.362804]  00000000fffede8f 0000000000000000 ffff81000102f400 000000010102f400
[ 1864.370156] Call Trace:
[ 1864.372862]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.378415]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.383359]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.388379]
[ 1864.389888] kondemand/2   S 00000029e185469e     0   953      2 (L-TLB)
[ 1864.396639]  ffff810129ddbeb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.404213]  ffff810129dd9888 ffff81012b546e60 ffff81012b6b09d0 000000022b6b09d0
[ 1864.411772]  00000000fffedddc 0000000000000000 ffff810001038400 0000000201038400
[ 1864.419124] Call Trace:
[ 1864.421830]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.427383]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.432326]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.437356]
[ 1864.438880] kondemand/3   S 00000029e1859ee6     0   954      2 (L-TLB)
[ 1864.445616]  ffff810129dd3eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.453189]  ffff810129db1178 ffff81012b59f570 ffff81012b6b10a0 000000032b6b10a0
[ 1864.460757]  00000000fffede8b 0000000000000000 ffff810001041400 0000000301041400
[ 1864.468109] Call Trace:
[ 1864.470806]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.476351]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.481294]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.486315]
[ 1864.487832] kondemand/4   S 00000029e185edf6     0   955      2 (L-TLB)
[ 1864.494592]  ffff810129da5eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.502157]  ffff810129d9c358 ffff81012b59e100 ffff81012b6b1770 000000042b6b1770
[ 1864.509698]  00000000fffede8f 0000000000000000 ffff81000104a400 000000040104a400
[ 1864.517042] Call Trace:
[ 1864.519748]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.525293]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.530236]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.535264]
[ 1864.536781] kondemand/5   S 00000029e1863a25     0   956      2 (L-TLB)
[ 1864.543533]  ffff810129d9feb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.551090]  ffff810129d9d7c8 ffff81012b5f8810 ffff810129f00890 0000000529f00890
[ 1864.558648]  00000000fffede8f 0000000000000000 ffff810001053400 0000000501053400
[ 1864.566000] Call Trace:
[ 1864.568697]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.574243]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.579194]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.584223]
[ 1864.585740] kondemand/6   S 00000029e1868e94     0   957      2 (L-TLB)
[ 1864.592493]  ffff810129d95eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.600058]  ffff810129d910b8 ffff81012b652f20 ffff810129f00f60 0000000629f00f60
[ 1864.607616]  00000000fffeddf1 0000000000000000 ffff81000105c400 000000060105c400
[ 1864.614968] Call Trace:
[ 1864.617665]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.623219]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.628162]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.633183]
[ 1864.634700] kondemand/7   S 00000029e28e7ab3     0   958      2 (L-TLB)
[ 1864.641451]  ffff810129d85eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1864.649016]  ffff810129d7c298 ffff81012b689630 ffff810129d20e20 0000000729d20e20
[ 1864.656566]  00000000fffede4b 0000000000000000 ffff810001065400 0000000701065400
[ 1864.663911] Call Trace:
[ 1864.666616]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.672170]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.677120]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.682141]
[ 1864.683658] dhclient      S 0000000054f6ceea     0  1012      1 (NOTLB)
[ 1864.690418]  ffff81012999fa38 0000000000000086 0000000000000000 ffff81012999fa08
[ 1864.697984]  ffff81012999fa08 ffff810129ce57f0 ffff810129c61630 ffffffff80322529
[ 1864.705542]  0000000000000000 0000000000000000 0000040000000000 ffff81012999fa68
[ 1864.712886] Call Trace:
[ 1864.715591]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1864.721303]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1864.726592]  [<ffffffff802bd313>] compat_core_sys_select+0x1c7/0x28f
[ 1864.733002]  [<ffffffff802bd4b3>] compat_sys_select+0xd8/0x1a2
[ 1864.738896]  [<ffffffff802230a2>] ia32_sysret+0x0/0xa
[ 1864.744009]
[ 1864.745534] rpciod/0      S ffff81012b0a20c0     0  1029      2 (L-TLB)
[ 1864.752286]  ffff810129991eb0 0000000000000046 0000000000000000 ffffffff80266a09
[ 1864.759844]  ffff81002de48000 ffff810129f001c0 ffff810129ee2ea0 0000000000000282
[ 1864.767393]  ffffffff80512450 ffffffff8033745a ffff8101299ff248 ffffffff804d6b8c
[ 1864.774745] Call Trace:
[ 1864.777450]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.782997]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.787921]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.792950]
[ 1864.794467] rpciod/1      S 0000003d0d2b5afc     0  1030      2 (L-TLB)
[ 1864.801219]  ffff810129993eb0 0000000000000046 0000000000000000 ffffffff80266a09
[ 1864.808784]  ffff8101277f4000 ffff81012b510750 ffff810129cf8400 0000000180335e11
[ 1864.816343]  00000000ffff2f0b 0000000000000000 ffff81000102f400 00000001804d6b8c
[ 1864.823703] Call Trace:
[ 1864.826409]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.833539]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.838482]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.843503]
[ 1864.845027] rpciod/2      S ffff81012b0a21c0     0  1031      2 (L-TLB)
[ 1864.851779]  ffff810129997eb0 0000000000000046 ffff81006d4b3c88 ffffffff804d28a1
[ 1864.859328]  ffff81012996a800 ffff81012af1ead0 ffff810129d038b0 ffffffff804d3455
[ 1864.866886]  ffff81006d4b3c88 ffff8101299fe270 ffff81006d4b3c88 ffffffff804d13fd
[ 1864.874222] Call Trace:
[ 1864.876927]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.882481]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.887424]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.892453]
[ 1864.893969] rpciod/3      S 0000003d12432982     0  1032      2 (L-TLB)
[ 1864.900722]  ffff810129989eb0 0000000000000046 0000000000000000 0000000000000003
[ 1864.908287]  0000000000000286 ffff81012b59f570 ffff810129d20750 0000000380335e11
[ 1864.915846]  00000000ffff2f12 0000000000000000 ffff810001041400 00000003804d6b8c
[ 1864.923223] Call Trace:
[ 1864.925921]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.931475]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.936409]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.941438]
[ 1864.942955] rpciod/4      S 0000003d0b0776e9     0  1033      2 (L-TLB)
[ 1864.949698]  ffff81012998beb0 0000000000000046 0000000000000000 ffffffff80266a09
[ 1864.957263]  ffff810126671000 ffff81012b59e100 ffff810129d214f0 0000000480335e11
[ 1864.964821]  00000000ffff2f02 0000000000000000 ffff81000104a400 00000004804d6b8c
[ 1864.972165] Call Trace:
[ 1864.974863]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1864.980417]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1864.985341]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1864.990362]
[ 1864.991887] rpciod/5      S 0000003d12422b5f     0  1034      2 (L-TLB)
[ 1864.998639]  ffff81012998feb0 0000000000000046 0000000000000000 ffffffff80266a09
[ 1865.006204]  ffff810126671000 ffff81012b5f8810 ffff81012b6baa10 0000000580335e11
[ 1865.013755]  00000000ffff2f21 0000000000000000 ffff810001053400 00000005804d6b8c
[ 1865.021107] Call Trace:
[ 1865.023813]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.029366]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.034309]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.039339]
[ 1865.040855] rpciod/6      S 00000172839fdcbd     0  1035      2 (L-TLB)
[ 1865.047607]  ffff8101299f9eb0 0000000000000046 0000000000000000 0000000000000003
[ 1865.055172]  0000000000000286 ffff81012b652f20 ffff81012a382fe0 0000000680337344
[ 1865.062731]  00000001000441a6 0000000000000000 ffff81000105c400 00000006804d6b8c
[ 1865.070083] Call Trace:
[ 1865.072781]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.078334]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.083276]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.088298]
[ 1865.089814] rpciod/7      S ffffffff8022b582     0  1036      2 (L-TLB)
[ 1865.096566]  ffff8101299fbeb0 0000000000000046 0000000000000286 0000000000000003
[ 1865.104122]  0000000000000286 ffff810129eec810 ffff81012a3836b0 ffffffff80337344
[ 1865.111698]  ffffffff80512490 ffffffff8033841c 0000000000000008 ffffffff804d6b8c
[ 1865.119050] Call Trace:
[ 1865.121739]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.127285]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.132236]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.137264]
[ 1865.138781] portmap       S 0000003d01507e8c     0  1094      1 (NOTLB)
[ 1865.145534]  ffff8101291a9b28 0000000000000086 0000000000000000 0000000000000246
[ 1865.153082]  ffff8101285f6780 ffff81012b546e60 ffff81012a3962c0 0000000229903c80
[ 1865.160631]  00000000ffff2ed9 0000000000000000 ffff810001038400 00000002804b41c2
[ 1865.167992] Call Trace:
[ 1865.170689]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1865.176400]  [<ffffffff8029b7fc>] do_sys_poll+0x2ca/0x3b2
[ 1865.181872]  [<ffffffff8029b91a>] sys_poll+0x36/0x47
[ 1865.186892]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1865.192182]  [<00002ab29192edef>]
[ 1865.195544]
[ 1865.197056] unionfs-fuse- S ffffffff8022b582     0  1116      1 (NOTLB)
[ 1865.203817]  ffff81012930dc58 0000000000000086 0000000000000082 ffff8100cf3d3a38
[ 1865.211382]  ffff810129365240 ffff810127470e20 ffff810129dd8380 0000000000000000
[ 1865.218940]  ffff81012930dbc8 ffffffff8022dc11 ffff81012930dc18 ffffffff80249cfb
[ 1865.226285] Call Trace:
[ 1865.228994]  [<ffffffff880012c6>] :fuse:fuse_dev_read+0x132/0x4ad
[ 1865.235162]  [<ffffffff8028cfaa>] do_sync_read+0xcc/0x115
[ 1865.240621]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1865.245738]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1865.250759]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1865.256049]  [<00002ae4c1cbbec0>]
[ 1865.259412]
[ 1865.260941] unionfs-fuse- D 000001b245611bf4     0  1119      1 (NOTLB)
[ 1865.267694]  ffff810129765988 0000000000000082 0000000000000000 ffffffff80337e22
[ 1865.275258]  ffff8101297658c8 ffff81012b652f20 ffff810129eec810 0000000600000000
[ 1865.282816]  0000000100054d2b 0000000000000000 ffff81000105c400 0000000680337c3e
[ 1865.290169] Call Trace:
[ 1865.292874]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1865.298594]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1865.304568]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1865.310204]  [<ffffffff80269b24>] balance_dirty_pages_ratelimited_nr+0x196/0x22f
[ 1865.317692]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1865.324569]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
[ 1865.331763]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
[ 1865.338005]  [<ffffffff8032eb94>] nfs_file_write+0x138/0x1b7
[ 1865.343743]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1865.349301]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1865.354495]  [<ffffffff8028d5df>] sys_pwrite64+0x68/0x96
[ 1865.359880]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1865.365170]  [<00002b4eeec3ea73>]
[ 1865.368533]
[ 1865.370062] unionfs-fuse- S ffffffff8022b582     0  1124      1 (NOTLB)
[ 1865.376822]  ffff81012973fc58 0000000000000082 0000000000000082 ffff8100ce945a38
[ 1865.384388]  ffff8101259a5bc0 ffff81012a3fc480 ffff810129e2a040 0000000000000000
[ 1865.391946]  ffff81012973fbc8 ffffffff8022dc11 ffff81012973fc18 ffffffff80249cfb
[ 1865.399299] Call Trace:
[ 1865.402006]  [<ffffffff880012c6>] :fuse:fuse_dev_read+0x132/0x4ad
[ 1865.408166]  [<ffffffff8028cfaa>] do_sync_read+0xcc/0x115
[ 1865.413627]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1865.418751]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1865.423774]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1865.429064]  [<00002b449afd4ec0>]
[ 1865.432434]
[ 1865.433956] udevd         S 000000f6398f9ec1     0  1325      1 (NOTLB)
[ 1865.440707]  ffff8101284d5a28 0000000000000082 0000000000000000 ffff8101284d7c40
[ 1865.448265]  ffff81012a3fcb50 ffff81012b5f8810 ffff81012a3fcb50 0000000501053400
[ 1865.455822]  0000000100023885 0000000000000000 ffff810001053400 00000005804ec5ef
[ 1865.463166] Call Trace:
[ 1865.465871]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1865.471591]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1865.476872]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1865.482681]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1865.487979]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1865.493269]  [<00002ba9f3eaf053>]
[ 1865.496639]
[ 1865.498161] edac-poller   S 000001b1293e7b02     0  2229      2 (L-TLB)
[ 1865.504912]  ffff81012777beb0 0000000000000046 0000000000000000 ffff810128c25248
[ 1865.512478]  ffff810128c25200 ffff81012b546e60 ffff8101280a18f0 000000028023e178
[ 1865.520044]  0000000100054864 0000000000000000 ffff810001038400 0000000228c25248
[ 1865.527405] Call Trace:
[ 1865.530112]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.535665]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.540608]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.545629]
[ 1865.547146] ksuspend_usbd S ffff8101291634c0     0  2266      2 (L-TLB)
[ 1865.553898]  ffff810127e1feb0 0000000000000046 0000000000000001 ffffffff8022b21f
[ 1865.561471]  ffff810127e1fe08 ffff810129dd8380 ffff81012a38c950 ffff81012a38c950
[ 1865.569038]  ffff81012a38c950 ffff810001026488 ffff81012a790400 ffff810001026400
[ 1865.576390] Call Trace:
[ 1865.579088]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.584642]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.589592]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.596194]
[ 1865.597723] khubd         S 0000002ea84aa738     0  2270      2 (L-TLB)
[ 1865.604458]  ffff810127e71e00 0000000000000046 0000000000000000 ffffffff803d7c96
[ 1865.612023]  ffffffff8804c060 ffff81012b689630 ffff810129c60f60 0000000700000000
[ 1865.619572]  00000000fffef29c 0000000000000000 ffff810001065400 00000007803d7ae7
[ 1865.626908] Call Trace:
[ 1865.629618]  [<ffffffff88029aea>] :usbcore:hub_thread+0xb70/0xbe6
[ 1865.635770]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.640708]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.645745]
[ 1865.647262] kpsmoused     S 0000002e71476a85     0  2306      2 (L-TLB)
[ 1865.654015]  ffff81012871beb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1865.661580]  0000000000000000 ffffffff8068d100 ffff810129d9d730 0000000029d9d730
[ 1865.669138]  00000000fffef1b6 0000000000000000 ffff810001026400 0000000001026400
[ 1865.676490] Call Trace:
[ 1865.679196]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.684741]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.689692]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.694713]
[ 1865.696230] mthca_catas   S 0000002e799833fa     0  2349      2 (L-TLB)
[ 1865.702982]  ffff8101283ebeb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1865.710547]  0000000000000000 ffffffff8068d100 ffff81012a378200 000000002a378200
[ 1865.718096]  00000000fffef1d9 0000000000000000 ffff810001026400 0000000001026400
[ 1865.725457] Call Trace:
[ 1865.728163]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.733708]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.738651]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.743672]
[ 1865.745189] scsi_eh_0     S 0000002eadb36b3a     0  2409      2 (L-TLB)
[ 1865.751940]  ffff8101287e3e60 0000000000000046 0000000000000000 ffff8101287e3e70
[ 1865.759498]  ffff8101287e3db0 ffff81012b59f570 ffff810127dda790 0000000380528040
[ 1865.767055]  00000000fffef2b1 0000000000000000 ffff810001041400 0000000300000000
[ 1865.774408] Call Trace:
[ 1865.777105]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1865.783094]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.788035]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.793064]
[ 1865.794580] scsi_eh_1     S 0000002ec06992a3     0  2410      2 (L-TLB)
[ 1865.801332]  ffff81012832fe60 0000000000000046 0000000000000000 ffff81012832fe70
[ 1865.808906]  ffff81012832fdb0 ffffffff8068d100 ffff810129c7e950 0000000080528040
[ 1865.816448]  00000000fffef2fa 0000000000000000 ffff810001026400 0000000000000000
[ 1865.823800] Call Trace:
[ 1865.826505]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1865.832485]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.837410]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.842438]
[ 1865.843963] scsi_eh_2     S ffffffff8022b582     0  2626      2 (L-TLB)
[ 1865.850715]  ffff810127ff7e60 0000000000000046 ffff81005b7ca5e0 ffffffff80431275
[ 1865.858273]  ffff8100cef01200 ffff81012afb0750 ffff810127dda0c0 0000000000000282
[ 1865.865830]  ffff810127ff7ee0 ffffffff880f6580 ffff81012a04e800 ffffffff80379049
[ 1865.873175] Call Trace:
[ 1865.875879]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1865.881851]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.886784]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.891804]
[ 1865.893321] ib_mad1       S 000001b023bc8750     0  2627      2 (L-TLB)
[ 1865.900072]  ffff81012748feb0 0000000000000046 0000000000000000 0000000000000286
[ 1865.907621]  ffff810127d7b950 ffff81012b652f20 ffff810129eecee0 0000000600000008
[ 1865.915178]  00000001000544ae 0000000000000000 ffff81000105c400 00000006881c3dfe
[ 1865.922532] Call Trace:
[ 1865.925237]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1865.930783]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.935733]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.940754]
[ 1865.942271] scsi_eh_3     S 00000030794c01a6     0  2637      2 (L-TLB)
[ 1865.949023]  ffff810128965e60 0000000000000046 0000000000000000 0000000000000000
[ 1865.956597]  0000000000000000 ffff81012b59e100 ffff810129df6b10 0000000400000000
[ 1865.964164]  00000000fffefa3c 0000000000000000 ffff81000104a400 0000000400000000
[ 1865.971516] Call Trace:
[ 1865.974214]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1865.980202]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1865.985143]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1865.990171]
[ 1865.991689] scsi_eh_4     S 00000031e9be5056     0  2638      2 (L-TLB)
[ 1865.998449]  ffff81012742fe60 0000000000000046 0000000000000000 0000000000000000
[ 1866.006007]  0000000000000000 ffff81012b59e100 ffff810129c6a8d0 0000000400000000
[ 1866.013573]  00000000ffff0047 0000000000000000 ffff81000104a400 0000000400000000
[ 1866.020917] Call Trace:
[ 1866.023622]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1866.029601]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1866.034544]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1866.039572]
[ 1866.041089] scsi_eh_5     S 000000335b23f70a     0  2639      2 (L-TLB)
[ 1866.047850]  ffff810128725e60 0000000000000046 0000000000000000 0000000000000000
[ 1866.055407]  0000000001000000 ffff81012b59e100 ffff810129d91020 0000000400000000
[ 1866.062974]  00000000ffff0656 0000000000000000 ffff81000104a400 0000000400000000
[ 1866.070326] Call Trace:
[ 1866.073014]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1866.079011]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1866.083944]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1866.088965]
[ 1866.090481] scsi_eh_6     S 00000034cdb99842     0  2640      2 (L-TLB)
[ 1866.097241]  ffff810127d9be60 0000000000000046 0000000000000000 0000000000000000
[ 1866.104799]  0000000000000000 ffff81012b59e100 ffff81012a38c280 0000000400000000
[ 1866.112357]  00000000ffff0c6a 0000000000000000 ffff81000104a400 0000000400000000
[ 1866.119700] Call Trace:
[ 1866.122398]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1866.128377]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1866.133309]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1866.138330]
[ 1866.139847] scsi_eh_7     S 000000363f5c6076     0  2641      2 (L-TLB)
[ 1866.146598]  ffff8101281cfe60 0000000000000046 0000000000000000 0000000000000000
[ 1866.154156]  0000000000000000 ffff81012b59e100 ffff810129e2a710 0000000400000000
[ 1866.161705]  00000000ffff127a 0000000000000000 ffff81000104a400 0000000480698e80
[ 1866.169058] Call Trace:
[ 1866.171763]  [<ffffffff8042edcd>] scsi_error_handler+0xa3/0x6d0
[ 1866.177743]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1866.182676]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1866.187696]
[ 1866.189213] kipmi0        S 000001b281a27ff6     0  3577      2 (L-TLB)
[ 1866.195966]  ffff81012767fe90 0000000000000046 0000000000000000 0000000000000670
[ 1866.203539]  ffff81012a38d020 ffff81012b59f570 ffff81012a38d020 000000032a38d020
[ 1866.211097]  0000000100054e05 0000000000000000 ffff810001041400 0000000300000246
[ 1866.218449] Call Trace:
[ 1866.221155]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1866.226892]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1866.233842]  [<ffffffff88138b25>] :ipmi_si:ipmi_thread+0x70/0x89
[ 1866.239914]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1866.244847]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1866.249875]
[ 1866.251393] rpc.statd     S 0000003d01518465     0  3885      1 (NOTLB)
[ 1866.258153]  ffff8101283a5a28 0000000000000086 0000000000000000 ffffffff8024d2f4
[ 1866.265709]  0000000000000002 ffff81012b59f570 ffff8101281640c0 00000003285f6780
[ 1866.273268]  00000000ffff2ed9 0000000000000000 ffff810001041400 00000003806ec930
[ 1866.280619] Call Trace:
[ 1866.283309]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.289036]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1866.294334]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1866.300144]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1866.305424]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.310705]  [<00002b8d95498053>]
[ 1866.314067]
[ 1866.315589] rpc.idmapd    S ffffffff8022b582     0  3894      1 (NOTLB)
[ 1866.322341]  ffff8101260ffe78 0000000000000082 0000000000000000 0000000000000000
[ 1866.329915]  ffff8101260ffde8 ffff81012a38d020 ffff810129cf9870 0000000380296a3e
[ 1866.337472]  000000010002ac78 0000000000000000 ffff810001041400 000000038069aae0
[ 1866.346412] Call Trace:
[ 1866.349107]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1866.354835]  [<ffffffff802b9cb2>] sys_epoll_wait+0x1cf/0x4f0
[ 1866.360549]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.365837]  [<00002b5e8457c1f3>]
[ 1866.369191]
[ 1866.370721] acpid         S 00000039aaf60605     0  4124      1 (NOTLB)
[ 1866.377464]  ffff810125f73b28 0000000000000082 0000000000000000 ffffffff88000065
[ 1866.385020]  ffff8101296d7400 ffff81012b59f570 ffff81012a254f20 000000032b0e11c0
[ 1866.392578]  00000000ffff20d6 0000000000000000 ffff810001041400 0000000325ec1800
[ 1866.399931] Call Trace:
[ 1866.402629]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.408356]  [<ffffffff8029b7fc>] do_sys_poll+0x2ca/0x3b2
[ 1866.413818]  [<ffffffff8029b91a>] sys_poll+0x36/0x47
[ 1866.418846]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.424129]  [<00002b4ec70cadef>]
[ 1866.427483]
[ 1866.429012] syslogd       D 000001b2897ec664     0  4160      1 (NOTLB)
[ 1866.435763]  ffff8101259a7928 0000000000000082 0000000000000000 0000000000000000
[ 1866.443313]  ffff81012608eb80 ffff81012b5f8810 ffff81012608e9d0 00000005ffffffff
[ 1866.450871]  0000000100054e3e 0000000000000000 ffff810001053400 0000000500000001
[ 1866.458223] Call Trace:
[ 1866.460929]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1866.466656]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1866.472639]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1866.478266]  [<ffffffff80269b24>] balance_dirty_pages_ratelimited_nr+0x196/0x22f
[ 1866.485738]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1866.492598]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
[ 1866.499801]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
[ 1866.506049]  [<ffffffff8028d70c>] do_sync_readv_writev+0xc1/0x10b
[ 1866.512214]  [<ffffffff8028d9ed>] do_readv_writev+0xda/0x234
[ 1866.517936]  [<ffffffff8028dbe1>] vfs_writev+0x4b/0x50
[ 1866.523138]  [<ffffffff8028dcc3>] sys_writev+0x53/0x8a
[ 1866.528342]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.533631]  [<00002b7f7c91cb4c>]
[ 1866.537001]
[ 1866.538522] dd            R  running task       0  4193      1 (NOTLB)
[ 1866.545179] klogd         S 00000155dd65364b     0  4195      1 (NOTLB)
[ 1866.551932]  ffff81012599dbd8 0000000000000086 0000000000000000 0000000000000200
[ 1866.559489]  000000000000020a ffff81012b5f8810 ffff810127e6cee0 0000000501054830
[ 1866.567047]  000000010003ca15 0000000000000000 ffff810001053400 0000000500000246
[ 1866.574410] Call Trace:
[ 1866.577114]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.582842]  [<ffffffff804cc4c3>] unix_wait_for_peer+0xbd/0xdd
[ 1866.588738]  [<ffffffff804cd05a>] unix_dgram_sendmsg+0x3ae/0x491
[ 1866.594809]  [<ffffffff8046cd36>] sock_aio_write+0xf1/0xfc
[ 1866.600366]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1866.605914]  [<ffffffff8028d341>] vfs_write+0xd9/0x165
[ 1866.611100]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1866.616216]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.621497]  [<00002b6ae3931d50>]
[ 1866.624860]
[ 1866.626389] sshd          S 0000003ce23912d8     0  4230      1 (NOTLB)
[ 1866.633133]  ffff810125727a28 0000000000000086 0000000000000000 00002abf7ab1f000
[ 1866.640706]  ffff810125727a88 ffff81012b5f8810 ffff810127677120 0000000580748400
[ 1866.648265]  00000000ffff2e57 0000000000000000 ffff810001053400 0000000500000000
[ 1866.655626] Call Trace:
[ 1866.658331]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.664050]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1866.669340]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1866.675166]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1866.680456]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.685754]  [<00002abf7cd02053>]
[ 1866.689117]
[ 1866.690646] ypbind        S 0000003a1f53823c     0  4263      1 (NOTLB)
[ 1866.697398]  ffff8101251c1b28 0000000000000086 0000000000000000 0000000000000246
[ 1866.704963]  ffff8101285bc4c0 ffff81012b689630 ffff810127e29670 00000007297000c0
[ 1866.712522]  00000000ffff224b 0000000000000000 ffff810001065400 00000007804b41c2
[ 1866.719874] Call Trace:
[ 1866.722571]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.728299]  [<ffffffff8029b7fc>] do_sys_poll+0x2ca/0x3b2
[ 1866.733770]  [<ffffffff8029b91a>] sys_poll+0x36/0x47
[ 1866.738808]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.744098]  [<00002b63e7dd4e26>]
[ 1866.747461]
[ 1866.748990] ypbind        S 7fffffffffffffff     0  4264      1 (NOTLB)
[ 1866.755751]  ffff8101251c3e48 0000000000000086 00002b63e78e5248 ffffffff80274380
[ 1866.763308]  00000000277e3768 ffff810127e29670 ffff810127e6d5b0 0000000300000246
[ 1866.770865]  ffff8101251c3ec0 ffff8101277e3768 0000000000000000 0000000000000000
[ 1866.778209] Call Trace:
[ 1866.780907]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.786626]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1866.793580]  [<ffffffff802419c5>] sys_rt_sigtimedwait+0x1a0/0x27f
[ 1866.799759]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.805040]  [<00002b63e78e2e29>]
[ 1866.808393]
[ 1866.809922] ypbind        S 000001ae308d1495     0  4266      1 (NOTLB)
[ 1866.816674]  ffff810125205eb8 0000000000000086 0000000000000000 0000000000000000
[ 1866.824231]  00000000000cc2fe ffff81012b652f20 ffff81012af32480 00000006000cc2fe
[ 1866.831789]  0000000100053c7d 0000000000000000 ffff81000105c400 00000006135495f9
[ 1866.839133] Call Trace:
[ 1866.841831]  [<ffffffff804ed5bf>] do_nanosleep+0x5f/0x97
[ 1866.847212]  [<ffffffff8024c726>] hrtimer_nanosleep+0x64/0x128
[ 1866.853108]  [<ffffffff8024c841>] sys_nanosleep+0x57/0x63
[ 1866.858561]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.863851]  [<00002b63e7da42e1>]
[ 1866.867213]
[ 1866.868742] automount     S 0000003d035c7774     0  4341      1 (NOTLB)
[ 1866.875494]  ffff810125041b28 0000000000000086 0000000000000000 0000000000000001
[ 1866.883051]  ffff81012fdcbe98 ffff81012b652f20 ffff810129ee3570 0000000680221e62
[ 1866.890609]  00000000ffff2ed2 0000000000000000 ffff81000105c400 000000062b615ae8
[ 1866.897961] Call Trace:
[ 1866.900659]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.906378]  [<ffffffff8029b7fc>] do_sys_poll+0x2ca/0x3b2
[ 1866.911849]  [<ffffffff8029b91a>] sys_poll+0x36/0x47
[ 1866.916878]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.922177]  [<00002aeba863cdef>]
[ 1866.925539]
[ 1866.927069] automount     S 0000003cdd3f8d14     0  4352      1 (NOTLB)
[ 1866.933821]  ffff81012537db28 0000000000000086 0000000000000000 0000000000000001
[ 1866.941361]  ffff81012fdb3f20 ffff81012b546e60 ffff810128164e60 0000000280221e62
[ 1866.948919]  00000000ffff2e42 0000000000000000 ffff810001038400 000000022b615ae8
[ 1866.956271] Call Trace:
[ 1866.958976]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1866.964696]  [<ffffffff8029b7fc>] do_sys_poll+0x2ca/0x3b2
[ 1866.970149]  [<ffffffff8029b91a>] sys_poll+0x36/0x47
[ 1866.975178]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1866.980468]  [<00002b03e9416def>]
[ 1866.983831]
[ 1866.985353] gpm           S 0000003ae979a7da     0  4381      1 (NOTLB)
[ 1866.992104]  ffff81012567da28 0000000000000086 0000000000000000 00000000470a0162
[ 1866.999669]  0000000000000000 ffff81012b59f570 ffff810126058950 0000000300000086
[ 1867.007245]  00000000ffff2589 0000000000000000 ffff810001041400 000000032a7d7000
[ 1867.014597] Call Trace:
[ 1867.017294]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1867.023014]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1867.028295]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1867.034104]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1867.039385]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1867.044674]  [<00002ad175edf053>]
[ 1867.048044]
[ 1867.049566] irqbalance    S 000001b17fcd468d     0  4394      1 (NOTLB)
[ 1867.056292]  ffff81012537beb8 0000000000000082 0000000000000000 ffff810125f342b8
[ 1867.063857]  00000000000cdeae ffff81012b652f20 ffff81012a378fa0 00000006000cdeae
[ 1867.071424]  0000000100054a44 0000000000000000 ffff81000105c400 00000006135495f9
[ 1867.078785] Call Trace:
[ 1867.081491]  [<ffffffff804ed5bf>] do_nanosleep+0x5f/0x97
[ 1867.086855]  [<ffffffff8024c726>] hrtimer_nanosleep+0x64/0x128
[ 1867.092751]  [<ffffffff8024c841>] sys_nanosleep+0x57/0x63
[ 1867.098204]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1867.103503]  [<00002b28676302b0>]
[ 1867.106865]
[ 1867.108394] ntpd          S ffffffff8022b582     0  4542      1 (NOTLB)
[ 1867.115154]  ffff8101253b7998 0000000000000082 ffff8101253b78e8 ffffffff8022b4a5
[ 1867.124305]  ffff810129eec810 ffff81012a38d020 ffff810129c7f020 ffffffff8022bf2c
[ 1867.131872]  ffff810129c7f2b0 ffff81000105c400 ffff810129eec810 ffff81000105c400
[ 1867.139224] Call Trace:
[ 1867.141933]  [<ffffffff88000682>] :fuse:wait_answer_interruptible+0xc0/0xe2
[ 1867.148970]  [<ffffffff88000943>] :fuse:request_send+0x178/0x362
[ 1867.155038]  [<ffffffff8800498d>] :fuse:fuse_send_write+0xbb/0xd3
[ 1867.161207]  [<ffffffff88004a6c>] :fuse:fuse_commit_write+0xc1/0x16f
[ 1867.167628]  [<ffffffff80265950>] generic_file_buffered_write+0x43b/0x60d
[ 1867.174482]  [<ffffffff80266210>] __generic_file_aio_write_nolock+0x45a/0x491
[ 1867.181685]  [<ffffffff802662a8>] generic_file_aio_write+0x61/0xc1
[ 1867.187917]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1867.193465]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1867.198676]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1867.203792]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1867.209083]  [<00002af0abb64d50>]
[ 1867.212453]
[ 1867.213975] lockd         S 7fffffffffffffff     0  4582      2 (L-TLB)
[ 1867.220726]  ffff8101268bddc0 0000000000000046 ffff81012b60e600 00002b3ca909760f
[ 1867.228292]  00002b3cfffffff5 ffff810127676a50 ffff8101266c2de0 00002b3ca909761b
[ 1867.235850]  00002b3ca909761e 00002b3ca9097621 00002b3ca9097624 ffff81012a220280
[ 1867.243194] Call Trace:
[ 1867.245899]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1867.251627]  [<ffffffff804dba17>] svc_recv+0x319/0x522
[ 1867.256823]  [<ffffffff80353fbf>] lockd+0x12d/0x275
[ 1867.261765]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.266793]
[ 1867.268310] ib_addr       S 000001b0563a52f1     0  4605      2 (L-TLB)
[ 1867.275070]  ffff810124d21eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.282636]  000000000049314c ffff81012b652f20 ffff8101277f8240 00000006277f8240
[ 1867.290203]  000000010005457b 0000000000000000 ffff81000105c400 000000060104a400
[ 1867.297555] Call Trace:
[ 1867.300253]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.305805]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.310748]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.315769]
[ 1867.317286] ib_mcast      S 000001af711dd15a     0  4616      2 (L-TLB)
[ 1867.324029]  ffff81012662beb0 0000000000000046 0000000000000000 00000000000000d0
[ 1867.331586]  ffffffff881c4d40 ffff81012b652f20 ffff810129d7d670 0000000629d7d670
[ 1867.339135]  00000001000541c0 0000000000000000 ffff81000105c400 000000060104a400
[ 1867.346479] Call Trace:
[ 1867.349177]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.354731]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.359664]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.364685]
[ 1867.366202] iw_cm_wq      S 0000003b25fcf5e0     0  4626      2 (L-TLB)
[ 1867.372962]  ffff810124d2deb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.380527]  0000000000618e70 ffff81012b59e100 ffff810126784ee0 0000000426784ee0
[ 1867.388077]  00000000ffff270e 0000000000000000 ffff81000104a400 000000042b509ea8
[ 1867.395421] Call Trace:
[ 1867.398127]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.403664]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.408606]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.413635]
[ 1867.415152] ib_cm/0       S 0000003b264e3d2c     0  4635      2 (L-TLB)
[ 1867.421904]  ffff810124d3beb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.429461]  0000000000000000 ffffffff8068d100 ffff810126062990 0000000026062990
[ 1867.437010]  00000000ffff270f 0000000000000000 ffff810001026400 0000000001026400
[ 1867.444354] Call Trace:
[ 1867.447052]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.452613]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.457556]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.462577]
[ 1867.464102] ib_cm/1       S 0000003b264ea01f     0  4637      2 (L-TLB)
[ 1867.470855]  ffff810124d3feb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.478428]  00000000000161f3 ffff81012b510750 ffff81012a38d6f0 000000012a38d6f0
[ 1867.485986]  00000000ffff270f 0000000000000000 ffff81000102f400 000000010102f400
[ 1867.493330] Call Trace:
[ 1867.496028]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.501582]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.506515]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.511527]
[ 1867.513044] ib_cm/2       S 0000003b264ef671     0  4638      2 (L-TLB)
[ 1867.519804]  ffff810124e01eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.527369]  0000000000000000 ffff81012b546e60 ffff810129d7cfa0 0000000229d7cfa0
[ 1867.534937]  00000000ffff270e 0000000000000000 ffff810001038400 0000000201038400
[ 1867.542289] Call Trace:
[ 1867.544987]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.550548]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.555483]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.560512]
[ 1867.562038] ib_cm/3       S 0000003b264f4df7     0  4639      2 (L-TLB)
[ 1867.568789]  ffff810124e03eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.576346]  0000000000000000 ffff81012b59f570 ffff810129eec140 0000000329eec140
[ 1867.583905]  00000000ffff270f 0000000000000000 ffff810001041400 0000000301041400
[ 1867.591248] Call Trace:
[ 1867.593954]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.599499]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.604468]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.609489]
[ 1867.611005] ib_cm/4       S ffffffff8022b582     0  4640      2 (L-TLB)
[ 1867.617765]  ffff810124e05eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.625331]  0000000000000000 ffff81012b504de0 ffff810129eed5b0 ffff810129eed5b0
[ 1867.632872]  ffff810129eed5b0 ffff81000104a488 ffff810128eee140 ffff81000104a400
[ 1867.640241] Call Trace:
[ 1867.642948]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.648493]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.653426]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.658447]
[ 1867.659964] ib_cm/5       S ffff810125e527c0     0  4641      2 (L-TLB)
[ 1867.666716]  ffff810124e07eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.674273]  0000000000000000 ffff810129c7e280 ffff810129d9c2c0 ffff810129d9c2c0
[ 1867.681831]  ffff810129d9c2c0 ffff810001053d68 ffff810128eee140 ffff810001053400
[ 1867.689184] Call Trace:
[ 1867.691881]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.697425]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.702368]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.707389]
[ 1867.708906] ib_cm/6       S 0000003b26504999     0  4642      2 (L-TLB)
[ 1867.715657]  ffff810124e09eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.723205]  0000000000000000 ffff81012b652f20 ffff810129d9c990 0000000629d9c990
[ 1867.730772]  00000000ffff2702 0000000000000000 ffff81000105c400 000000060105c400
[ 1867.738124] Call Trace:
[ 1867.740822]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.746375]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.751302]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.756314]
[ 1867.757838] ib_cm/7       S ffff810125e526c0     0  4643      2 (L-TLB)
[ 1867.764582]  ffff810124e0beb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.772148]  0000000000000000 ffff81012a3fcb50 ffff810129d9d060 ffff810129d9d060
[ 1867.779705]  ffff810129d9d060 ffff810001065d68 ffff8101284d7c40 ffff810001065400
[ 1867.787058] Call Trace:
[ 1867.789756]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.795309]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.800251]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.805272]
[ 1867.806789] rdma_cm       S 0000003b26ab4d0a     0  4652      2 (L-TLB)
[ 1867.813541]  ffff810124c07eb0 0000000000000046 0000000000000000 ffffffff8022b21f
[ 1867.821107]  ffff81000105c400 ffff81012b59e100 ffff8101280a0b50 00000004280a0b50
[ 1867.828665]  00000000ffff2710 0000000000000000 ffff81000104a400 000000040104a400
[ 1867.836009] Call Trace:
[ 1867.838714]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.844259]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.849210]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.854231]
[ 1867.855747] ipoib         S 000001b2b107db79     0  4698      2 (L-TLB)
[ 1867.862499]  ffff810124ec3eb0 0000000000000046 0000000000000000 ffff8101251c5900
[ 1867.870065]  ffff8101251c58e0 ffff81012b689630 ffff81012a382240 000000078023e178
[ 1867.879214]  0000000100054eb6 0000000000000000 ffff810001065400 00000007251c5900
[ 1867.886569] Call Trace:
[ 1867.889265]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1867.894811]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.899763]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.904791]
[ 1867.906308] md3_raid5     S 00000155d85211a5     0  4715      2 (L-TLB)
[ 1867.913052]  ffff810124d7de40 0000000000000046 0000000000000000 ffffffff80431275
[ 1867.920617]  0000000000000086 ffff81012b689630 ffff810129df78b0 000000072696f000
[ 1867.928192]  000000010003c9ff 0000000000000000 ffff810001065400 000000078036db76
[ 1867.935544] Call Trace:
[ 1867.938242]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1867.943974]  [<ffffffff8817ce4f>] :md_mod:md_thread+0x100/0x143
[ 1867.949968]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1867.954904]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1867.959933]
[ 1867.961458] md4_raid5     D ffffffff8022b582     0  4725      2 (L-TLB)
[ 1867.968209]  ffff810124ebbb60 0000000000000046 0000000000011200 0000000000011210
[ 1867.975775]  ffff8101286018c0 ffff81012afb14f0 ffff810127033160 ffffffff802668c6
[ 1867.983333]  0000000000000020 ffff810128280dd8 ffff8100ba2376f8 000000010003ca03
[ 1867.990695] Call Trace:
[ 1867.993399]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1867.998678]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1868.004582]  [<ffffffff8036f7aa>] __make_request+0x54f/0x611
[ 1868.010296]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1868.016542]  [<ffffffff88194e5b>] :raid456:handle_stripe+0x17cd/0x2c39
[ 1868.023148]  [<ffffffff88197010>] :raid456:raid5d+0x3c2/0x409
[ 1868.028960]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1868.034951]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1868.039886]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1868.044924]
[ 1868.046440] md4_resync    D 00000155d5a21578     0  4726      2 (L-TLB)
[ 1868.053202]  ffff810117f9bba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1868.060767]  ffff81012b679c00 ffff81012b510750 ffff81012676b570 0000000128280d18
[ 1868.068325]  000000010003c9e4 0000000000000000 ffff81000102f400 0000000100000005
[ 1868.075677] Call Trace:
[ 1868.078385]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1868.085155]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1868.091496]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1868.097577]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1868.103553]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1868.108481]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1868.113510]
[ 1868.115027] md5_raid5     D 00000155dab12e61     0  4735      2 (L-TLB)
[ 1868.121779]  ffff81010bb7bb60 0000000000000046 0000000000000000 0000000000011210
[ 1868.129336]  ffff8101276d2940 ffff81012b546e60 ffff810126784810 00000002802668c6
[ 1868.136894]  000000010003c9fe 0000000000000000 ffff810001038400 000000020003ca09
[ 1868.144238] Call Trace:
[ 1868.146944]  [<ffffffff804ececb>] io_schedule+0x28/0x36
[ 1868.152229]  [<ffffffff8036e517>] get_request_wait+0x104/0x158
[ 1868.158143]  [<ffffffff8036f7aa>] __make_request+0x54f/0x611
[ 1868.163865]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1868.170111]  [<ffffffff88194e5b>] :raid456:handle_stripe+0x17cd/0x2c39
[ 1868.176710]  [<ffffffff88197010>] :raid456:raid5d+0x3c2/0x409
[ 1868.182520]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1868.188503]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1868.193438]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1868.198467]
[ 1868.199984] md5_resync    D 00000155d597e77a     0  4736      2 (L-TLB)
[ 1868.206745]  ffff81010b197ba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1868.214310]  ffff810117faa400 ffffffff8068d100 ffff810126784140 0000000028280d18
[ 1868.221886]  000000010003c9f3 0000000000000000 ffff810001026400 0000000000000005
[ 1868.229238] Call Trace:
[ 1868.231938]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1868.238706]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1868.245056]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1868.251146]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1868.257131]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1868.262068]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1868.267097]
[ 1868.268614] atd           S 0000003b650e4e53     0  4779      1 (NOTLB)
[ 1868.275357]  ffff8100cfcb1eb8 0000000000000082 0000000000000000 000000008022dc58
[ 1868.282930]  0000000000009a26 ffffffff8068d100 ffff81012664c400 0000000000009a26
[ 1868.290488]  00000000ffff2816 0000000000000000 ffff810001026400 00000000166831c1
[ 1868.297850] Call Trace:
[ 1868.300548]  [<ffffffff804ed5bf>] do_nanosleep+0x5f/0x97
[ 1868.305920]  [<ffffffff8024c726>] hrtimer_nanosleep+0x64/0x128
[ 1868.311816]  [<ffffffff8024c841>] sys_nanosleep+0x57/0x63
[ 1868.317270]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.322551]  [<00002af1ea0bb2b0>]
[ 1868.325913]
[ 1868.327442] cron          S 0000017a2d867fc5     0  4795      1 (NOTLB)
[ 1868.334194]  ffff8100cf3d39f8 0000000000000082 0000000000000000 ffffffff8022b4a5
[ 1868.341750]  ffff810129dd8380 ffff81012b652f20 ffff810127470e20 000000068022bf2c
[ 1868.349317]  00000001000461bd 0000000000000000 ffff81000105c400 000000060105c400
[ 1868.356661] Call Trace:
[ 1868.359361]  [<ffffffff88000682>] :fuse:wait_answer_interruptible+0xc0/0xe2
[ 1868.366399]  [<ffffffff8800084d>] :fuse:request_send+0x82/0x362
[ 1868.372380]  [<ffffffff88001f95>] :fuse:fuse_dentry_revalidate+0x11d/0x20f
[ 1868.379324]  [<ffffffff80294cc1>] do_lookup+0x1a4/0x21c
[ 1868.384617]  [<ffffffff80295842>] __link_path_walk+0x98f/0xe91
[ 1868.390523]  [<ffffffff80295d93>] link_path_walk+0x4f/0xcc
[ 1868.396071]  [<ffffffff80294d55>] path_walk+0x1c/0x21
[ 1868.401195]  [<ffffffff80295fc7>] do_path_lookup+0x1b7/0x1db
[ 1868.406920]  [<ffffffff802965ca>] __user_walk_fd+0x4b/0x7b
[ 1868.412478]  [<ffffffff802903d0>] vfs_stat_fd+0x2f/0x72
[ 1868.417759]  [<ffffffff80290855>] sys_newstat+0x27/0x4d
[ 1868.423049]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.428347]  [<00002b37dc12dd05>]
[ 1868.431717]
[ 1868.433246] lmtd          S 0000003bebf69b01     0  4847      1 (NOTLB)
[ 1868.439982]  ffff8100ce9bdd78 0000000000000082 0000000000000000 ffff81000000f9f0
[ 1868.447555]  0000004400000020 ffffffff8068d100 ffff81012676a7d0 000000008026b8ba
[ 1868.455114]  00000000ffff2a4c 0000000000000000 ffff810001026400 0000000080271117
[ 1868.462474] Call Trace:
[ 1868.465163]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.470885]  [<ffffffff8049b1f8>] inet_csk_accept+0x11d/0x2af
[ 1868.476702]  [<ffffffff804bc3c4>] inet_accept+0x30/0xd8
[ 1868.481991]  [<ffffffff8046d88e>] sys_accept+0xf1/0x1ab
[ 1868.487271]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.492570]  [<00002b550988c0f0>]
[ 1868.495932]
[ 1868.497461] getty         S 0000003c3ba7602c     0  4905      1 (NOTLB)
[ 1868.504213]  ffff8100ceacbda8 0000000000000086 0000000000000000 0000000000000020
[ 1868.511778]  ffff810001071b00 ffff81012b59e100 ffff810127492340 00000004803c91b3
[ 1868.519337]  00000000ffff2b9b 0000000000000000 ffff81000104a400 000000048026f2a1
[ 1868.526672] Call Trace:
[ 1868.529385]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.535107]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.540404]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.545415]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.550531]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.555553]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.560860]  [<00002b4921db2cd0>]
[ 1868.564222]
[ 1868.565744] getty         S 0000003c3e1a9a78     0  4906      1 (NOTLB)
[ 1868.572496]  ffff8100ce41fda8 0000000000000082 0000000000000000 0000000000000020
[ 1868.580052]  ffff810129151a00 ffff81012b689630 ffff810126742340 00000007803c91b3
[ 1868.587611]  00000000ffff2b15 0000000000000000 ffff810001065400 000000078026f2a1
[ 1868.594963] Call Trace:
[ 1868.597668]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.603388]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.608669]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.613697]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.618814]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.623835]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.629125]  [<00002b8960565cd0>]
[ 1868.632480]
[ 1868.634009] getty         S 0000003c3e523174     0  4909      1 (NOTLB)
[ 1868.640752]  ffff8100ce895da8 0000000000000082 0000000000000000 0000000000000020
[ 1868.648308]  ffff81012915e000 ffff81012b652f20 ffff810127fe4f20 00000006803c91b3
[ 1868.655867]  00000000ffff2ba2 0000000000000000 ffff81000105c400 000000068026f2a1
[ 1868.663220] Call Trace:
[ 1868.665926]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.671653]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.676934]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.683546]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.688664]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.693702]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.698992]  [<00002acf3fe63cd0>]
[ 1868.702355]
[ 1868.703877] getty         S ffffffff8022b582     0  4910      1 (NOTLB)
[ 1868.710629]  ffff8100cec05da8 0000000000000082 ffff81012a790400 0000000000000020
[ 1868.718185]  ffff81012972e400 ffff810129dd8380 ffff81012664cad0 ffffffff803c91b3
[ 1868.725743]  ffff8100cec05d28 ffffffff8022b4a5 ffff810129dd8380 000000208026f2a1
[ 1868.733095] Call Trace:
[ 1868.735793]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.741512]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.746818]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.751847]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.756964]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.761994]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.767284]  [<00002b4aa2097cd0>]
[ 1868.770647]
[ 1868.772176] getty         S 0000003c4ab47ee2     0  4915      1 (NOTLB)
[ 1868.778919]  ffff8100ceb73da8 0000000000000086 0000000000000000 0000000000000020
[ 1868.786485]  ffff81012a77ba00 ffffffff8068d100 ffff8101267f5630 00000000803c91b3
[ 1868.794043]  00000000ffff2bdb 0000000000000000 ffff810001026400 000000008026f2a1
[ 1868.801404] Call Trace:
[ 1868.804100]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.809813]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.815109]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.820138]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.825246]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.830269]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.835559]  [<00002ada24ee9cd0>]
[ 1868.838929]
[ 1868.840451] getty         S 0000003c4b2ef4a7     0  4920      1 (NOTLB)
[ 1868.847194]  ffff8100cea51da8 0000000000000082 0000000000000000 0000000000000020
[ 1868.854742]  ffff81012995a600 ffff81012b59f570 ffff81012663ea90 00000003803c91b3
[ 1868.862309]  00000000ffff2b07 0000000000000000 ffff810001041400 000000038026f2a1
[ 1868.869653] Call Trace:
[ 1868.872358]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.878070]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.883357]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.888396]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.893504]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.898534]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.903824]  [<00002b4ad87c8cd0>]
[ 1868.907187]
[ 1868.908716] getty         S 0000003c4c93aadc     0  4921      1 (NOTLB)
[ 1868.915467]  ffff8100cefc9da8 0000000000000086 0000000000000000 ffff81000102f400
[ 1868.923033]  0000003c4c933544 ffff81012b510750 ffff810129dd9120 0000000100000086
[ 1868.930583]  00000000ffff2be3 0000000000000000 ffff81000102f400 000000018026f2a1
[ 1868.937936] Call Trace:
[ 1868.940640]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1868.946360]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1868.951641]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1868.956661]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1868.961778]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1868.966808]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1868.972098]  [<00002b40ee651cd0>]
[ 1868.975461]
[ 1868.976982] login         S 00000169a6958c04     0  4924      1 (NOTLB)
[ 1868.983733]  ffff8100ce945b68 0000000000000086 0000000000000000 ffffffff806cb5a0
[ 1868.991298]  0000000000000000 ffff81012b652f20 ffff81012a3fc480 00000006ce945db8
[ 1868.998866]  0000000100041c8a 0000000000000000 ffff81000105c400 0000000600000246
[ 1869.006218] Call Trace:
[ 1869.008923]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1869.014635]  [<ffffffff804cc4c3>] unix_wait_for_peer+0xbd/0xdd
[ 1869.020530]  [<ffffffff804cd05a>] unix_dgram_sendmsg+0x3ae/0x491
[ 1869.026600]  [<ffffffff8046c810>] sock_sendmsg+0xe9/0x105
[ 1869.032062]  [<ffffffff8046dcca>] sys_sendto+0x110/0x160
[ 1869.037438]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1869.042736]  [<00002b7aaeed6a95>]
[ 1869.046106]
[ 1869.047628] sshd          S 0000003cea109e24     0  4925   4230 (NOTLB)
[ 1869.054371]  ffff8100ce559be8 0000000000000082 0000000000000000 0000000000000001
[ 1869.061936]  0000000000000001 ffff81012b652f20 ffff810129df6440 00000006ced74005
[ 1869.069495]  00000000ffff2e78 0000000000000000 ffff81000105c400 00000006ce559c58
[ 1869.076847] Call Trace:
[ 1869.079544]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1869.085255]  [<ffffffff804cd99e>] unix_stream_recvmsg+0x28a/0x518
[ 1869.091420]  [<ffffffff8046cc23>] sock_aio_read+0x114/0x136
[ 1869.097063]  [<ffffffff8028cfaa>] do_sync_read+0xcc/0x115
[ 1869.102526]  [<ffffffff8028d0ca>] vfs_read+0xd7/0x163
[ 1869.107624]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1869.112654]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1869.117944]  [<00002b1aaa03fcd0>]
[ 1869.121307]
[ 1869.122836] sshd          S ffffffff8022b582     0  4932   4925 (NOTLB)
[ 1869.129589]  ffff8100ce687a28 0000000000000086 0000000000000000 ffff810129f146c0
[ 1869.137145]  0000000100000000 ffff810128164790 ffff810129d20080 ffff810129f146c0
[ 1869.144695]  ffff81012a16a000 ffff810128d19e80 ffffffff806ec930 ffff8100cd9e0c58
[ 1869.152055] Call Trace:
[ 1869.154753]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1869.160473]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1869.165753]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1869.171563]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1869.176851]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1869.182141]  [<00002b1aaa047053>]
[ 1869.185504]
[ 1869.187033] bash          S 00000000fffffe00     0  4937   4932 (NOTLB)
[ 1869.193784]  ffff8100ce70fe38 0000000000000082 ffff81012796c818 ffff8100cf219018
[ 1869.201341]  000000000077c080 ffff810129ee2100 ffff810127878040 ffffffff8022bf2c
[ 1869.208900]  ffff810127878040 ffff81000105c400 ffff810129ee2100 ffff81000105c400
[ 1869.216243] Call Trace:
[ 1869.218941]  [<ffffffff80239098>] do_wait+0xbb9/0xcc5
[ 1869.224054]  [<ffffffff80239262>] sys_wait4+0x2b/0x30
[ 1869.229160]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1869.234450]  [<00002b5f5df93c05>]
[ 1869.237813]
[ 1869.239343] md3_resync    D 00000155d1ba400d     0  5024      2 (L-TLB)
[ 1869.246077]  ffff8100ce715ba0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1869.253634]  ffff81012860a600 ffff81012b689630 ffff8101260596f0 0000000728280d18
[ 1869.261200]  000000010003c9c9 0000000000000000 ffff810001065400 0000000700000005
[ 1869.268554] Call Trace:
[ 1869.271260]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1869.278031]  [<ffffffff88199027>] :raid456:sync_request+0x7a8/0x84a
[ 1869.284370]  [<ffffffff881809c0>] :md_mod:md_do_sync+0x574/0xa0b
[ 1869.290461]  [<ffffffff8817ce75>] :md_mod:md_thread+0x126/0x143
[ 1869.296454]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.301383]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.306412]
[ 1869.307929] xfslogd/0     S ffff810127d044c0     0  5139      2 (L-TLB)
[ 1869.314689]  ffff8100cdb9deb0 0000000000000046 ffffffff806983a0 ffff8100cff53cc0
[ 1869.322254]  ffff8100ce178b40 ffff810127033160 ffff81012aff6910 ffff8100cff53cc0
[ 1869.329812]  ffff8100cff53cc0 ffffffff882674ca ffff8100c518bee8 ffffffff88267549
[ 1869.337174] Call Trace:
[ 1869.339880]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.345433]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.350376]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.355405]
[ 1869.356922] xfslogd/1     S ffff810127d04b40     0  5140      2 (L-TLB)
[ 1869.363674]  ffff8100cdb9feb0 0000000000000046 0000000000000000 ffff8100cff45e40
[ 1869.371240]  ffff8100ce178000 ffff810127033160 ffff8101267855b0 ffff8100cff45e40
[ 1869.378806]  ffff8100cff45e40 ffffffff882674ca ffff810020fc5ee8 ffffffff88267549
[ 1869.386158] Call Trace:
[ 1869.388864]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.394410]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.399344]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.404364]
[ 1869.405881] xfslogd/2     S 00000112d6fcc779     0  5141      2 (L-TLB)
[ 1869.412641]  ffff8100cdba1eb0 0000000000000046 0000000000000000 ffff8101264809c0
[ 1869.420208]  ffff8101264804c0 ffff81012b546e60 ffff81012af33220 0000000200000000
[ 1869.427756]  000000010002b09f 0000000000000000 ffff810001038400 0000000200000000
[ 1869.435092] Call Trace:
[ 1869.437798]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.443352]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.448293]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.454898]
[ 1869.456424] xfslogd/3     S ffff81012822bbc0     0  5142      2 (L-TLB)
[ 1869.463168]  ffff8100cdba3eb0 0000000000000046 0000000000000000 ffff81012803e5c0
[ 1869.470733]  ffff81012803e0c0 ffff8101277f8fe0 ffff81012af32b50 ffffffff00000000
[ 1869.478282]  ffff81012803e0c0 ffff81012803e0c0 ffff81012936e000 0000000000000000
[ 1869.485635] Call Trace:
[ 1869.488331]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.493869]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.498786]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.503814]
[ 1869.505331] xfslogd/4     S ffffffff8022b582     0  5143      2 (L-TLB)
[ 1869.512083]  ffff8100cdba5eb0 0000000000000046 ffffffff806983a0 ffff8100c5187c80
[ 1869.519648]  ffff8100cdbbeb40 ffff810129d90280 ffff810129d02440 ffff8100c5187c80
[ 1869.527206]  ffff8100c5187c80 ffffffff882674ca ffff810034f61ee8 ffffffff88267549
[ 1869.534568] Call Trace:
[ 1869.537274]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.542819]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.547779]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.552799]
[ 1869.554316] xfslogd/5     S 00000155ad7d5e1e     0  5144      2 (L-TLB)
[ 1869.561051]  ffff8100cdba7eb0 0000000000000046 0000000000000000 ffff8101278c02c0
[ 1869.568624]  ffff81012803e5c0 ffff81012b5f8810 ffff810129d02b10 0000000500000000
[ 1869.576183]  000000010003c946 0000000000000000 ffff810001053400 0000000500000000
[ 1869.583535] Call Trace:
[ 1869.586233]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.591777]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.596720]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.601741]
[ 1869.603267] xfslogd/6     S ffff810127d7b640     0  5145      2 (L-TLB)
[ 1869.610027]  ffff8100cdba9eb0 0000000000000046 0000000000000000 ffff8101264803c0
[ 1869.617583]  ffff8101264809c0 ffff810126784140 ffff810129d031e0 ffffffff00000000
[ 1869.625151]  ffff8101264809c0 ffff8101264809c0 ffff810128602e00 0000000000000000
[ 1869.632495] Call Trace:
[ 1869.635200]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.640746]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.645679]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.650700]
[ 1869.652224] xfslogd/7     S ffffffff8022b582     0  5146      2 (L-TLB)
[ 1869.658968]  ffff8100cdbabeb0 0000000000000046 ffff81002ea51000 ffff810054a3a380
[ 1869.666534]  ffff8100ce1797e8 ffff81012663e3c0 ffff810129c60890 ffff810054a3a380
[ 1869.674100]  ffff810054a3a380 ffffffff882674ca ffff8100258d3e00 ffffffff88267549
[ 1869.681461] Call Trace:
[ 1869.684167]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.689713]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.694655]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.699675]
[ 1869.701192] xfsdatad/0    S ffffffff8022b582     0  5147      2 (L-TLB)
[ 1869.707945]  ffff8100cdbadeb0 0000000000000046 ffff8100c6d18540 0000000000000246
[ 1869.715510]  ffff81012c7815b8 ffff810127033160 ffff810129c601c0 ffff810127d04540
[ 1869.723059]  ffff810098ee9490 ffff810098ee9490 ffffffff806983a0 0000000000000008
[ 1869.730412] Call Trace:
[ 1869.733110]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.738655]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.743597]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.748618]
[ 1869.750142] xfsdatad/1    S 00000155d0bbb493     0  5148      2 (L-TLB)
[ 1869.756895]  ffff8100cdbafeb0 0000000000000046 0000000000000000 0000000000000000
[ 1869.764460]  ffff81012d54eb40 ffff81012b510750 ffff8101266c34b0 0000000127d04540
[ 1869.772010]  000000010003c9da 0000000000000000 ffff81000102f400 0000000100000008
[ 1869.779353] Call Trace:
[ 1869.782051]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.787605]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.792538]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.797559]
[ 1869.799076] xfsdatad/2    S 0000011302a779b7     0  5149      2 (L-TLB)
[ 1869.805828]  ffff8100cdbb1eb0 0000000000000046 0000000000000000 0000000000000246
[ 1869.813377]  ffff81012d8b7840 ffff81012b546e60 ffff8101266c2040 0000000227d04540
[ 1869.820943]  000000010002b0a6 0000000000000000 ffff810001038400 0000000200000008
[ 1869.828295] Call Trace:
[ 1869.830993]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.836546]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.841481]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.846500]
[ 1869.848018] xfsdatad/3    S 00000112dcf463fc     0  5150      2 (L-TLB)
[ 1869.854760]  ffff8100cdbb3eb0 0000000000000046 0000000000000000 0000000000000246
[ 1869.862318]  ffff81012e69b920 ffff81012b59f570 ffff810129d90950 0000000327d04540
[ 1869.869876]  000000010002b0c4 0000000000000000 ffff810001041400 0000000300000008
[ 1869.877229] Call Trace:
[ 1869.879935]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.885497]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.890449]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.895477]
[ 1869.896994] xfsdatad/4    S 00000155d5c1878c     0  5151      2 (L-TLB)
[ 1869.903746]  ffff8100cdbb5eb0 0000000000000046 0000000000000000 0000000000000246
[ 1869.911320]  ffff81012eaca060 ffff81012b59e100 ffff810129d90280 0000000427d04540
[ 1869.918879]  000000010003c9f6 0000000000000000 ffff81000104a400 0000000400000008
[ 1869.926230] Call Trace:
[ 1869.928936]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.934481]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.939424]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.944453]
[ 1869.945970] xfsdatad/5    S 0000011308b62b1a     0  5152      2 (L-TLB)
[ 1869.952722]  ffff8100cdbb7eb0 0000000000000046 0000000000000000 0000000000000246
[ 1869.960280]  ffff81012de52290 ffff81012b5f8810 ffff810129d916f0 0000000527d04540
[ 1869.967846]  000000010002b126 0000000000000000 ffff810001053400 0000000500000008
[ 1869.975198] Call Trace:
[ 1869.977895]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1869.983449]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1869.988383]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1869.993403]
[ 1869.994921] xfsdatad/6    S 00000155d5bde7fa     0  5153      2 (L-TLB)
[ 1870.001673]  ffff8100cdbb9eb0 0000000000000046 0000000000000000 0000000000000246
[ 1870.009229]  ffff81012ca14888 ffff81012b652f20 ffff81012663f830 0000000627d04540
[ 1870.016788]  000000010003c9f6 0000000000000000 ffff81000105c400 0000000600000008
[ 1870.024140] Call Trace:
[ 1870.026854]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1870.032400]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.037334]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.042354]
[ 1870.043871] xfsdatad/7    S 00000112ea914bc0     0  5154      2 (L-TLB)
[ 1870.050631]  ffff8100cdbbbeb0 0000000000000046 0000000000000000 0000000000000246
[ 1870.058188]  ffff81012cce9018 ffff81012b689630 ffff81012663e3c0 0000000727d04540
[ 1870.065746]  000000010002b0d5 0000000000000000 ffff810001065400 0000000700000008
[ 1870.073090] Call Trace:
[ 1870.075796]  [<ffffffff80245d15>] worker_thread+0xcb/0x117
[ 1870.081342]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.086266]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.091295]
[ 1870.092813] xfsbufd       S 000001b353efcc06     0  5155      2 (L-TLB)
[ 1870.099581]  ffff8100cdbbde70 0000000000000046 0000000000000000 ffff81012a7fc800
[ 1870.107139]  ffff810128e2c000 ffff81012b510750 ffff81012663f160 00000001276e13e0
[ 1870.114696]  000000010005510d 0000000000000000 ffff81000102f400 0000000180379049
[ 1870.122058] Call Trace:
[ 1870.124747]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1870.130474]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1870.137439]  [<ffffffff88268539>] :xfs:xfsbufd+0x76/0x141
[ 1870.142970]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.147909]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.152930]
[ 1870.154454] xfssyncd      S 000001aea3185bb3     0  5156      2 (L-TLB)
[ 1870.161199]  ffff8100cd561e50 0000000000000046 0000000000000000 0000000000000292
[ 1870.168772]  ffff81012b6117b0 ffff81012b59e100 ffff810127470750 00000004cd561db8
[ 1870.176321]  0000000100053e5f 0000000000000000 ffff81000104a400 00000004ce0afe00
[ 1870.183666] Call Trace:
[ 1870.186363]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1870.193676]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1870.200647]  [<ffffffff8826e565>] :xfs:xfssyncd+0x58/0x1af
[ 1870.206254]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.211179]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.216207]
[ 1870.217725] xfsbufd       S ffffffff8022b582     0  5158      2 (L-TLB)
[ 1870.224477]  ffff8100cd913e70 0000000000000046 0000000000000000 ffff810129045000
[ 1870.232043]  ffff8101276c8000 ffff81012a38d020 ffff810127470080 0000000329984d98
[ 1870.239601]  000000010004069c 0000000000000000 ffff810001041400 0000000380379049
[ 1870.246953] Call Trace:
[ 1870.249658]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1870.255378]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1870.262342]  [<ffffffff88268539>] :xfs:xfsbufd+0x76/0x141
[ 1870.267856]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.272795]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.277816]
[ 1870.279333] xfssyncd      S ffffffff8022b582     0  5159      2 (L-TLB)
[ 1870.286077]  ffff8100cd5ade50 0000000000000046 ffff8100cff45e40 0000000000000292
[ 1870.293650]  ffff81012b02cef0 ffff81012a38d020 ffff81012a254850 ffff8100cd5addb8
[ 1870.301208]  ffffffff8022dd01 0000000000000292 ffffffff804eae08 ffff8100cff45e40
[ 1870.308552] Call Trace:
[ 1870.311249]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1870.316969]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1870.323940]  [<ffffffff8826e565>] :xfs:xfssyncd+0x58/0x1af
[ 1870.329565]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.334507]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.339544]
[ 1870.341061] xfsbufd       S 000001b158e09d5a     0  5161      2 (L-TLB)
[ 1870.347797]  ffff8100cecfbe70 0000000000000046 0000000000000000 0000000000000000
[ 1870.355370]  ffff8100cecfa000 ffff81012b546e60 ffff81012a2555f0 0000000201026d80
[ 1870.362928]  0000000100054948 0000000000000000 ffff810001038400 000000022b548000
[ 1870.370281] Call Trace:
[ 1870.372978]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1870.378705]  [<ffffffff804ecfff>] schedule_timeout_interruptible+0x19/0x1e
[ 1870.385652]  [<ffffffff88268539>] :xfs:xfsbufd+0x76/0x141
[ 1870.391168]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.396106]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.401127]
[ 1870.402651] xfssyncd      D 0000015e2ed14f60     0  5162      2 (L-TLB)
[ 1870.409396]  ffff8100cd679ab0 0000000000000046 0000000000000000 ffffffff803d7ae7
[ 1870.416961]  ffff810117faa400 ffff81012b5f8810 ffff81012a254180 0000000528280d18
[ 1870.424518]  000000010003ed03 0000000000000000 ffff810001053400 0000000500000005
[ 1870.431871] Call Trace:
[ 1870.434579]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1870.441349]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1870.447685]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1870.453925]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1870.459136]  [<ffffffff8826794a>] :xfs:_xfs_buf_ioapply+0x2a4/0x2d2
[ 1870.465547]  [<ffffffff882679bf>] :xfs:xfs_buf_iorequest+0x47/0x7a
[ 1870.471866]  [<ffffffff8824b048>] :xfs:xlog_bdstrat_cb+0x16/0x42
[ 1870.478001]  [<ffffffff8824c25a>] :xfs:xlog_sync+0x29f/0x48f
[ 1870.483784]  [<ffffffff8824c4e4>] :xfs:xlog_state_release_iclog+0x9a/0xad
[ 1870.490712]  [<ffffffff8824cf80>] :xfs:xlog_state_sync_all+0xec/0x263
[ 1870.497284]  [<ffffffff8824dcb2>] :xfs:_xfs_log_force+0x5c/0x6b
[ 1870.503325]  [<ffffffff8825bef0>] :xfs:xfs_syncsub+0x5d/0x2e4
[ 1870.509204]  [<ffffffff8825c290>] :xfs:xfs_sync+0x11/0x16
[ 1870.514727]  [<ffffffff8826eeab>] :xfs:vfs_sync+0x25/0x2b
[ 1870.520274]  [<ffffffff8826e4f0>] :xfs:vfs_sync_worker+0x1c/0x39
[ 1870.526437]  [<ffffffff8826e668>] :xfs:xfssyncd+0x15b/0x1af
[ 1870.532143]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1870.537079]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1870.542108]
[ 1870.543625] screen        S 000001b0b0047cb0     0  5163   4937 (NOTLB)
[ 1870.550376]  ffff8100cde6df68 0000000000000086 0000000000000000 ffff8100cde6df48
[ 1870.557942]  ffff810129ee2100 ffff81012b652f20 ffff810129ee2100 0000000600000000
[ 1870.565508]  00000001000546f2 0000000000000000 ffff81000105c400 0000000680241e75
[ 1870.572861] Call Trace:
[ 1870.575559]  [<ffffffff80242431>] sys_pause+0x19/0x25
[ 1870.580678]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1870.585969]  [<00002b39516cd240>]
[ 1870.589322]
[ 1870.590852] screen        S 000001988a74b25f     0  5164   5163 (NOTLB)
[ 1870.597612]  ffff8100cda33a28 0000000000000082 0000000000000000 ffff81000000f9e0
[ 1870.605160]  0000000000000000 ffff81012b652f20 ffff810128164790 0000000600000002
[ 1870.612718]  000000010004e1ce 0000000000000000 ffff81000105c400 0000000600000000
[ 1870.620071] Call Trace:
[ 1870.622777]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1870.628496]  [<ffffffff8029ac9a>] do_select+0x437/0x484
[ 1870.633777]  [<ffffffff8029af47>] core_sys_select+0x260/0x37a
[ 1870.639596]  [<ffffffff8029b14c>] sys_select+0xeb/0x1c9
[ 1870.644876]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1870.650174]  [<00002b3951700053>]
[ 1870.653536]
[ 1870.655066] bash          S 00000000fffffe00     0  5165   5164 (NOTLB)
[ 1870.661817]  ffff8100ce249e38 0000000000000086 ffff81012b674b88 ffff8100ced9b018
[ 1870.669357]  00000000006d6f24 ffff8101267430e0 ffff81012af15830 ffffffff8022bf2c
[ 1870.676906]  ffff81012af15830 ffff81000105c400 ffff8101267430e0 ffff81000105c400
[ 1870.684250] Call Trace:
[ 1870.686948]  [<ffffffff80239098>] do_wait+0xbb9/0xcc5
[ 1870.692060]  [<ffffffff80239262>] sys_wait4+0x2b/0x30
[ 1870.697167]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1870.702457]  [<00002ac236f6bc05>]
[ 1870.705819]
[ 1870.707349] fstest        D 000001aea318689b     0  5182   5165 (NOTLB)
[ 1870.714092]  ffff8100cd847298 0000000000000086 0000000000000000 0000000000000000
[ 1870.721658]  00000004cd8472b8 ffff81012b59f570 ffff8101267430e0 00000003cd847580
[ 1870.729216]  0000000100053e5a 0000000000000000 ffff810001041400 000000038024ca2f
[ 1870.736560] Call Trace:
[ 1870.739266]  [<ffffffff804ee2f7>] __down+0x97/0x108
[ 1870.744204]  [<ffffffff804ee0f3>] __down_failed+0x35/0x3a
[ 1870.749695]  [<ffffffff88266aa2>] :xfs:xfs_buf_lock+0x4a/0x4c
[ 1870.755593]  [<ffffffff8825380a>] :xfs:xfs_getsb+0x2a/0x3a
[ 1870.761197]  [<ffffffff88258a26>] :xfs:xfs_trans_getsb+0x52/0xa1
[ 1870.767349]  [<ffffffff882573fd>] :xfs:xfs_trans_apply_sb_deltas+0x1c/0x2c4
[ 1870.774449]  [<ffffffff88257ee8>] :xfs:_xfs_trans_commit+0x12a/0x332
[ 1870.780942]  [<ffffffff8824889c>] :xfs:xfs_iomap_write_allocate+0x302/0x402
[ 1870.788032]  [<ffffffff8824798c>] :xfs:xfs_iomap+0x2f5/0x393
[ 1870.793820]  [<ffffffff8826da1a>] :xfs:xfs_bmap+0x10/0x15
[ 1870.799368]  [<ffffffff88264a24>] :xfs:xfs_map_blocks+0x43/0x81
[ 1870.805412]  [<ffffffff88265830>] :xfs:xfs_page_state_convert+0x297/0x58e
[ 1870.812349]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1870.818650]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1870.823846]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1870.829847]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1870.835751]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1870.842053]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1870.847525]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1870.854108]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1870.859811]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1870.865517]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1870.873005]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1870.879873]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1870.885672]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1870.892073]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1870.897618]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1870.902829]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1870.907929]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1870.913218]  [<000000000049c100>]
[ 1870.916572]
[ 1870.918102] bash          S 00000000fffffe00     0  5183   5164 (NOTLB)
[ 1870.924853]  ffff8100bdb71e38 0000000000000082 ffff8101286a5c38 ffff8100bdb6c018
[ 1870.932419]  00000000006d6f24 ffff810127e288d0 ffff8101267f4f60 ffffffff8022bf2c
[ 1870.939995]  ffff8101267f4f60 ffff81000105c400 ffff810127e288d0 ffff81000105c400
[ 1870.947347] Call Trace:
[ 1870.950044]  [<ffffffff80239098>] do_wait+0xbb9/0xcc5
[ 1870.955148]  [<ffffffff80239262>] sys_wait4+0x2b/0x30
[ 1870.960272]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1870.965553]  [<00002adbc54d8c05>]
[ 1870.968916]
[ 1870.970445] bash          S 000000fab7968117     0  5200   5164 (NOTLB)
[ 1870.977190]  ffff810098f07da8 0000000000000082 0000000000000000 ffffffff803bbdda
[ 1870.984763]  0000000000000082 ffffffff8068d100 ffff810129cf91a0 0000000080263ec4
[ 1870.992321]  0000000100024b63 0000000000000000 ffff810001026400 0000000080264c83
[ 1870.999666] Call Trace:
[ 1871.002371]  [<ffffffff804ecf4e>] schedule_timeout+0x1e/0xb6
[ 1871.008091]  [<ffffffff803bc712>] read_chan+0x44e/0x6c6
[ 1871.013371]  [<ffffffff803b6bf0>] tty_read+0xa0/0xf2
[ 1871.018401]  [<ffffffff8028d0b4>] vfs_read+0xc1/0x163
[ 1871.023517]  [<ffffffff8028d420>] sys_read+0x53/0x8a
[ 1871.030148]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.035447]  [<00002ab0640c3cd0>]
[ 1871.038809]
[ 1871.040330] fstest        D ffffffff8022b582     0  5217   5183 (NOTLB)
[ 1871.047065]  ffff810054a134b8 0000000000000086 ffff81012a04e800 ffffffff803d7ae7
[ 1871.054631]  ffff81012b679c00 ffff81012a38d020 ffff810127e288d0 ffff810128280d18
[ 1871.062197]  0000000000000005 ffff810129b80400 ffff81012b679c00 0000000000000005
[ 1871.069549] Call Trace:
[ 1871.072232]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1871.079001]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1871.085337]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1871.091577]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1871.096796]  [<ffffffff88264ac4>] :xfs:xfs_submit_ioend_bio+0x1e/0x28
[ 1871.103386]  [<ffffffff88264c54>] :xfs:xfs_submit_ioend+0xc5/0xe2
[ 1871.109636]  [<ffffffff88265ad5>] :xfs:xfs_page_state_convert+0x53c/0x58e
[ 1871.116564]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1871.122865]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1871.128066]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1871.134051]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1871.139965]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1871.146284]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1871.151754]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1871.158362]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1871.164092]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1871.169815]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1871.177303]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1871.184181]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1871.189995]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1871.196398]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1871.201951]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1871.207163]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1871.212279]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.217569]  [<000000000049c100>]
[ 1871.220931]
[ 1871.222461] bash          S 00000000fffffe00     0  5218   5164 (NOTLB)
[ 1871.229213]  ffff81005092de38 0000000000000086 ffff8101278ff298 ffff81005091c018
[ 1871.236770]  00000000006d6f24 ffff810129df71e0 ffff810127e28200 ffffffff8022bf2c
[ 1871.244328]  ffff810127e28200 ffff810001026400 ffff810129df71e0 ffff810001026400
[ 1871.251681] Call Trace:
[ 1871.254386]  [<ffffffff80239098>] do_wait+0xbb9/0xcc5
[ 1871.259490]  [<ffffffff80239262>] sys_wait4+0x2b/0x30
[ 1871.264606]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.269897]  [<00002b372064fc05>]
[ 1871.273259]
[ 1871.274788] fstest        D 00000155d8b9cf27     0  5243   5218 (NOTLB)
[ 1871.281557]  ffff810027ddb4b8 0000000000000082 0000000000000000 ffffffff803d7ae7
[ 1871.289114]  ffff810117faa400 ffff81012b510750 ffff810129df71e0 0000000128280d18
[ 1871.296680]  000000010003c9e9 0000000000000000 ffff81000102f400 0000000100000005
[ 1871.304025] Call Trace:
[ 1871.306724]  [<ffffffff881933f1>] :raid456:get_active_stripe+0x26c/0x509
[ 1871.313502]  [<ffffffff88196aba>] :raid456:make_request+0x4fc/0x690
[ 1871.319829]  [<ffffffff8036fb40>] generic_make_request+0x213/0x248
[ 1871.326078]  [<ffffffff8036fc39>] submit_bio+0xc4/0xcb
[ 1871.331297]  [<ffffffff88264ac4>] :xfs:xfs_submit_ioend_bio+0x1e/0x28
[ 1871.337869]  [<ffffffff88264c54>] :xfs:xfs_submit_ioend+0xc5/0xe2
[ 1871.344111]  [<ffffffff88265ad5>] :xfs:xfs_page_state_convert+0x53c/0x58e
[ 1871.351055]  [<ffffffff88265be2>] :xfs:xfs_vm_writepage+0xbb/0x105
[ 1871.357367]  [<ffffffff8026a09b>] __writepage+0xa/0x2f
[ 1871.362568]  [<ffffffff8026a533>] write_cache_pages+0x1a6/0x2cd
[ 1871.368535]  [<ffffffff8026a67c>] generic_writepages+0x22/0x2b
[ 1871.374456]  [<ffffffff88265c79>] :xfs:xfs_vm_writepages+0x4d/0x66
[ 1871.380776]  [<ffffffff8026a6a7>] do_writepages+0x22/0x36
[ 1871.386221]  [<ffffffff802ab575>] __writeback_single_inode+0x23b/0x438
[ 1871.392812]  [<ffffffff802abc2d>] sync_sb_inodes+0x225/0x312
[ 1871.398541]  [<ffffffff802abf47>] writeback_inodes+0x8e/0xe3
[ 1871.404263]  [<ffffffff80269ab3>] balance_dirty_pages_ratelimited_nr+0x125/0x22f
[ 1871.411735]  [<ffffffff80265a3f>] generic_file_buffered_write+0x52a/0x60d
[ 1871.418620]  [<ffffffff8826d6a3>] :xfs:xfs_write+0x6f4/0xa13
[ 1871.424427]  [<ffffffff88268a83>] :xfs:xfs_file_aio_write+0x5f/0x64
[ 1871.430821]  [<ffffffff8028d222>] do_sync_write+0xcc/0x112
[ 1871.436374]  [<ffffffff8028d32b>] vfs_write+0xc3/0x165
[ 1871.441585]  [<ffffffff8028d4aa>] sys_write+0x53/0x8a
[ 1871.446693]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.451984]  [<000000000049c100>]
[ 1871.455337]
[ 1871.456867] bash          S 00000000fffffe00     0  5244   5164 (NOTLB)
[ 1871.463619]  ffff8100c07f9e38 0000000000000082 ffff81012b61a978 ffff8100c07fd018
[ 1871.471176]  00000000006d6f24 ffff8101274937b0 ffff8101267437b0 ffffffff8022bf2c
[ 1871.478742]  ffff8101267437b0 ffff81000102f400 ffff8101274937b0 ffff81000102f400
[ 1871.486104] Call Trace:
[ 1871.488809]  [<ffffffff80239098>] do_wait+0xbb9/0xcc5
[ 1871.493921]  [<ffffffff80239262>] sys_wait4+0x2b/0x30
[ 1871.499029]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.504319]  [<00002b3061b25c05>]
[ 1871.507682]
[ 1871.509211] pdflush       D 00000155c27e6608     0  5268      2 (L-TLB)
[ 1871.515946]  ffff810038b85cf0 0000000000000046 0000000000000000 0000000000000000
[ 1871.523511]  0000000000000001 ffff81012b510750 ffff8101277f8fe0 0000000100001000
[ 1871.531078]  000000010003c9a2 0000000000000000 ffff81000102f400 0000000100000000
[ 1871.538430] Call Trace:
[ 1871.541145]  [<ffffffff88267458>] :xfs:xfs_buf_wait_unpin+0xd7/0x109
[ 1871.547647]  [<ffffffff882679a5>] :xfs:xfs_buf_iorequest+0x2d/0x7a
[ 1871.553983]  [<ffffffff8826d9db>] :xfs:xfs_bdstrat_cb+0x19/0x48
[ 1871.560050]  [<ffffffff882641b2>] :xfs:xfs_bwrite+0x73/0xed
[ 1871.565761]  [<ffffffff8825c027>] :xfs:xfs_syncsub+0x194/0x2e4
[ 1871.571740]  [<ffffffff8825c290>] :xfs:xfs_sync+0x11/0x16
[ 1871.577269]  [<ffffffff8826eeab>] :xfs:vfs_sync+0x25/0x2b
[ 1871.582808]  [<ffffffff8826e7d6>] :xfs:xfs_fs_write_super+0x22/0x28
[ 1871.589208]  [<ffffffff8028ecf8>] sync_supers+0x75/0xc9
[ 1871.594506]  [<ffffffff80269e47>] wb_kupdate+0x29/0x11e
[ 1871.599796]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1871.604912]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1871.609855]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1871.614876]
[ 1871.616393] pdflush       D 000001b3c2af5cda     0  5269      2 (L-TLB)
[ 1871.623144]  ffff810015f4fd70 0000000000000046 0000000000000000 ffffffff803385ae
[ 1871.630709]  ffff810015f4fcb0 ffff81012b510750 ffff810129f001c0 0000000100000000
[ 1871.638277]  00000001000552a3 0000000000000000 ffff81000102f400 0000000180249d77
[ 1871.645629] Call Trace:
[ 1871.648335]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1871.654062]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1871.660046]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1871.665681]  [<ffffffff80269dc6>] background_writeout+0xba/0xcb
[ 1871.671664]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1871.676779]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1871.681722]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1871.686743]
[ 1871.688260] pdflush       D 000001b3c95ab18a     0  5270      2 (L-TLB)
[ 1871.695020]  ffff810035be1d70 0000000000000046 0000000000000000 ffffffff803385ae
[ 1871.702585]  ffff810035be1cb0 ffff81012b59e100 ffff810126063060 0000000400000000
[ 1871.710144]  00000001000552bc 0000000000000000 ffff81000104a400 0000000480249d77
[ 1871.717496] Call Trace:
[ 1871.720201]  [<ffffffff804ecfba>] schedule_timeout+0x8a/0xb6
[ 1871.725921]  [<ffffffff804ecf01>] io_schedule_timeout+0x28/0x36
[ 1871.731904]  [<ffffffff8026fba7>] congestion_wait+0x9d/0xc2
[ 1871.737530]  [<ffffffff80269dc6>] background_writeout+0xba/0xcb
[ 1871.743522]  [<ffffffff8026ab5a>] pdflush+0x169/0x21f
[ 1871.748620]  [<ffffffff80249672>] kthread+0x4b/0x82
[ 1871.753563]  [<ffffffff8020ab28>] child_rip+0xa/0x12
[ 1871.758584]
[ 1871.760101] dmesg         D 0000015465378de7     0  5271   5244 (NOTLB)
[ 1871.766853]  ffff8100cabcd7c8 0000000000000082 0000000000000000 ffff81012b593440
[ 1871.774418]  0000000000000001 ffff81012b652f20 ffff8101274937b0 000000068022b21f
[ 1871.781977]  000000010003c3ea 0000000000000000 ffff81000105c400 000000068022b4a5
[ 1871.789336] Call Trace:
[ 1871.792034]  [<ffffffff804ece02>] wait_for_completion+0x9d/0xe3
[ 1871.798014]  [<ffffffff80245e53>] flush_cpu_workqueue+0x71/0x82
[ 1871.804005]  [<ffffffff80245e9a>] flush_workqueue+0x36/0x4c
[ 1871.809649]  [<ffffffff80246197>] flush_scheduled_work+0x10/0x15
[ 1871.815719]  [<ffffffff804d59d0>] xs_connect+0xeb/0xfe
[ 1871.820921]  [<ffffffff804d2f6d>] xprt_connect+0x12e/0x147
[ 1871.826461]  [<ffffffff804d1316>] call_connect+0x7f/0x8e
[ 1871.831838]  [<ffffffff804d6fec>] __rpc_execute+0x7f/0x25d
[ 1871.837397]  [<ffffffff804d71e8>] rpc_execute+0x1e/0x20
[ 1871.842677]  [<ffffffff804d0c65>] rpc_call_sync+0x7b/0xa1
[ 1871.848140]  [<ffffffff80339cf9>] nfs3_rpc_wrapper+0x29/0x6d
[ 1871.853881]  [<ffffffff8033a342>] nfs3_proc_access+0x11b/0x18b
[ 1871.859778]  [<ffffffff8032e337>] nfs_permission+0x172/0x23b
[ 1871.865508]  [<ffffffff8029472a>] permission+0xbe/0xcf
[ 1871.870693]  [<ffffffff8029474e>] vfs_permission+0x13/0x18
[ 1871.876243]  [<ffffffff80295004>] __link_path_walk+0x151/0xe91
[ 1871.882148]  [<ffffffff80295d93>] link_path_walk+0x4f/0xcc
[ 1871.887697]  [<ffffffff80294d55>] path_walk+0x1c/0x21
[ 1871.892813]  [<ffffffff80295fc7>] do_path_lookup+0x1b7/0x1db
[ 1871.900129]  [<ffffffff802960f4>] __path_lookup_intent_open+0x65/0xbd
[ 1871.906650]  [<ffffffff8029615b>] path_lookup_open+0xf/0x14
[ 1871.912285]  [<ffffffff80296cdf>] open_namei+0x7f/0x6cf
[ 1871.917584]  [<ffffffff8028c4a9>] do_filp_open+0x1c/0x3d
[ 1871.922967]  [<ffffffff8028c813>] do_sys_open+0x5e/0x102
[ 1871.928344]  [<ffffffff8028c8d2>] sys_open+0x1b/0x20
[ 1871.933373]  [<ffffffff80209d0e>] system_call+0x7e/0x83
[ 1871.938656]  [<00002b27c7948327>]
[ 1871.942009]


--Boundary-00=_G3wVHT4Gd17Nwut--
