Return-Path: <linux-kernel-owner+w=401wt.eu-S1757635AbZDWOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbZDWOA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZDWOAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:00:07 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:61344 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbZDWOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:00:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwGAMcQ8ElMQW1W/2dsb2JhbACBT851g3UG
Date: Thu, 23 Apr 2009 10:00:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [BUG] 2.6.29.1 debugobjects warning
Message-ID: <20090423140002.GA12852@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:56:52 up 54 days, 10:23,  1 user,  load average: 0.38, 0.61,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got the following warning on my Thinkpad T43p laptop (single-core
32-bits x86). I run the 2.6.29.1 tree, plus LTTng patchset applied. It
seems to come from cpufreq. Any idea what is going on here ?


------------[ cut here ]------------
WARNING: at lib/debugobjects.c:217 debug_print_object+0x5a/0x70()
Hardware name: 2687D5U
ODEBUG: init active object type: timer_list
Modules linked in: irda parport nsc_ircc irtty_sir parport_pc psmouse snd_seq sn
d_seq_midi_event hid_logitech ac unix floppy output battery sir_dev nvram snd_ra
wmidi pcmcia x_tables ip_tables joydev snd_seq_midi evdev video snd_page_alloc s
oundcore led_class i2c_i801 cryptoloop snd snd_seq_dummy rfkill thinkpad_acpi sn
d_seq_oss snd_mixer_oss loop ipw2200 blowfish aes_i586 snd_pcm_oss ac97_bus snd_
seq_device agpgart snd_pcm ide_cd_mod snd_timer intel_agp snd_ac97_codec ide_gen
eric button snd_intel8x0 edd acpi_cpufreq ltt_statedump ipc_trace usbhid thermal
 mm_trace snd_intel8x0m fs_trace pcmcia_core rcu_trace lib80211 syscall_trace rs
rc_nonstatic libphy serio_raw kernel_trace tg3 trap_trace libipw crc_ccitt net_t
race dm_mod dm_log dm_region_hash dm_mirror yenta_socket dm_snapshot fat vfat nl
s_cp437 nls_iso8859_1 lp ppdev af_packet drm ntfs ipv6 auth_rpcgss binfmt_misc r
adeon lockd sunrpc nfs
Pid: 3628, comm: cpufreqd Not tainted 2.6.29.1-trace #28
Call Trace:
 [<c1044123>] warn_slowpath+0x73/0xd0
 [<c1069c28>] ? mark_held_locks+0x48/0x90
 [<c13313f5>] ? __mutex_unlock_slowpath+0xd5/0x150
 [<c1069f39>] ? trace_hardirqs_on_caller+0x199/0x1f0
 [<c1331478>] ? mutex_unlock+0x8/0x10
 [<c1331478>] ? mutex_unlock+0x8/0x10
 [<c1107b76>] ? sysfs_addrm_finish+0x16/0x230
 [<c1107671>] ? sysfs_find_dirent+0x21/0x30
 [<c116d71a>] debug_print_object+0x5a/0x70
 [<c116e054>] __debug_object_init+0x254/0x340
 [<c126533f>] ? cpufreq_governor_dbs+0x10f/0x210
 [<c116e187>] debug_object_init+0x17/0x20
 [<c104de70>] init_timer+0x10/0x30
 [<c104de9b>] init_timer_deferrable+0xb/0x20
 [<c12653fd>] cpufreq_governor_dbs+0x1cd/0x210
 [<c126205b>] __cpufreq_governor+0xab/0x120
 [<c12621cb>] __cpufreq_set_policy+0xfb/0x140
 [<c1262c24>] store_scaling_governor+0xa4/0x220
 [<c1263550>] ? handle_update+0x0/0x10
 [<c1262b80>] ? store_scaling_governor+0x0/0x220
 [<c126343e>] store+0x4e/0x70
 [<c1106b9c>] sysfs_write_file+0x9c/0x100
 [<c10b825c>] vfs_write+0x9c/0x140
 [<c1106b00>] ? sysfs_write_file+0x0/0x100
 [<c10b8447>] sys_write+0x47/0xe0
 [<c1021dde>] syscall_call+0x7/0xb
 [<c1020000>] ? sys_vfork+0x20/0x30


Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
