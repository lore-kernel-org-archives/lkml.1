Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYL0KKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYL0KKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYL0KJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:09:52 -0500
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3442 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYL0KJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:09:50 -0500
Message-ID: <4955FEEB.1030500@xs4all.nl>
Date: Sat, 27 Dec 2008 11:09:47 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG on EN12000 w/ 2.6.28?
References: <4955F2F8.2040606@xs4all.nl>
In-Reply-To: <4955F2F8.2040606@xs4all.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> On my VIA Epia EN12000 with 2.6.28 I found:
> 
> Dec 27 04:03:20 recorder kernel: kernel BUG at fs/dcache.c:474!

There are about three of those.
Then I got:

Dec 27 04:03:23 recorder kernel: note: prelink[5389] exited with 
preempt_count 1
Dec 27 04:03:23 recorder kernel: BUG: scheduling while atomic: 
prelink/5389/0x10000002
Dec 27 04:03:23 recorder kernel: Modules linked in: nfsd lockd nfs_acl 
exportfs w83627hf hwmon_vid eeprom sunrpc binfmt_misc tda1004x 
snd_via82xx snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer 
snd_page_alloc budget_av snd_mpu401_uart saa7146_vv videobuf_dma_sg 
snd_rawmidi videobuf_core snd_seq_device budget_core saa7146 snd 
ttpci_eeprom i2c_viapro sg ohci1394 ieee1394 fan thermal processor 
button ata_generic uhci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Dec 27 04:03:23 recorder kernel: Pid: 5389, comm: prelink Tainted: G 
   D    2.6.28 #1
Dec 27 04:03:23 recorder kernel: Call Trace:
Dec 27 04:03:23 recorder kernel: [<c031935e>] schedule+0x69/0x2f8
Dec 27 04:03:23 recorder kernel: [<c01155a4>] __cond_resched+0x16/0x2c
Dec 27 04:03:23 recorder kernel: [<c031966d>] _cond_resched+0x24/0x2f
Dec 27 04:03:23 recorder kernel: [<c0148291>] unmap_vmas+0x37c/0x451
Dec 27 04:03:23 recorder kernel: [<c014b483>] exit_mmap+0x7b/0xf3
Dec 27 04:03:23 recorder kernel: [<c0118817>] mmput+0x1b/0x80
Dec 27 04:03:23 recorder kernel: [<c011b4a8>] exit_mm+0xbc/0xc3
Dec 27 04:03:23 recorder kernel: [<c013832e>] acct_collect+0x130/0x135
Dec 27 04:03:23 recorder kernel: [<c011c9a0>] do_exit+0x15a/0x68e
Dec 27 04:03:23 recorder kernel: [<c03192d4>] printk+0xe/0x12
Dec 27 04:03:23 recorder kernel: [<c0104a21>] oops_end+0x60/0x64
Dec 27 04:03:23 recorder kernel: [<c0103c39>] do_invalid_op+0x0/0x70
Dec 27 04:03:23 recorder kernel: [<c0103ca0>] do_invalid_op+0x67/0x70
Dec 27 04:03:23 recorder kernel: [<c01657ba>] __shrink_dcache_sb+0xae/0x2f1
Dec 27 04:03:23 recorder kernel: [<c012db09>] getnstimeofday+0x32/0xaf
Dec 27 04:03:23 recorder kernel: [<c01446aa>] shrink_list+0x23e/0x4ed
Dec 27 04:03:23 recorder kernel: [<c01414b3>] 
determine_dirtyable_memory+0xc/0x43
Dec 27 04:03:23 recorder kernel: [<c0141533>] get_dirty_limits+0x1c/0x245
Dec 27 04:03:23 recorder kernel: [<c031ad72>] error_code+0x6a/0x70
Dec 27 04:03:23 recorder kernel: [<c01657ba>] __shrink_dcache_sb+0xae/0x2f1
Dec 27 04:03:23 recorder kernel: [<c0165adf>] 
shrink_dcache_memory+0xe2/0x193
Dec 27 04:03:23 recorder kernel: [<c0144c7f>] shrink_slab+0xdd/0x146
Dec 27 04:03:23 recorder kernel: [<c0145596>] try_to_free_pages+0x1fb/0x2b9
Dec 27 04:03:23 recorder kernel: [<c014324a>] isolate_pages_global+0x0/0x1f2
Dec 27 04:03:23 recorder kernel: [<c01407bf>] 
__alloc_pages_internal+0x201/0x378
Dec 27 04:03:23 recorder kernel: [<c0148b22>] handle_mm_fault+0x139/0x5e2
Dec 27 04:03:23 recorder kernel: [<c0165da5>] dput+0x15/0x137
Dec 27 04:03:23 recorder kernel: [<c01110ec>] do_page_fault+0x29f/0x5f7
Dec 27 04:03:23 recorder kernel: [<c0161a21>] do_path_lookup+0x138/0x151
Dec 27 04:03:23 recorder kernel: [<c01d3fc3>] security_dentry_open+0xc/0xd
Dec 27 04:03:23 recorder kernel: [<c0157fa4>] __dentry_open+0x148/0x210
Dec 27 04:03:23 recorder kernel: [<c01580e9>] nameidata_to_filp+0x1c/0x2c
Dec 27 04:03:23 recorder kernel: [<c015bf01>] cp_new_stat64+0xf7/0x109
Dec 27 04:03:23 recorder kernel: [<c015c2e1>] sys_fstat64+0x1e/0x23
Dec 27 04:03:23 recorder kernel: [<c016308c>] do_fcntl+0x120/0x28f
Dec 27 04:03:23 recorder kernel: [<c0163263>] sys_fcntl64+0x68/0x79
Dec 27 04:03:23 recorder kernel: [<c016326d>] sys_fcntl64+0x72/0x79
Dec 27 04:03:23 recorder kernel: [<c0110e4d>] do_page_fault+0x0/0x5f7
Dec 27 04:03:23 recorder kernel: [<c031ad72>] error_code+0x6a/0x70

(at this point all sorts of nightly jobs go wrong with similar errors)


