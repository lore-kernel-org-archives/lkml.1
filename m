Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXLNWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXLNWN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbXLNWN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:13:26 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:52033 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555AbXLNWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:13:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ipENI/soIQF+afY4WAwQpyPGpZxk69HaBmd/8QFPzKtOt6Rmqv1o06S6Te3bgtYf83L2cfdrrS5VZ8SSZokrop+8nzv2KO9f9YA2Z0Zvq2IR0l5N3xK0NQ4qcDIGe04DhORYJ52DKuIAEk1aYUlubWaToVVm7ESeEOM4ya9gvTw=
Message-ID: <a44ae5cd0712141413u4ddbfd06gca259cfc3bc0ab1a@mail.gmail.com>
Date: Fri, 14 Dec 2007 17:13:21 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24-rc5-mm1 -- inconsistent {in-softirq-W} -> {softirq-on-R} usage.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Andrew, I don't know who to forward this problem to.

I tried running:  find /proc | xargs cat
and got this:

=================================
[ INFO: inconsistent lock state ]
2.6.24-rc5-mm1 #26
---------------------------------
inconsistent {in-softirq-W} -> {softirq-on-R} usage.
cat/6944 [HC0[0]:SC0[0]:HE1:SE1] takes:
BUG: unable to handle kernel paging request at virtual address 0f1eff0b
printing ip: c01fe64d *pde = 00000000
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/block/sda/sda3/stat
Modules linked in: aes_generic i915 drm rfcomm l2cap bluetooth
cpufreq_stats cpufreq_conservative cpufreq_performance sbs sbshc
dm_crypt sbp2 parport_pc lp parport pcmcia arc4 ecb crypto_blkcipher
cryptomgr crypto_algapi tifm_7xx1 tifm_core yenta_socket
rsrc_nonstatic pcmcia_core iwl3945 iTCO_wdt iTCO_vendor_support
watchdog_core watchdog_dev snd_hda_intel mac80211 snd_pcm_oss
snd_mixer_oss cfg80211 snd_pcm sky2 snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device snd soundcore snd_page_alloc shpchp pci_hotplug
firewire_ohci firewire_core crc_itu_t ata_generic piix ide_core

Pid: 6944, comm: cat Not tainted (2.6.24-rc5-mm1 #26)
EIP: 0060:[<c01fe64d>] EFLAGS: 00210097 CPU: 0
EIP is at strnlen+0x9/0x1c
EAX: 0f1eff0b EBX: 0f1eff0b ECX: 0f1eff0b EDX: fffffffe
ESI: c05b74f6 EDI: d6267d94 EBP: d6267cc8 ESP: d6267cc8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process cat (pid: 6944, ti=d6267000 task=d5a09000 task.ti=d6267000)
Stack: d6267cfc c01fdd22 00000400 c05b74f4 00000001 c05b78f4 00000000 ffffffff
       ffffffff c048f503 00000400 d5a09000 00000002 d6267d0c c01fdf41 d6267d94
       db68c04a d6267d74 c012ae81 d6267d94 00000028 c05b89f7 00200046 00000000
Call Trace:
 [<c0108eb2>] show_trace_log_lvl+0x12/0x25
 [<c0108f4f>] show_stack_log_lvl+0x8a/0x95
 [<c0108fe4>] show_registers+0x8a/0x1bd
 [<c010922f>] die+0x118/0x1dc
 [<c03cf706>] do_page_fault+0x5a4/0x681
 [<c03cdd72>] error_code+0x72/0x78
 [<c01fdd22>] vsnprintf+0x277/0x40e
 [<c01fdf41>] vscnprintf+0xe/0x1d
 [<c012ae81>] vprintk+0xcb/0x2f3
 [<c012b0be>] printk+0x15/0x17
 [<c0145e55>] print_lock_name+0x4e/0xa2
 [<c0146099>] print_lock+0xe/0x3a
 [<c01464cf>] print_usage_bug+0xbc/0x117
 [<c0146fb6>] mark_lock+0x2e7/0x3fe
 [<c0147b9a>] __lock_acquire+0x498/0xbf4
 [<c014836c>] lock_acquire+0x76/0x9d
 [<c03cd6d2>] _read_lock+0x23/0x32
 [<c03491ae>] sock_i_ino+0x14/0x30
 [<c03c88ed>] packet_seq_show+0x22/0x75
 [<c019b41a>] seq_read+0x19d/0x26f
 [<c01b0ded>] proc_reg_read+0x60/0x74
 [<c01854aa>] vfs_read+0x8a/0x106
 [<c01858a8>] sys_read+0x3b/0x60
 [<c0107cea>] sysenter_past_esp+0x6b/0xc1
 =======================
Code: 01 00 00 00 4f 89 fa 5f 89 d0 5d c3 55 85 c9 89 e5 57 89 c7 89
d0 74 05 f2 ae 75 01 4f 89 f8 5f 5d c3 55 89 c1 89 e5 89 c8 eb 06 <80>
38 00 74 07 40 4a 83 fa ff 75 f4 29 c8 5d c3 90 90 90 55 83
EIP: [<c01fe64d>] strnlen+0x9/0x1c SS:ESP 0068:d6267cc8
note: cat[6944] exited with preempt_count 4
