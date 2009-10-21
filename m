Return-Path: <linux-kernel-owner+w=401wt.eu-S1752059AbZJUF0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbZJUF0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 01:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZJUF0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 01:26:24 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:46880 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZJUF0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 01:26:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dYfvNue2/rwU+yVwmljE3A8/2Uh8lfSwQhnCcfmnruRxqOBie0PolyFU3iFfPGyU8j
         WEk5OZ89b1B3rq56D0GhnoPzxIUXhweusoPLfbarLZ9/lVZ/oOeVveQKXwRqG3I4CZ8F
         qIrw9j6aZVC7veky65AtqFYQ/a0yVIHpcPIGg=
Message-ID: <4ADE9B79.9090906@gmail.com>
Date: Tue, 20 Oct 2009 23:26:17 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.32-rc4ish: task umount blocked for more than 120 seconds after
 USB drive removal
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a post-2.6.32-rc4 git kernel, and just unmounted a USB drive 
after writing a bunch of data to it, then pulled the plug after I 
thought it had finished unmounting, but apparently it hadn't.. Ran into 
a hung task warning that repeats every 120 seconds, the umount command 
for the drive is stuck in D state.

The full SysRq-T output is shown at the bottom.. any ideas what it's 
waiting for?

Oct 20 21:42:42 newcastle kernel: usb 1-1.6: USB disconnect, address 5
Oct 20 21:42:42 newcastle gnome-keyring-daemon[2598]: removing removable 
location: volume_uuid_01E0_9221
Oct 20 21:45:26 newcastle kernel: INFO: task umount:5380 blocked for 
more than 120 seconds.
Oct 20 21:45:26 newcastle kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 20 21:45:26 newcastle kernel: umount        D 0000000000000002     0 
  5380   2853 0x00000080
Oct 20 21:45:26 newcastle kernel: ffff880118651bc8 0000000000000086 
ffff880118651b68 00000000d54e0b08
Oct 20 21:45:26 newcastle kernel: 00000000000004f1 ffff88013bbd9798 
ffff8800282558b0 ffff880118651fd8
Oct 20 21:45:26 newcastle kernel: ffff880118651fd8 ffff8800504cb280 
000000000000fb38 0000000000015840
Oct 20 21:45:26 newcastle kernel: Call Trace:
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117d555>] 
bdi_sched_wait+0x21/0x39
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 21:45:26 newcastle kernel: [<ffffffff815147e0>] 
__wait_on_bit+0x57/0x9e
Oct 20 21:45:26 newcastle kernel: [<ffffffff815148a4>] 
out_of_line_wait_on_bit+0x7d/0x9c
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 21:45:26 newcastle kernel: [<ffffffff810917ca>] ? 
wake_bit_function+0x0/0x5a
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117e43e>] 
wait_on_bit.clone.1+0x2f/0x45
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117e4c7>] 
bdi_sync_writeback+0x73/0x8e
Oct 20 21:45:26 newcastle kernel: [<ffffffff8117e517>] 
sync_inodes_sb+0x35/0x115
Oct 20 21:45:26 newcastle kernel: [<ffffffff81182a95>] 
__sync_filesystem+0x5f/0x9f
Oct 20 21:45:26 newcastle kernel: [<ffffffff81182d01>] 
sync_filesystem+0x5a/0x75
Oct 20 21:45:26 newcastle kernel: [<ffffffff81158515>] 
generic_shutdown_super+0x3a/0xf2
Oct 20 21:45:26 newcastle kernel: [<ffffffff81158607>] 
kill_block_super+0x3a/0x6a
Oct 20 21:45:26 newcastle kernel: [<ffffffff81158eaf>] 
deactivate_super+0x68/0x95
Oct 20 21:45:26 newcastle kernel: [<ffffffff81175b32>] 
mntput_no_expire+0xc6/0x114
Oct 20 21:45:26 newcastle kernel: [<ffffffff811761af>] 
sys_umount+0x2e9/0x32e
Oct 20 21:45:26 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 21:45:26 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b

SysRq-T:

Oct 20 23:18:05 newcastle kernel: mingetty      S ffff88002824fb38     0 
  2375      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880132c25cd8 0000000000000082 
0000000000000000 00000000e6059a24
Oct 20 23:18:05 newcastle kernel: ffff880132c25c38 00000000e6059a24 
ffff880132c25c58 ffff880132c25fd8
Oct 20 23:18:05 newcastle kernel: ffff880132c25fd8 ffff880134e649e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff815144b9>] 
schedule_timeout+0x36/0xe3
Oct 20 23:18:05 newcastle kernel: [<ffffffff813372e2>] 
n_tty_read+0x4ad/0x791
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff813323af>] tty_read+0x90/0xe8
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gdm-simple-sl S ffff88013a59aa40     0 
  2418   2370 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013a1c5a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000681ebc14 
ffff88013a1c59f8 ffff88013a1c5fd8
Oct 20 23:18:05 newcastle kernel: ffff88013a1c5fd8 ffff8801321b3280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: Xorg          S ffff88002820fb38     0 
  2419   2418 0x00400080
Oct 20 23:18:05 newcastle kernel: ffff8801355bb908 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88011df82ec0 0000000000000246 
0000060a12047ca0 ffff8801355bbfd8
Oct 20 23:18:05 newcastle kernel: ffff8801355bbfd8 ffff8801280683c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dhclient      S ffff88002824fb38     0 
  2421   2196 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880139c03908 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282502f8 0000000000000246 
000020bf69fd4642 ffff880139c03fd8
Oct 20 23:18:05 newcastle kernel: ffff880139c03fd8 ffff8801321b1b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81107c7d>] ? 
free_pcppages_bulk+0xc1/0x139
Oct 20 23:18:05 newcastle kernel: [<ffffffff81108f17>] ? 
__pagevec_free+0x87/0xb2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81298778>] ? 
cpumask_any_but+0x3c/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81044ac1>] ? 
flush_tlb_page+0x73/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: sendmail      S ffff88002824fb38     0 
  2480      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801323b1f58 0000000000000082 
0000000000000000 ffff8801322631b0
Oct 20 23:18:05 newcastle kernel: ffff880132262ec0 ffff88013a37a000 
0000000000000000 ffff8801323b1fd8
Oct 20 23:18:05 newcastle kernel: ffff8801323b1fd8 ffff880132263280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8107f050>] sys_pause+0x31/0x4e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: sendmail      S 0000000000000005     0 
  2481      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880132343908 0000000000000086 
ffff880132343868 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282102f8 0000000000000246 
0000060a7e0885e3 ffff880132343fd8
Oct 20 23:18:05 newcastle kernel: ffff880132343fd8 ffff880132389b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8124b38f>] ? 
security_d_instantiate+0x37/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129fa90>] ? put_dec+0x2e/0x103
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129fcc1>] ? number+0x15c/0x266
Oct 20 23:18:05 newcastle kernel: [<ffffffff81178900>] ? 
seq_read+0x2d6/0x379
Oct 20 23:18:05 newcastle kernel: [<ffffffff81178a3f>] ? seq_open+0x9c/0xd0
Oct 20 23:18:05 newcastle kernel: [<ffffffff81142a92>] ? 
virt_to_head_page+0x21/0x56
Oct 20 23:18:05 newcastle kernel: [<ffffffff81191ee6>] ? 
fsnotify_clear_marks_by_inode+0x3e/0xfa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81142a92>] ? 
virt_to_head_page+0x21/0x56
Oct 20 23:18:05 newcastle kernel: [<ffffffff811b7601>] ? 
proc_delete_inode+0x0/0x76
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116cdf9>] ? d_free+0x58/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-launch   S ffff880135601a00     0 
  2499      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880132395908 0000000000000082 
ffff88012806c620 000000002323d3e3
Oct 20 23:18:05 newcastle kernel: ffff880128068000 000000002323d3e3 
ffff880132395868 ffff880132395fd8
Oct 20 23:18:05 newcastle kernel: ffff880132395fd8 ffff88012806c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8151651d>] ? 
_spin_unlock_irqrestore+0x38/0x64
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e810e>] ? scm_recv+0x4c/0xe0
Oct 20 23:18:05 newcastle kernel: [<ffffffff814548d7>] ? 
skb_dequeue+0x73/0x95
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e8fe9>] ? 
unix_stream_recvmsg+0x531/0x565
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: devkit-power- S ffff88002822fb38     0 
  2563      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88012446ba48 0000000000000082 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000001c94297 0000000000000246 
0000060fe667abee ffff88012446bfd8
Oct 20 23:18:05 newcastle kernel: ffff88012446bfd8 ffff8801321c49e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144ea4d>] ? 
sock_aio_write+0xcf/0xf7
Oct 20 23:18:05 newcastle kernel: [<ffffffff811553f6>] ? 
do_sync_readv_writev+0xf7/0x14a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81156478>] ? 
do_readv_writev+0x129/0x156
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: devkit-daemon S ffff88013a59d7c0     0 
  2565      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124671a48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 000000008d6e8721 
ffff8801246719f8 ffff880124671fd8
Oct 20 23:18:05 newcastle kernel: ffff880124671fd8 ffff880128223280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gdm-session-w S ffff88002826fb38     0 
  2587   2418 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880132349a48 0000000000000082 
ffff880132349a08 ffff880132349a04
Oct 20 23:18:05 newcastle kernel: 00000000017d783f 0000000000000000 
00000000000005ff ffff880132349fd8
Oct 20 23:18:05 newcastle kernel: ffff880132349fd8 ffff88012470b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114b7c8>] ? 
try_get_mem_cgroup_from_mm+0x4c/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114cac5>] ? 
__mem_cgroup_try_charge+0x5c/0x1e8
Oct 20 23:18:05 newcastle kernel: [<ffffffff81252251>] ? 
avc_has_perm+0x6b/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81252dda>] ? 
selinux_task_wait+0x53/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249eaf>] ? 
security_task_wait+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091ba3>] ? 
remove_wait_queue+0x44/0x65
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106af75>] ? do_wait+0x1ec/0x245
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-keyring S ffff88013a59a080     0 
  2598      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124689a48 0000000000000086 
ffff880124689a58 0000000000000000
Oct 20 23:18:05 newcastle kernel: 00000000017d783f 0000000000000000 
ffff880000016108 ffff880124689fd8
Oct 20 23:18:05 newcastle kernel: ffff880124689fd8 ffff880124709b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-session S ffff88002824fb38     0 
  2622   2587 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124421a48 0000000000000082 
ffff880124421a08 ffff880124421a04
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
0000000000000500 ffff880124421fd8
Oct 20 23:18:05 newcastle kernel: ffff880124421fd8 ffff88012470c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-session S ffff88002826fb38     0 
  2683   2587 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88012448dc68 0000000000000082 
0000000000000000 000000003d73e204
Oct 20 23:18:05 newcastle kernel: ffff88012448dc08 ffffffff81518f83 
ffff880139be2de0 ffff88012448dfd8
Oct 20 23:18:05 newcastle kernel: ffff88012448dfd8 ffff88012806b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81518f83>] ? 
do_page_fault+0x289/0x2cd
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115fb14>] pipe_wait+0x70/0xa0
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811602f9>] pipe_read+0x358/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff812548a7>] ? 
inode_has_perm+0x7a/0x90
Oct 20 23:18:05 newcastle kernel: [<ffffffff81043b29>] ? 
ptep_set_access_flags+0x53/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-launch   S ffff880135601a00     0 
  2634      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880128253908 0000000000000086 
ffff880132264620 00000000eb038403
Oct 20 23:18:05 newcastle kernel: ffff880128068000 00000000eb038403 
ffff880128253868 ffff880128253fd8
Oct 20 23:18:05 newcastle kernel: ffff880128253fd8 ffff8801322649e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8151651d>] ? 
_spin_unlock_irqrestore+0x38/0x64
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e810e>] ? scm_recv+0x4c/0xe0
Oct 20 23:18:05 newcastle kernel: [<ffffffff814548d7>] ? 
skb_dequeue+0x73/0x95
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e8fe9>] ? 
unix_stream_recvmsg+0x531/0x565
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-daemon   S ffff8801399230c0     0 
  2636      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880128235a48 0000000000000086 
0000000000000001 0000000038971b25
Oct 20 23:18:05 newcastle kernel: ffff8801282359e8 0000000000000000 
ffff880000016108 ffff880128235fd8
Oct 20 23:18:05 newcastle kernel: ffff880128235fd8 ffff880132261b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514d5e>] ? 
mutex_lock+0x38/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-daemon   S ffff88002822fb38     0 
  2637      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801282dba48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
0000000000000000 ffff8801282dbfd8
Oct 20 23:18:05 newcastle kernel: ffff8801282dbfd8 ffff88013a661b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff815144b9>] 
schedule_timeout+0x36/0xe3
Oct 20 23:18:05 newcastle kernel: [<ffffffff810919d9>] ? 
prepare_to_wait_exclusive+0x6b/0x8b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458a6c>] 
__skb_recv_datagram+0x1ed/0x276
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458b44>] ? 
receiver_wake_function+0x0/0x44
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458b29>] 
skb_recv_datagram+0x34/0x4f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8147e84a>] 
netlink_recvmsg+0x69/0x317
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c9c0>] 
sock_recvmsg+0xde/0x10b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8112d124>] ? 
page_add_new_anon_rmap+0x52/0x78
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c2b4>] ? 
sockfd_lookup_light+0x33/0x81
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144e031>] 
sys_recvfrom+0xd7/0x141
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81095d0b>] ? up_read+0x21/0x37
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gconfd-2      S ffff880135603a80     0 
  2681      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801323e1a48 0000000000000086 
ffff8801323e19a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 00000000000e3c86 0000000000000246 
0000060a1fa9487e ffff8801323e1fd8
Oct 20 23:18:05 newcastle kernel: ffff8801323e1fd8 ffff88012470e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-setting S ffff88012820be4c     0 
  2686      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88012820ba48 0000000000000082 
ffff88012820b9a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000005f5e100 0000000000000246 
00004e9e3de35a18 ffff88012820bfd8
Oct 20 23:18:05 newcastle kernel: ffff88012820bfd8 ffff8801322603c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-setting S ffff880135601a00     0 
  2690      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124445c68 0000000000000082 
ffff880124445c28 ffff880124445c24
Oct 20 23:18:05 newcastle kernel: 000200da24445c08 0000000000000000 
0000000000000400 ffff880124445fd8
Oct 20 23:18:05 newcastle kernel: ffff880124445fd8 ffff8801282203c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115fb14>] pipe_wait+0x70/0xa0
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811602f9>] pipe_read+0x358/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff812548a7>] ? 
inode_has_perm+0x7a/0x90
Oct 20 23:18:05 newcastle kernel: [<ffffffff8110d653>] ? 
lru_cache_add_lru+0x3a/0x50
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: metacity      S ffff880135601a00     0 
  2693   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801323a1a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000eb1d44f6 
ffff8801323a19f8 ffff8801323a1fd8
Oct 20 23:18:05 newcastle kernel: ffff8801323a1fd8 ffff8801323883c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: metacity      S ffff880139be5140     0 
  4813   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801155cfa48 0000000000000082 
ffff8801155cfa58 00000000ce4be18a
Oct 20 23:18:05 newcastle kernel: ffff88011b2ce300 00000000ce4be18a 
ffff8801155cf9b8 ffff8801155cffd8
Oct 20 23:18:05 newcastle kernel: ffff8801155cffd8 ffff8801185e9b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c9c0>] ? 
sock_recvmsg+0xde/0x10b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81457abe>] ? 
verify_iovec+0x60/0xb6
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c26b>] ? 
fput_light+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144df24>] ? 
sys_recvmsg+0x255/0x28b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: pulseaudio    S ffff8801399230c0     0 
  2697      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801246ada48 0000000000000082 
ffff8801246ada08 ffff8801246ada04
Oct 20 23:18:05 newcastle kernel: ffff8801246ad998 000000006e16f74c 
0000000000000400 ffff8801246adfd8
Oct 20 23:18:05 newcastle kernel: ffff8801246adfd8 ffff8801321b6140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: pulseaudio    S ffff8801247dddcc     0 
  2711      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801247dda08 0000000000000082 
ffff8801247dd968 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000246 
00000609f5b126df ffff8801247ddfd8
Oct 20 23:18:05 newcastle kernel: ffff8801247ddfd8 ffff880134e0e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff812a219b>] ? 
copy_user_generic_string+0xb/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0b804ed>] ? 
snd_pcm_status_user+0x58/0x83 [snd_pcm]
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0b8354e>] ? 
snd_pcm_common_ioctl1+0x348/0x9e8 [snd_pcm]
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8107f090>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116bff8>] sys_ppoll+0xcf/0x16c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: pulseaudio    S ffff880139be5140     0 
  2714      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801247bda08 0000000000000082 
ffff8801247bda18 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
ffff8801247bd998 ffff8801247bdfd8
Oct 20 23:18:05 newcastle kernel: ffff8801247bdfd8 ffff880134c9b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0bb2b5b>] ? 
__spin_unlock_irq+0x23/0x40 [snd_hda_intel]
Oct 20 23:18:05 newcastle kernel: [<ffffffff81106d1b>] ? list_add+0x24/0x3a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114154c>] ? 
add_partial+0x4a/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81298778>] ? 
cpumask_any_but+0x3c/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81044ac1>] ? 
flush_tlb_page+0x73/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81043b29>] ? 
ptep_set_access_flags+0x53/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81120bf0>] ? 
do_wp_page+0x2d0/0x6ab
Oct 20 23:18:05 newcastle kernel: [<ffffffff810948f2>] ? 
__remove_hrtimer+0x91/0xb4
Oct 20 23:18:05 newcastle kernel: [<ffffffff81080bf2>] ? 
dequeue_signal+0xba/0x141
Oct 20 23:18:05 newcastle kernel: [<ffffffff8107f090>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116bff8>] sys_ppoll+0xcf/0x16c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-panel   S ffff8800bf13c214     0 
  2698   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880128329a48 0000000000000082 
ffff8801283299a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282502f8 0000000000000246 
0000060a96e175a4 ffff880128329fd8
Oct 20 23:18:05 newcastle kernel: ffff880128329fd8 ffff8801282249e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfsd         S ffff880139be5480     0 
  2700      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801244a9a48 0000000000000086 
0000000000000003 00000000eae313ff
Oct 20 23:18:05 newcastle kernel: ffff8801244a99e8 ffffffff81060347 
00000800244a99f8 ffff8801244a9fd8
Oct 20 23:18:05 newcastle kernel: ffff8801244a9fd8 ffff880132266140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff811553f6>] ? 
do_sync_readv_writev+0xf7/0x14a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81156478>] ? 
do_readv_writev+0x129/0x156
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-fuse-dae S ffff88002824fb38     0 
  2706      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124783c28 0000000000000082 
ffff880124783be8 ffff880124783be4
Oct 20 23:18:05 newcastle kernel: ffff88013238b5e0 0000000000000000 
0000000000000400 ffff880124783fd8
Oct 20 23:18:05 newcastle kernel: ffff880124783fd8 ffff88013238b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff8110313e>] ? 
unlock_page+0x27/0x3d
Oct 20 23:18:05 newcastle kernel: [<ffffffff811205a2>] ? 
__do_fault+0x3bc/0x409
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106194c>] ? 
wake_up_new_task+0xdf/0xfe
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-fuse-dae S ffff880135605e40     0 
  2707      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124799c58 0000000000000082 
0000000000000001 000000007736935a
Oct 20 23:18:05 newcastle kernel: ffff88012469d000 ffff8801244d4278 
ffffffffa0a8f431 ffff880124799fd8
Oct 20 23:18:05 newcastle kernel: ffff880124799fd8 ffff88013238c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0a8f431>] ? 
process_init_reply+0x0/0x201 [fuse]
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0a86b9f>] 
request_wait+0x76/0xf0 [fuse]
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0a87844>] 
fuse_dev_read+0xaa/0x2d4 [fuse]
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-fuse-dae S ffff88002824fb38     0 
  2708      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88012479bc58 0000000000000082 
ffff88012479bc18 ffff88012479bc14
Oct 20 23:18:05 newcastle kernel: 0000000003f72a38 0000000000000000 
0000000000000400 ffff88012479bfd8
Oct 20 23:18:05 newcastle kernel: ffff88012479bfd8 ffff88012806e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0a86b9f>] 
request_wait+0x76/0xf0 [fuse]
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffffa0a87844>] 
fuse_dev_read+0xaa/0x2d4 [fuse]
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-fuse-dae S ffff880124781e0c     0 
  2709      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124781a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000f9dbd73b 
ffff8801247819f8 ffff880124781fd8
Oct 20 23:18:05 newcastle kernel: ffff880124781fd8 ffff880128069b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: nautilus      S ffff880135601a00     0 
  2710   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124561a48 0000000000000086 
ffff8801245619a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000005f5e100 0000000000000246 
0007a7285878577d ffff880124561fd8
Oct 20 23:18:05 newcastle kernel: ffff880124561fd8 ffff880139f76140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: bonobo-activa S ffff88013a59c780     0 
  2713      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121c87a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 000000006ded2426 
ffff880121c879f8 ffff880121c87fd8
Oct 20 23:18:05 newcastle kernel: ffff880121c87fd8 ffff8801247083c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81053ac3>] ? 
task_rq_unlock+0x24/0x3a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff810603cb>] ? 
wake_up_state+0x23/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a31ec>] ? 
wake_futex+0x51/0x6c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a32ed>] ? 
futex_wake+0xe6/0x10c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e3b>] ? do_futex+0xe1/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: bonobo-activa S ffff880135603a80     0 
  2715      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121cefa48 0000000000000082 
ffff880121cefa08 ffff880121cefa04
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
00000000000004fe ffff880121ceffd8
Oct 20 23:18:05 newcastle kernel: ffff880121ceffd8 ffff8801321b03c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: seapplet      S ffff8801247f9e0c     0 
  2717   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801247f9a48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000093632e1 
ffff8801247f99f8 ffff8801247f9fd8
Oct 20 23:18:05 newcastle kernel: ffff8801247f9fd8 ffff880121d103c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116290d>] ? mntput+0x45/0x46
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gconf-helper  S ffff88013a59e800     0 
  2718   2697 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121da1a48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000055d06222 
ffff880121da19f8 ffff880121da1fd8
Oct 20 23:18:05 newcastle kernel: ffff880121da1fd8 ffff880128221b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115ff7b>] ? 
pipe_write+0x437/0x45d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155543>] ? 
do_sync_write+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: bluetooth-app S ffff880139be7b80     0 
  2720   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121e29a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 000000002e106244 
ffff880121e299f8 ffff880121e29fd8
Oct 20 23:18:05 newcastle kernel: ffff880121e29fd8 ffff880121d13280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: im-settings-d S ffff880121ee3e0c     0 
  2722      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121ee3a48 0000000000000086 
ffff880121ee39a8 00000000a4459e14
Oct 20 23:18:05 newcastle kernel: ffff8800282702f8 ffff880121ee3a58 
ffff880121ee39d8 ffff880121ee3fd8
Oct 20 23:18:05 newcastle kernel: ffff880121ee3fd8 ffff880121d16140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514d5e>] ? 
mutex_lock+0x38/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff812548a7>] ? 
inode_has_perm+0x7a/0x90
Oct 20 23:18:05 newcastle kernel: [<ffffffff81252251>] ? 
avc_has_perm+0x6b/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff812549cf>] ? 
file_has_perm+0xa4/0xc6
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109194f>] ? 
finish_wait+0x75/0x94
Oct 20 23:18:05 newcastle kernel: [<ffffffff811948f9>] ? 
inotify_read+0x27f/0x2ba
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: python        S ffff880139be23c0     0 
  2723   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121e05a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000d1fb5ead 
ffff880121e059f8 ffff880121e05fd8
Oct 20 23:18:05 newcastle kernel: ffff880121e05fd8 ffff880121f083c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-volume- S ffff880124411e14     0 
  2762   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880124411a48 0000000000000086 
ffff880124411a58 00000000055c8b1b
Oct 20 23:18:05 newcastle kernel: ffff88013ac24b00 00000000055c8b1b 
ffff8801244119b8 ffff880124411fd8
Oct 20 23:18:05 newcastle kernel: ffff880124411fd8 ffff88013238e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gpk-update-ic S ffff88013a59a080     0 
  2804   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120ea3a48 0000000000000086 
ffff880120ea39a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000246 
00000696fc6565a1 ffff880120ea3fd8
Oct 20 23:18:05 newcastle kernel: ffff880120ea3fd8 ffff880120e203c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: nm-applet     S ffff880120da5e3c     0 
  2807   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120da5a48 0000000000000082 
ffff880120da59a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282702f8 0000000000000246 
0000060b3e74da89 ffff880120da5fd8
Oct 20 23:18:05 newcastle kernel: ffff880120da5fd8 ffff880120e26140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-power-m S ffff88013a59a080     0 
  2843   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120fe5a48 0000000000000082 
ffff880120fe59a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000246 
0000060b0e0203e4 ffff880120fe5fd8
Oct 20 23:18:05 newcastle kernel: ffff880120fe5fd8 ffff880135546140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gdu-notificat S ffff880120c81e0c     0 
  2844   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120c81a48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000e4ab76a3 
ffff880120c819f8 ffff880120c81fd8
Oct 20 23:18:05 newcastle kernel: ffff880120c81fd8 ffff8801247f49e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gconf-im-sett S ffff880135603dc0     0 
  2846      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120f03a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 000000002fd6195e 
ffff880120f039f8 ffff880120f03fd8
Oct 20 23:18:05 newcastle kernel: ffff880120f03fd8 ffff880120f503c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: devkit-disks- S ffff88013a59b400     0 
  2853      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120e17a48 0000000000000082 
ffff880120e17a08 ffff880120e17a04
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
0000000000000dea ffff880120e17fd8
Oct 20 23:18:05 newcastle kernel: ffff880120e17fd8 ffff880120e249e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: notification- S ffff880134fd6800     0 
  2855      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011fd1fa48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000d4955d44 
ffff88011fd1f9f8 ffff88011fd1ffd8
Oct 20 23:18:05 newcastle kernel: ffff88011fd1ffd8 ffff8801247f3280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115516f>] ? 
fsnotify_access+0x6/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: kerneloops-ap S ffff880139be0340     0 
  2856   2622 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011fd19a48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 000000007cbcc650 
ffff88011fd199f8 ffff88011fd19fd8
Oct 20 23:18:05 newcastle kernel: ffff88011fd19fd8 ffff880120f53280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: devkit-disks- S ffff88002826fb38     0 
  2861   2853 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880120dafa48 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff880120daf9f8 0000000000000246 
0000060a4fdf69b2 ffff880120daffd8
Oct 20 23:18:05 newcastle kernel: ffff880120daffd8 ffff88011fd8b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff810d68f7>] ? 
rcu_start_gp+0x134/0x153
Oct 20 23:18:05 newcastle kernel: [<ffffffff8118c42c>] ? 
blkdev_open+0x0/0xd1
Oct 20 23:18:05 newcastle kernel: [<ffffffff810d73c2>] ? 
call_rcu_sched+0x28/0x3e
Oct 20 23:18:05 newcastle kernel: [<ffffffff810d73f9>] ? call_rcu+0x21/0x37
Oct 20 23:18:05 newcastle kernel: [<ffffffff81175aa8>] ? 
mntput_no_expire+0x3c/0x114
Oct 20 23:18:05 newcastle kernel: [<ffffffff8118c42c>] ? 
blkdev_open+0x0/0xd1
Oct 20 23:18:05 newcastle kernel: [<ffffffff811524c8>] ? 
__dentry_open+0x2c9/0x2f5
Oct 20 23:18:05 newcastle kernel: [<ffffffff811525f4>] ? 
nameidata_to_filp+0x51/0x76
Oct 20 23:18:05 newcastle kernel: [<ffffffff81165a7c>] ? 
do_filp_open+0x524/0x9ca
Oct 20 23:18:05 newcastle kernel: [<ffffffff812a2c62>] ? 
might_fault+0x34/0x4a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: kerneloops    S ffff88002822fb38     0 
  2866      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011fdd7a48 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282302f8 0000000000000246 
0000060c19e0227e ffff88011fdd7fd8
Oct 20 23:18:05 newcastle kernel: ffff88011fdd7fd8 ffff88011fd89b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8126040d>] ? 
avtab_search_node+0x1a/0xa7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81268410>] ? 
context_struct_compute_av+0x2c0/0x337
Oct 20 23:18:05 newcastle kernel: [<ffffffff8125185c>] ? 
avc_alloc_node+0x36/0x1ea
Oct 20 23:18:05 newcastle kernel: [<ffffffff81252067>] ? 
avc_has_perm_noaudit+0x239/0x3b8
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: wnck-applet   S ffff880135601a00     0 
  2878      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880121dfba48 0000000000000082 
00000000000004d0 0000000000000230
Oct 20 23:18:05 newcastle kernel: ffff880121dfb9f8 0000000000000000 
ffff880000016108 ffff880121dfbfd8
Oct 20 23:18:05 newcastle kernel: ffff880121dfbfd8 ffff880121f0e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: trashapplet   S ffff880135601a00     0 
  2882      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011ff37a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
ffff880000016108 ffff88011ff37fd8
Oct 20 23:18:05 newcastle kernel: ffff88011ff37fd8 ffff880120e23280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfsd-trash   S ffff88011dc73e34     0 
  2885      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011dc73a48 0000000000000086 
0000000000000000 000000003e6ad2d6
Oct 20 23:18:05 newcastle kernel: ffff8800282502f8 ffff88011dc73a58 
ffff88011dc739d8 ffff88011dc73fd8
Oct 20 23:18:05 newcastle kernel: ffff88011dc73fd8 ffff880120eb9b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514d5e>] ? 
mutex_lock+0x38/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109194f>] ? 
finish_wait+0x75/0x94
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-gdu-volu S ffff880139be2d80     0 
  2887      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011ff01a48 0000000000000082 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000ceb3d1ea 
ffff88011ff019f8 ffff88011ff01fd8
Oct 20 23:18:05 newcastle kernel: ffff88011ff01fd8 ffff880121d149e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfs-gphoto2- S ffff88011dd4be0c     0 
  2889      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011dd4ba48 0000000000000086 
ffffffff8106036d 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000000c0a8ce5c 
ffff88011dd4b9f8 ffff88011dd4bfd8
Oct 20 23:18:05 newcastle kernel: ffff88011dd4bfd8 ffff880120ebe140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfsd-burn    S ffff88002822fb38     0 
  2893      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011de51a48 0000000000000082 
0000000000000000 0000000074e28a02
Oct 20 23:18:05 newcastle kernel: ffff88011de519e8 ffffffff81060347 
000004001de519f8 ffff88011de51fd8
Oct 20 23:18:05 newcastle kernel: ffff88011de51fd8 ffff880121f0b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81102f26>] ? lock_page+0x38/0x66
Oct 20 23:18:05 newcastle kernel: [<ffffffff81103092>] ? 
wake_up_page+0x38/0x55
Oct 20 23:18:05 newcastle kernel: [<ffffffff8110313e>] ? 
unlock_page+0x27/0x3d
Oct 20 23:18:05 newcastle kernel: [<ffffffff811205a2>] ? 
__do_fault+0x3bc/0x409
Oct 20 23:18:05 newcastle kernel: [<ffffffff8112279b>] ? 
handle_mm_fault+0x36c/0x79d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8105dcc8>] ? 
finish_task_switch+0x94/0xcd
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81095d0b>] ? up_read+0x21/0x37
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gweather-appl S ffff880135601a00     0 
  2901      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011de89a48 0000000000000082 
ffff88011de899a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000005f5e100 0000000000000246 
000006998c2150c4 ffff88011de89fd8
Oct 20 23:18:05 newcastle kernel: ffff88011de89fd8 ffff8801355449e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gdm-user-swit S ffff88002826fb38     0 
  2904      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011deb7a48 0000000000000082 
0000000000000000 00000000826f87b9
Oct 20 23:18:05 newcastle kernel: ffff8800282502f8 0000000000000000 
ffff880000016108 ffff88011deb7fd8
Oct 20 23:18:05 newcastle kernel: ffff88011deb7fd8 ffff88011deb83c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514d5e>] ? 
mutex_lock+0x38/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: clock-applet  S ffff880135601a00     0 
  2910      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011df5ba48 0000000000000086 
ffff88011df5b9a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 000000000392cb7f 0000000000000246 
00000616a6ff205a ffff88011df5bfd8
Oct 20 23:18:05 newcastle kernel: ffff88011df5bfd8 ffff880120eb83c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: notification- S ffff880135601a00     0 
  2911      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011dfefa48 0000000000000082 
00000000000004d0 0000000000000330
Oct 20 23:18:05 newcastle kernel: ffff88011dfef9f8 0000000000000000 
ffff880000016108 ffff88011dfeffd8
Oct 20 23:18:05 newcastle kernel: ffff88011dfeffd8 ffff88011df33280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: sensors-apple S ffff88002822fb38     0 
  2913      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011b033a48 0000000000000082 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88011b0339e8 0000000000000246 
0000060a5b4c8d37 ffff88011b033fd8
Oct 20 23:18:05 newcastle kernel: ffff88011b033fd8 ffff88011deb9b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: multiload-app S ffff880135601a00     0 
  2916      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011b0dba48 0000000000000082 
ffff88011b0db9a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 0000000000079d37 0000000000000246 
00000609fdffa82b ffff88011b0dbfd8
Oct 20 23:18:05 newcastle kernel: ffff88011b0dbfd8 ffff88011df81b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: cpufreq-apple S ffff880135601a00     0 
  2917      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011b0dda48 0000000000000082 
ffff88011b0dd9a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: 00000000000f3a6f 0000000000000246 
0000060a1fb22d25 ffff88011b0ddfd8
Oct 20 23:18:05 newcastle kernel: ffff88011b0ddfd8 ffff88011df26140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-screens S ffff880139be5480     0 
  3222      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011869fa48 0000000000000082 
ffff88011869fa08 ffff88011869fa04
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
00000000000005f6 ffff88011869ffd8
Oct 20 23:18:05 newcastle kernel: ffff88011869ffd8 ffff88011debb280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: scsi_eh_12    S ffff880135600680     0 
  4857      2 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011a99de20 0000000000000046 
ffff88011a99dde0 ffff88011a99dddc
Oct 20 23:18:05 newcastle kernel: ffff88011a99dda0 0000000000000000 
00000000000009c5 ffff88011a99dfd8
Oct 20 23:18:05 newcastle kernel: ffff88011a99dfd8 ffff88011df203c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8137eb8c>] 
scsi_error_handler+0xaf/0x5b1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff8137eadd>] ? 
scsi_error_handler+0x0/0x5b1
Oct 20 23:18:05 newcastle kernel: [<ffffffff810912f9>] kthread+0x8e/0x96
Oct 20 23:18:05 newcastle kernel: [<ffffffff8101301a>] child_rip+0xa/0x20
Oct 20 23:18:05 newcastle kernel: [<ffffffff8101297d>] ? 
restore_args+0x0/0x30
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109126b>] ? kthread+0x0/0x96
Oct 20 23:18:05 newcastle kernel: [<ffffffff81013010>] ? child_rip+0x0/0x20
Oct 20 23:18:05 newcastle kernel: dbus-launch   S ffff880135601a00     0 
  4923      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011862f908 0000000000000082 
ffff88011df34620 000000003647ea32
Oct 20 23:18:05 newcastle kernel: ffff880128068000 000000003647ea32 
ffff88011862f868 ffff88011862ffd8
Oct 20 23:18:05 newcastle kernel: ffff88011862ffd8 ffff88011df349e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8151651d>] ? 
_spin_unlock_irqrestore+0x38/0x64
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106036d>] ? 
default_wake_function+0x0/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e810e>] ? scm_recv+0x4c/0xe0
Oct 20 23:18:05 newcastle kernel: [<ffffffff814548d7>] ? 
skb_dequeue+0x73/0x95
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e8fe9>] ? 
unix_stream_recvmsg+0x531/0x565
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-daemon   S ffff8801157ebe0c     0 
  4924      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801157eba48 0000000000000086 
0000000000000000 0000000070fd5546
Oct 20 23:18:05 newcastle kernel: ffff8800282502f8 ffff8801157eba58 
ffff8801157eb9d8 ffff8801157ebfd8
Oct 20 23:18:05 newcastle kernel: ffff8801157ebfd8 ffff88011df36140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116cd86>] ? __d_free+0x5f/0x7a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81175aa8>] ? 
mntput_no_expire+0x3c/0x114
Oct 20 23:18:05 newcastle kernel: [<ffffffff81156fa4>] ? __fput+0x1d4/0x1f7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: dbus-daemon   S ffff88002822fb38     0 
  4925      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801187e3a48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
0000000000000000 ffff8801187e3fd8
Oct 20 23:18:05 newcastle kernel: ffff8801187e3fd8 ffff88011df31b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff815144b9>] 
schedule_timeout+0x36/0xe3
Oct 20 23:18:05 newcastle kernel: [<ffffffff810919d9>] ? 
prepare_to_wait_exclusive+0x6b/0x8b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458a6c>] 
__skb_recv_datagram+0x1ed/0x276
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458b44>] ? 
receiver_wake_function+0x0/0x44
Oct 20 23:18:05 newcastle kernel: [<ffffffff81458b29>] 
skb_recv_datagram+0x34/0x4f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8147e84a>] 
netlink_recvmsg+0x69/0x317
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c9c0>] 
sock_recvmsg+0xde/0x10b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8112d124>] ? 
page_add_new_anon_rmap+0x52/0x78
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c2b4>] ? 
sockfd_lookup_light+0x33/0x81
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144e031>] 
sys_recvfrom+0xd7/0x141
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81095d0b>] ? up_read+0x21/0x37
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: wish          S ffff88002820fb38     0 
  4943      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8800bf1d9908 0000000000000082 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282102f8 0000000000000246 
00000609f5c62651 ffff8800bf1d9fd8
Oct 20 23:18:05 newcastle kernel: ffff8800bf1d9fd8 ffff88011df86140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b3b6>] do_select+0x51e/0x57f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] ? 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] ? 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b7af>] 
core_sys_select+0x1a7/0x25a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116badb>] sys_select+0xa8/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gvfsd-http    S ffff88002822fb38     0 
  5106      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880050431a48 0000000000000086 
ffff880050431a08 ffff880050431a04
Oct 20 23:18:05 newcastle kernel: ffff8800504319e8 0000000000000000 
0000000000000400 ffff880050431fd8
Oct 20 23:18:05 newcastle kernel: ffff880050431fd8 ffff8800504a49e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e795e>] ? 
sock_poll_wait+0x2e/0x47
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: umount        D 0000000000000002     0 
  5380   2853 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880118651bc8 0000000000000086 
ffff880118651b68 00000000d54e0b08
Oct 20 23:18:05 newcastle kernel: 00000000000004f1 ffff88013bbd9798 
ffff8800282558b0 ffff880118651fd8
Oct 20 23:18:05 newcastle kernel: ffff880118651fd8 ffff8800504cb280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117d555>] 
bdi_sched_wait+0x21/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff815147e0>] 
__wait_on_bit+0x57/0x9e
Oct 20 23:18:05 newcastle kernel: [<ffffffff815148a4>] 
out_of_line_wait_on_bit+0x7d/0x9c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117d534>] ? 
bdi_sched_wait+0x0/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff810917ca>] ? 
wake_bit_function+0x0/0x5a
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117e43e>] 
wait_on_bit.clone.1+0x2f/0x45
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117e4c7>] 
bdi_sync_writeback+0x73/0x8e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8117e517>] 
sync_inodes_sb+0x35/0x115
Oct 20 23:18:05 newcastle kernel: [<ffffffff81182a95>] 
__sync_filesystem+0x5f/0x9f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81182d01>] 
sync_filesystem+0x5a/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81158515>] 
generic_shutdown_super+0x3a/0xf2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81158607>] 
kill_block_super+0x3a/0x6a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81158eaf>] 
deactivate_super+0x68/0x95
Oct 20 23:18:05 newcastle kernel: [<ffffffff81175b32>] 
mntput_no_expire+0xc6/0x114
Oct 20 23:18:05 newcastle kernel: [<ffffffff811761af>] 
sys_umount+0x2e9/0x32e
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: run-mozilla.s S ffff880139be5b00     0 
  5449      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff880115ef3e58 0000000000000082 
ffff8800506aaec0 0000000000000000
Oct 20 23:18:05 newcastle kernel: ffff880115ef3ef8 ffff8800504c9760 
ffff880115ef3dc8 ffff880115ef3fd8
Oct 20 23:18:05 newcastle kernel: ffff880115ef3fd8 ffff8800504c9b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106af44>] do_wait+0x1bb/0x245
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106b07b>] sys_wait4+0xad/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810694ec>] ? 
child_wait_callback+0x0/0x7e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff88002822fb38     0 
  5464   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88011aa53a48 0000000000000086 
0000000000000000 ffff8800540f5620
Oct 20 23:18:05 newcastle kernel: ffff88012860b460 0000000092d34db5 
ffff8801335e62a0 ffff88011aa53fd8
Oct 20 23:18:05 newcastle kernel: ffff88011aa53fd8 ffff8800506ab280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  5465   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013a6b9a48 0000000000000086 
ffff88013a6b9a58 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000005f5e100 00000000fb6cba44 
ffff88013a6b99d8 ffff88013a6b9fd8
Oct 20 23:18:05 newcastle kernel: ffff88013a6b9fd8 ffff8800506a83c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81143f30>] ? 
__slab_free+0x91/0x260
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] ? 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2fce>] ? 
futex_wait+0x279/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a32ed>] ? 
futex_wake+0xe6/0x10c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e3b>] ? do_futex+0xe1/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be16c0     0 
  5466   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013a26fc28 0000000000000086 
ffff88013a26fb88 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88013a26fc78 0000000000000246 
0000060a0163eacf ffff88013a26ffd8
Oct 20 23:18:05 newcastle kernel: ffff88013a26ffd8 ffff8800506ae140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  5467   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013a2b5c28 0000000000000086 
ffff88013a2b5b88 0000000000000246
Oct 20 23:18:05 newcastle kernel: 00000000472f2264 0000000000000246 
00000609f7a512df ffff88013a2b5fd8
Oct 20 23:18:05 newcastle kernel: ffff88013a2b5fd8 ffff8800506a9b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880120f55d80     0 
  5472   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801186c1c28 0000000000000086 
ffff8801186c1bb8 ffffffff81060347
Oct 20 23:18:05 newcastle kernel: 0000000000000000 00000001335e62a0 
0000000000000046 ffff8801186c1fd8
Oct 20 23:18:05 newcastle kernel: ffff8801186c1fd8 ffff880120f56140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  5476   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013834dc28 0000000000000086 
ffff88013834dbb8 ffffffff81060347
Oct 20 23:18:05 newcastle kernel: ffff8800bf3d9f80 0000000120f51760 
0000000000000046 ffff88013834dfd8
Oct 20 23:18:05 newcastle kernel: ffff88013834dfd8 ffff880120f51b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  5477   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8801399d9c28 0000000000000086 
ffff8801399d9b78 00000000d7255d50
Oct 20 23:18:05 newcastle kernel: ffffea0004160b68 00000000d7255d50 
ffff8801399d9cc8 ffff8801399d9fd8
Oct 20 23:18:05 newcastle kernel: ffff8801399d9fd8 ffff88013a1283c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114cac5>] ? 
__mem_cgroup_try_charge+0x5c/0x1e8
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8112d124>] ? 
page_add_new_anon_rmap+0x52/0x78
Oct 20 23:18:05 newcastle kernel: [<ffffffff8129ea38>] ? __up_read+0x89/0xaa
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  5478   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88013a539c28 0000000000000086 
ffff88013a539bb8 0000000000100000
Oct 20 23:18:05 newcastle kernel: 000000000000050f 00000000a8099bf1 
0000000000000007 ffff88013a539fd8
Oct 20 23:18:05 newcastle kernel: ffff88013a539fd8 ffff880121d11b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff8119dc00>] ? 
locks_free_lock+0x5e/0x79
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8119ee49>] ? 
fcntl_setlk+0x2b3/0x2df
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff88002822fb38     0 
  7181   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f11fc28 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88006f11fb88 0000000000000246 
0000064d1c28cea9 ffff88006f11ffd8
Oct 20 23:18:05 newcastle kernel: ffff88006f11ffd8 ffff88005ad249e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116cde7>] ? d_free+0x46/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff81175aa8>] ? 
mntput_no_expire+0x3c/0x114
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff880139be5b00     0 
  7182   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f16dc28 0000000000000086 
ffff88006f16db88 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88006f16db88 0000000000000246 
0000064d23325a1d ffff88006f16dfd8
Oct 20 23:18:05 newcastle kernel: ffff88006f16dfd8 ffff880128226140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff88002822fb38     0 
  7183   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f1bbc28 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88006f1bbb98 0000000000000246 
00000648ab6833b5 ffff88006f1bbfd8
Oct 20 23:18:05 newcastle kernel: ffff88006f1bbfd8 ffff88011debe140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116cde7>] ? d_free+0x46/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff81175aa8>] ? 
mntput_no_expire+0x3c/0x114
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: firefox       S ffff88006f29aec0     0 
  7188   5449 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f119c28 0000000000000086 
ffff88006f119b88 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88006f119fd8 0000000000000246 
000006160a48d926 ffff88006f119fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f119fd8 ffff88006f29b280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: aplay         ? ffff880139be6b40     0 
  6494   4943 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff8800bf10fea8 0000000000000046 
0000000000000000 ffff88011fd8dd80
Oct 20 23:18:05 newcastle kernel: ffff8800bf10fea8 ffffffff810ff5f7 
ffff8800bf10fe38 ffff8800bf10ffd8
Oct 20 23:18:05 newcastle kernel: ffff8800bf10ffd8 ffff88011fd8e140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810ff5f7>] ? 
perf_event_exit_task+0x3e/0x323
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106b914>] do_exit+0x687/0x696
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106b9ae>] 
do_group_exit+0x8b/0xb4
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106ba01>] 
sys_exit_group+0x2a/0x42
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002824fb38     0 
  6497      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cce3a48 0000000000000086 
ffff88003cce3a08 ffff88003cce3a04
Oct 20 23:18:05 newcastle kernel: 000000000002fd9f 0000000000000000 
0000000000000400 ffff88003cce3fd8
Oct 20 23:18:05 newcastle kernel: ffff88003cce3fd8 ffff8801185eb280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff880139be4100     0 
  6503      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005acbfc28 0000000000000086 
ffff88005acbfbb8 ffffffff81060347
Oct 20 23:18:05 newcastle kernel: ffff88005acbfc98 00000001814e8fe9 
0000000000000046 ffff88005acbffd8
Oct 20 23:18:05 newcastle kernel: ffff88005acbffd8 ffff8801247f03c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81060347>] ? 
try_to_wake_up+0x272/0x298
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002822fb38     0 
  6505      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ac2fe58 0000000000000086 
0000000000000000 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff8800282302f8 0000000000000246 
00000609f8a30bd9 ffff88005ac2ffd8
Oct 20 23:18:05 newcastle kernel: ffff88005ac2ffd8 ffff8801185ec9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514f86>] 
do_nanosleep+0x7b/0xd3
Oct 20 23:18:05 newcastle kernel: [<ffffffff81095ab6>] 
hrtimer_nanosleep+0xbf/0x140
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81095b9f>] 
sys_nanosleep+0x68/0x8e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002822fb38     0 
  6507      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f005a48 0000000000000086 
ffff88006f005a08 ffff88006f005a04
Oct 20 23:18:05 newcastle kernel: ffffea0003dcec68 0000000000000000 
0000000000001946 ffff88006f005fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f005fd8 ffff8801185e83c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002826fb38     0 
  6508      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ad91c28 0000000000000086 
ffff88005ad91be8 ffff88005ad91be4
Oct 20 23:18:05 newcastle kernel: 0000000000000088 0000000000000000 
0000000000000400 ffff88005ad91fd8
Oct 20 23:18:05 newcastle kernel: ffff88005ad91fd8 ffff88011df803c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a31ec>] ? 
wake_futex+0x51/0x6c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a32ed>] ? 
futex_wake+0xe6/0x10c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff8105dc93>] ? 
finish_task_switch+0x5f/0xcd
Oct 20 23:18:05 newcastle kernel: [<ffffffff81513f5c>] ? 
thread_return+0x74/0xeb
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002822fb38     0 
  6518      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f2b5a48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
0000000000000000 ffff88006f2b5fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f2b5fd8 ffff8800506ac9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002820fb38     0 
  6760      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ae1ba48 0000000000000086 
0000000000000000 00000000e93d823a
Oct 20 23:18:05 newcastle kernel: ffffea0003df1ae0 ffff88006d227680 
ffff88005ae1b9c8 ffff88005ae1bfd8
Oct 20 23:18:05 newcastle kernel: ffff88005ae1bfd8 ffff880121f09b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  6761      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ac89c28 0000000000000086 
ffff88005ac89b88 ffff88003cd2a810
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000001 
ffff88005ac89b98 ffff88005ac89fd8
Oct 20 23:18:05 newcastle kernel: ffff88005ac89fd8 ffff8800504a03c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2d22>] 
futex_wait_queue_me+0xbd/0xf0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a2e88>] 
futex_wait+0x133/0x2b2
Oct 20 23:18:05 newcastle kernel: [<ffffffff8151565a>] ? 
rt_mutex_slowunlock+0x18d/0x1b0
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a4e14>] do_futex+0xba/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115527e>] ? 
fsnotify_modify+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a56ee>] sys_futex+0x136/0x164
Oct 20 23:18:05 newcastle kernel: [<ffffffff810cda94>] ? 
audit_syscall_entry+0x12d/0x16d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002820fb38     0 
  6763      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cc93a48 0000000000000086 
ffff88003cc93a08 ffff88003cc93a04
Oct 20 23:18:05 newcastle kernel: ffffea0003df1ae0 0000000000000000 
0000000000001946 ffff88003cc93fd8
Oct 20 23:18:05 newcastle kernel: ffff88003cc93fd8 ffff880139abc9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  6765      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ac7ba48 0000000000000086 
ffff8801185eaef8 ffff8800282358b0
Oct 20 23:18:05 newcastle kernel: ffff88005ac7b9b8 0000000074b6e1c3 
ffff88005ac7b9b8 ffff88005ac7bfd8
Oct 20 23:18:05 newcastle kernel: ffff88005ac7bfd8 ffff880121f0c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  6766      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f2f3a48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
ffff88006f2f39b8 ffff88006f2f3fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f2f3fd8 ffff880139ab83c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     R  running task        0 
  6767      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ae19f70 0000000000000086 
ffffffff811551e4 0000000000000014
Oct 20 23:18:05 newcastle kernel: 00000000ae6149dc ffff880121ec76a8 
00000000ae6149dc ffff88005ae19fd8
Oct 20 23:18:05 newcastle kernel: ffff88005ae19fd8 ffff880120e21b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81515d2d>] ? 
trace_hardirqs_on_thunk+0x3a/0x3c
Oct 20 23:18:05 newcastle kernel: [<ffffffff810129db>] 
retint_careful+0x19/0x3c
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  6769      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f255a48 0000000000000086 
ffff8801185eaef8 ffff8800282558b0
Oct 20 23:18:05 newcastle kernel: ffff88006f2559b8 00000000c5ce40c2 
ffff88006f2559b8 ffff88006f255fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f255fd8 ffff8800504ce140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  7115      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005acc7a48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
ffff88005acc79b8 ffff88005acc7fd8
Oct 20 23:18:05 newcastle kernel: ffff88005acc7fd8 ffff88005ae249e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  7118      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f241a48 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: 0000000000000000 0000000000000000 
ffff88006f2419b8 ffff88006f241fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f241fd8 ffff88005ad26140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002820fb38     0 
  7120      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ac7da48 0000000000000086 
0000000000000000 000000006474332f
Oct 20 23:18:05 newcastle kernel: ffffea0003d5a6a0 ffff880056acbe00 
ffff88005ac7d9c8 ffff88005ac7dfd8
Oct 20 23:18:05 newcastle kernel: ffff88005ac7dfd8 ffff88005ae26140 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff880139be5140     0 
  7122      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005ac57a48 0000000000000086 
ffff88005ac579b8 000000006ca908b0
Oct 20 23:18:05 newcastle kernel: 0000000000000008 ffff88004aad4c00 
ffff88005ac579c8 ffff88005ac57fd8
Oct 20 23:18:05 newcastle kernel: ffff88005ac57fd8 ffff88011debc9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fca9>] ? 
touch_atime+0x96/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] ? 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002820fb38     0 
  7124      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f273a48 0000000000000086 
0000000000000000 ffffffff8105e827
Oct 20 23:18:05 newcastle kernel: ffff880028215840 0000000000000008 
000000000000002a ffff88006f273fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f273fd8 ffff88005ae23280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8105e827>] ? 
load_balance_fair+0x1b5/0x261
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002822fb38     0 
  7126      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cc71a48 0000000000000086 
0000000000000000 ffff8800282558b0
Oct 20 23:18:05 newcastle kernel: ffff88003cc719b8 00000000d8a1dccd 
ffff88003cc719d8 ffff88003cc71fd8
Oct 20 23:18:05 newcastle kernel: ffff88003cc71fd8 ffff88005ae203c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff8801399230c0     0 
  7128      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cc37a48 0000000000000086 
ffff8801185eaef8 ffff8800282558b0
Oct 20 23:18:05 newcastle kernel: ffff88003cc379b8 00000000a10ed1b1 
ffff88003cc379b8 ffff88003cc37fd8
Oct 20 23:18:05 newcastle kernel: ffff88003cc37fd8 ffff88006f2983c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514dea>] 
schedule_hrtimeout_range+0x51/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091b40>] ? 
add_wait_queue+0x4e/0x6d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b4ed>] ? 
__pollwait+0xd6/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106da98>] ? 
current_fs_time+0x3e/0x69
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116fd31>] ? 
touch_atime+0x11e/0x14d
Oct 20 23:18:05 newcastle kernel: [<ffffffff81160361>] ? 
pipe_read+0x3c0/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a33aa>] ? 
task_pid_vnr+0x25/0x3b
Oct 20 23:18:05 newcastle kernel: [<ffffffff810a54be>] ? 
do_futex+0x764/0x85e
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811551e4>] ? 
fsnotify_access+0x7b/0x9a
Oct 20 23:18:05 newcastle kernel: [<ffffffff81162ab0>] ? path_put+0x31/0x4c
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: rhythmbox     S ffff88002820fb38     0 
  7130      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f037a48 0000000000000086 
ffff88006f037a08 ffff88006f037a04
Oct 20 23:18:05 newcastle kernel: ffff88006f0379e8 0000000000000000 
0000000000000400 ffff88006f037fd8
Oct 20 23:18:05 newcastle kernel: ffff88006f037fd8 ffff88005ae21b20 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c186>] ? 
__sock_sendmsg+0x70/0x8f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144cb37>] ? 
sock_sendmsg+0xdb/0x108
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81457abe>] ? 
verify_iovec+0x60/0xb6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81054be8>] ? 
__dequeue_entity+0x46/0x62
Oct 20 23:18:05 newcastle kernel: [<ffffffff8104df39>] ? 
__spin_unlock_irq+0x23/0x40
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-termina R  running task        0 
  6954      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cc09a48 0000000000000082 
ffff88003cc099a8 0000000000000246
Oct 20 23:18:05 newcastle kernel: ffff88003cc099e8 0000000000000246 
00000609f794fa72 ffff88003cc09fd8
Oct 20 23:18:05 newcastle kernel: ffff88003cc09fd8 ffff88011df83280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81514e89>] 
schedule_hrtimeout_range+0xf0/0x137
Oct 20 23:18:05 newcastle kernel: [<ffffffff81094b61>] ? 
hrtimer_wakeup+0x0/0x4d
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad82>] 
poll_schedule_timeout+0x47/0x77
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116be8a>] 
do_sys_poll+0x373/0x412
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b417>] ? __pollwait+0x0/0xf5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116b50c>] ? pollwake+0x0/0x75
Oct 20 23:18:05 newcastle kernel: [<ffffffff81019529>] ? read_tsc+0x9/0x1b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109b0bb>] ? 
timekeeping_get_ns+0x2a/0x63
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116ad04>] ? 
poll_select_set_timeout+0x75/0xac
Oct 20 23:18:05 newcastle kernel: [<ffffffff8116c0fb>] sys_poll+0x66/0xe6
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-termina S ffff88002826fb38     0 
  6957      1 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cccbc68 0000000000000082 
ffff88003cccbc28 ffff88003cccbc24
Oct 20 23:18:05 newcastle kernel: ffff88003ccca000 0000000000000000 
0000000000000402 ffff88003cccbfd8
Oct 20 23:18:05 newcastle kernel: ffff88003cccbfd8 ffff88011fd8c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115fb14>] pipe_wait+0x70/0xa0
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff811602f9>] pipe_read+0x358/0x3e9
Oct 20 23:18:05 newcastle kernel: [<ffffffff812548a7>] ? 
inode_has_perm+0x7a/0x90
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114b7c8>] ? 
try_get_mem_cgroup_from_mm+0x4c/0x73
Oct 20 23:18:05 newcastle kernel: [<ffffffff8114cac5>] ? 
__mem_cgroup_try_charge+0x5c/0x1e8
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e34>] vfs_read+0xba/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: gnome-pty-hel S ffff880139be4ac0     0 
  6955   6954 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003ccc9ae8 0000000000000082 
0000000000000000 ffff88005ad20000
Oct 20 23:18:05 newcastle kernel: ffff88003ccc9a88 ffffffff81221222 
ffff880056afd620 ffff88003ccc9fd8
Oct 20 23:18:05 newcastle kernel: ffff88003ccc9fd8 ffff88005ad203c0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81221222>] ? 
jbd2_journal_stop+0x2e7/0x30d
Oct 20 23:18:05 newcastle kernel: [<ffffffff815144b9>] 
schedule_timeout+0x36/0xe3
Oct 20 23:18:05 newcastle kernel: [<ffffffff81091ad1>] ? 
prepare_to_wait+0x6b/0x8c
Oct 20 23:18:05 newcastle kernel: [<ffffffff814e8da3>] 
unix_stream_recvmsg+0x2eb/0x565
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144c225>] 
__sock_recvmsg+0x80/0xa1
Oct 20 23:18:05 newcastle kernel: [<ffffffff8144eb4b>] 
sock_aio_read+0xd6/0xff
Oct 20 23:18:05 newcastle kernel: [<ffffffff8115568e>] 
do_sync_read+0xfa/0x14b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8109176b>] ? 
autoremove_wake_function+0x0/0x5f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81257598>] ? 
selinux_file_permission+0xb6/0xd7
Oct 20 23:18:05 newcastle kernel: [<ffffffff81249594>] ? 
security_file_permission+0x29/0x3f
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155e47>] vfs_read+0xcd/0x12b
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155f97>] sys_read+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: bash          S ffff880139923dc0     0 
  6956   6954 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88003cccde58 0000000000000086 
ffff88006f29c620 0000000000000000
Oct 20 23:18:05 newcastle kernel: ffff88003cccdef8 ffff88005ad22ec0 
ffff88003cccddc8 ffff88003cccdfd8
Oct 20 23:18:05 newcastle kernel: ffff88003cccdfd8 ffff88005ad23280 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106af44>] do_wait+0x1bb/0x245
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106b07b>] sys_wait4+0xad/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810694ec>] ? 
child_wait_callback+0x0/0x7e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: su            S ffff88002820fb38     0 
  7143   6956 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88006f01be58 0000000000000086 
0000000000000000 0000000000000000
Oct 20 23:18:05 newcastle kernel: ffff88006f01bef8 ffff88006f29c620 
ffff88006f01bdc8 ffff88006f01bfd8
Oct 20 23:18:05 newcastle kernel: ffff88006f01bfd8 ffff88006f29c9e0 
000000000000fb38 0000000000015840
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106af44>] do_wait+0x1bb/0x245
Oct 20 23:18:05 newcastle kernel: [<ffffffff8106b07b>] sys_wait4+0xad/0xe4
Oct 20 23:18:05 newcastle kernel: [<ffffffff810694ec>] ? 
child_wait_callback+0x0/0x7e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: bash          R  running task        0 
  7150   7143 0x00000080
Oct 20 23:18:05 newcastle kernel: ffff88005aeb1c28 0000000000000046 
ffffffff81765580 00000000d29a0c50
Oct 20 23:18:05 newcastle kernel: 00000000fffe0000 00000000d29a0c50 
ffff88005aeb1c68 ffffffff810671d1
Oct 20 23:18:05 newcastle kernel: ffffffff81a099b1 00000000d29a0c50 
ffffffff81a099b1 ffff8801247f5d80
Oct 20 23:18:05 newcastle kernel: Call Trace:
Oct 20 23:18:05 newcastle kernel: [<ffffffff81016266>] 
show_trace_log_lvl+0x61/0x7e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81015187>] 
show_stack_log_lvl+0x11f/0x142
Oct 20 23:18:05 newcastle kernel: [<ffffffff810161ef>] show_stack+0x2f/0x45
Oct 20 23:18:05 newcastle kernel: [<ffffffff8105c509>] 
sched_show_task+0xc4/0xdf
Oct 20 23:18:05 newcastle kernel: [<ffffffff8105c587>] 
show_state_filter+0x63/0xc5
Oct 20 23:18:05 newcastle kernel: [<ffffffff8134b508>] 
sysrq_handle_showstate+0x23/0x39
Oct 20 23:18:05 newcastle kernel: [<ffffffff8134b2ec>] 
__handle_sysrq+0xc6/0x17b
Oct 20 23:18:05 newcastle kernel: [<ffffffff8134b406>] 
write_sysrq_trigger+0x65/0x83
Oct 20 23:18:05 newcastle kernel: [<ffffffff811b72f5>] 
proc_reg_write+0x82/0xaf
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155bdf>] vfs_write+0xbd/0x12e
Oct 20 23:18:05 newcastle kernel: [<ffffffff81155d42>] sys_write+0x59/0x91
Oct 20 23:18:05 newcastle kernel: [<ffffffff81011f82>] 
system_call_fastpath+0x16/0x1b
Oct 20 23:18:05 newcastle kernel: Sched Debug Version: v0.09, 2.6.32-rc4 #16
Oct 20 23:18:05 newcastle kernel: now at 6639850.598014 msecs
Oct 20 23:18:05 newcastle kernel:  .jiffies 
     : 4301307146
Oct 20 23:18:05 newcastle kernel:  .sysctl_sched_latency 
     : 15.000000
Oct 20 23:18:05 newcastle kernel:  .sysctl_sched_min_granularity 
     : 3.000000
Oct 20 23:18:05 newcastle kernel:  .sysctl_sched_wakeup_granularity 
     : 3.000000
Oct 20 23:18:05 newcastle kernel:  .sysctl_sched_child_runs_first 
     : 0.000000
Oct 20 23:18:05 newcastle kernel:  .sysctl_sched_features 
     : 15834235
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cpu#0, 2674.952 MHz
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 0
Oct 20 23:18:05 newcastle kernel:  .load                          : 0
Oct 20 23:18:05 newcastle kernel:  .nr_switches                   : 6944299
Oct 20 23:18:05 newcastle kernel:  .nr_load_updates               : 1787192
Oct 20 23:18:05 newcastle kernel:  .nr_uninterruptible            : 50
Oct 20 23:18:05 newcastle kernel:  .next_balance                  : 
4301.307145
Oct 20 23:18:05 newcastle kernel:  .curr->pid                     : 0
Oct 20 23:18:05 newcastle kernel:  .clock                         : 
6625880.119782
Oct 20 23:18:05 newcastle kernel:  .cpu_load[0]                   : 13964
Oct 20 23:18:05 newcastle kernel:  .cpu_load[1]                   : 7718
Oct 20 23:18:05 newcastle kernel:  .cpu_load[2]                   : 4210
Oct 20 23:18:05 newcastle kernel:  .cpu_load[3]                   : 2267
Oct 20 23:18:05 newcastle kernel:  .cpu_load[4]                   : 1359
Oct 20 23:18:05 newcastle kernel:  .yld_count                     : 94443
Oct 20 23:18:05 newcastle kernel:  .sched_switch                  : 0
Oct 20 23:18:05 newcastle kernel:  .sched_count                   : 7311694
Oct 20 23:18:05 newcastle kernel:  .sched_goidle                  : 1775460
Oct 20 23:18:05 newcastle kernel:  .ttwu_count                    : 4279560
Oct 20 23:18:05 newcastle kernel:  .ttwu_local                    : 3942568
Oct 20 23:18:05 newcastle kernel:  .bkl_count                     : 8111
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cfs_rq[0]:/
Oct 20 23:18:05 newcastle kernel:  .exec_clock                    : 
635108.037014
Oct 20 23:18:05 newcastle kernel:  .MIN_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .min_vruntime                  : 
355723.241450
Oct 20 23:18:05 newcastle kernel:  .max_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .spread                        : 0.000000
Oct 20 23:18:05 newcastle kernel:  .spread0                       : 0.000000
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 0
Oct 20 23:18:05 newcastle kernel:  .load                          : 0
Oct 20 23:18:05 newcastle kernel:  .nr_spread_over                : 8
Oct 20 23:18:05 newcastle kernel:  .shares                        : 0
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: rt_rq[0]:/
Oct 20 23:18:05 newcastle kernel:  .rt_nr_running                 : 0
Oct 20 23:18:05 newcastle kernel:  .rt_throttled                  : 0
Oct 20 23:18:05 newcastle kernel:  .rt_time                       : 6.964158
Oct 20 23:18:05 newcastle kernel:  .rt_runtime                    : 
950.000000
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: runnable tasks:
Oct 20 23:18:05 newcastle kernel:            task   PID         tree-key 
  switches  prio     exec-runtime         sum-exec        sum-sleep
Oct 20 23:18:05 newcastle kernel: 
----------------------------------------------------------------------------------------------------------
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cpu#1, 2674.952 MHz
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 2
Oct 20 23:18:05 newcastle kernel:  .load                          : 2048
Oct 20 23:18:05 newcastle kernel:  .nr_switches                   : 7028472
Oct 20 23:18:05 newcastle kernel:  .nr_load_updates               : 1353305
Oct 20 23:18:05 newcastle kernel:  .nr_uninterruptible            : -17
Oct 20 23:18:05 newcastle kernel:  .next_balance                  : 
4301.307395
Oct 20 23:18:05 newcastle kernel:  .curr->pid                     : 2419
Oct 20 23:18:05 newcastle kernel:  .clock                         : 
6625880.975623
Oct 20 23:18:05 newcastle kernel:  .cpu_load[0]                   : 2048
Oct 20 23:18:05 newcastle kernel:  .cpu_load[1]                   : 1856
Oct 20 23:18:05 newcastle kernel:  .cpu_load[2]                   : 1306
Oct 20 23:18:05 newcastle kernel:  .cpu_load[3]                   : 889
Oct 20 23:18:05 newcastle kernel:  .cpu_load[4]                   : 686
Oct 20 23:18:05 newcastle kernel:  .yld_count                     : 12754
Oct 20 23:18:05 newcastle kernel:  .sched_switch                  : 0
Oct 20 23:18:05 newcastle kernel:  .sched_count                   : 7214639
Oct 20 23:18:05 newcastle kernel:  .sched_goidle                  : 1408574
Oct 20 23:18:05 newcastle kernel:  .ttwu_count                    : 4327723
Oct 20 23:18:05 newcastle kernel:  .ttwu_local                    : 4013165
Oct 20 23:18:05 newcastle kernel:  .bkl_count                     : 10579
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cfs_rq[1]:/
Oct 20 23:18:05 newcastle kernel:  .exec_clock                    : 
652292.754947
Oct 20 23:18:05 newcastle kernel:  .MIN_vruntime                  : 
378141.540807
Oct 20 23:18:05 newcastle kernel:  .min_vruntime                  : 
378146.672931
Oct 20 23:18:05 newcastle kernel:  .max_vruntime                  : 
378141.540807
Oct 20 23:18:05 newcastle kernel:  .spread                        : 0.000000
Oct 20 23:18:05 newcastle kernel:  .spread0                       : 
22423.431481
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 2
Oct 20 23:18:05 newcastle kernel:  .load                          : 2048
Oct 20 23:18:05 newcastle kernel:  .nr_spread_over                : 0
Oct 20 23:18:05 newcastle kernel:  .shares                        : 0
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: rt_rq[1]:/
Oct 20 23:18:05 newcastle kernel:  .rt_nr_running                 : 0
Oct 20 23:18:05 newcastle kernel:  .rt_throttled                  : 0
Oct 20 23:18:05 newcastle kernel:  .rt_time                       : 0.000000
Oct 20 23:18:05 newcastle kernel:  .rt_runtime                    : 
950.000000
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: runnable tasks:
Oct 20 23:18:05 newcastle kernel:            task   PID         tree-key 
  switches  prio     exec-runtime         sum-exec        sum-sleep
Oct 20 23:18:05 newcastle kernel: 
----------------------------------------------------------------------------------------------------------
Oct 20 23:18:05 newcastle kernel: R           Xorg  2419 
378144.865500   1416269   140    378144.865500    140417.243173 
6412036.291651 /
Oct 20 23:18:05 newcastle kernel:  gnome-terminal  6954    378141.540807 
      4651   140    378141.540807       868.510346    474864.922139 /
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cpu#2, 2674.952 MHz
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 1
Oct 20 23:18:05 newcastle kernel:  .load                          : 1024
Oct 20 23:18:05 newcastle kernel:  .nr_switches                   : 4306471
Oct 20 23:18:05 newcastle kernel:  .nr_load_updates               : 1122079
Oct 20 23:18:05 newcastle kernel:  .nr_uninterruptible            : -16
Oct 20 23:18:05 newcastle kernel:  .next_balance                  : 
4301.307320
Oct 20 23:18:05 newcastle kernel:  .curr->pid                     : 7150
Oct 20 23:18:05 newcastle kernel:  .clock                         : 
6625855.187511
Oct 20 23:18:05 newcastle kernel:  .cpu_load[0]                   : 2048
Oct 20 23:18:05 newcastle kernel:  .cpu_load[1]                   : 1277
Oct 20 23:18:05 newcastle kernel:  .cpu_load[2]                   : 1037
Oct 20 23:18:05 newcastle kernel:  .cpu_load[3]                   : 863
Oct 20 23:18:05 newcastle kernel:  .cpu_load[4]                   : 683
Oct 20 23:18:05 newcastle kernel:  .yld_count                     : 17438
Oct 20 23:18:05 newcastle kernel:  .sched_switch                  : 0
Oct 20 23:18:05 newcastle kernel:  .sched_count                   : 4424177
Oct 20 23:18:05 newcastle kernel:  .sched_goidle                  : 1023807
Oct 20 23:18:05 newcastle kernel:  .ttwu_count                    : 2660929
Oct 20 23:18:05 newcastle kernel:  .ttwu_local                    : 2422226
Oct 20 23:18:05 newcastle kernel:  .bkl_count                     : 31702
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cfs_rq[2]:/
Oct 20 23:18:05 newcastle kernel:  .exec_clock                    : 
681824.314173
Oct 20 23:18:05 newcastle kernel:  .MIN_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .min_vruntime                  : 
410752.763730
Oct 20 23:18:05 newcastle kernel:  .max_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .spread                        : 0.000000
Oct 20 23:18:05 newcastle kernel:  .spread0                       : 
55029.522280
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 1
Oct 20 23:18:05 newcastle kernel:  .load                          : 1024
Oct 20 23:18:05 newcastle kernel:  .nr_spread_over                : 7
Oct 20 23:18:05 newcastle kernel:  .shares                        : 0
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: rt_rq[2]:/
Oct 20 23:18:05 newcastle kernel:  .rt_nr_running                 : 0
Oct 20 23:18:05 newcastle kernel:  .rt_throttled                  : 0
Oct 20 23:18:05 newcastle kernel:  .rt_time                       : 0.000000
Oct 20 23:18:05 newcastle kernel:  .rt_runtime                    : 
950.000000
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: runnable tasks:
Oct 20 23:18:05 newcastle kernel:            task   PID         tree-key 
  switches  prio     exec-runtime         sum-exec        sum-sleep
Oct 20 23:18:05 newcastle kernel: 
----------------------------------------------------------------------------------------------------------
Oct 20 23:18:05 newcastle kernel: R           bash  7150 
410747.220073       264   140    410747.220073        72.347694 
93931.016870 /
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cpu#3, 2674.952 MHz
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 0
Oct 20 23:18:05 newcastle kernel:  .load                          : 0
Oct 20 23:18:05 newcastle kernel:  .nr_switches                   : 3197366
Oct 20 23:18:05 newcastle kernel:  .nr_load_updates               : 736230
Oct 20 23:18:05 newcastle kernel:  .nr_uninterruptible            : -16
Oct 20 23:18:05 newcastle kernel:  .next_balance                  : 
4301.307149
Oct 20 23:18:05 newcastle kernel:  .curr->pid                     : 0
Oct 20 23:18:05 newcastle kernel:  .clock                         : 
6625881.095913
Oct 20 23:18:05 newcastle kernel:  .cpu_load[0]                   : 0
Oct 20 23:18:05 newcastle kernel:  .cpu_load[1]                   : 128
Oct 20 23:18:05 newcastle kernel:  .cpu_load[2]                   : 146
Oct 20 23:18:05 newcastle kernel:  .cpu_load[3]                   : 161
Oct 20 23:18:05 newcastle kernel:  .cpu_load[4]                   : 310
Oct 20 23:18:05 newcastle kernel:  .yld_count                     : 37786
Oct 20 23:18:05 newcastle kernel:  .sched_switch                  : 0
Oct 20 23:18:05 newcastle kernel:  .sched_count                   : 3300967
Oct 20 23:18:05 newcastle kernel:  .sched_goidle                  : 768059
Oct 20 23:18:05 newcastle kernel:  .ttwu_count                    : 2012999
Oct 20 23:18:05 newcastle kernel:  .ttwu_local                    : 1788787
Oct 20 23:18:05 newcastle kernel:  .bkl_count                     : 30092
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: cfs_rq[3]:/
Oct 20 23:18:05 newcastle kernel:  .exec_clock                    : 
451533.980670
Oct 20 23:18:05 newcastle kernel:  .MIN_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .min_vruntime                  : 
287621.174806
Oct 20 23:18:05 newcastle kernel:  .max_vruntime                  : 0.000001
Oct 20 23:18:05 newcastle kernel:  .spread                        : 0.000000
Oct 20 23:18:05 newcastle kernel:  .spread0                       : 
-68102.066644
Oct 20 23:18:05 newcastle kernel:  .nr_running                    : 0
Oct 20 23:18:05 newcastle kernel:  .load                          : 0
Oct 20 23:18:05 newcastle kernel:  .nr_spread_over                : 3
Oct 20 23:18:05 newcastle kernel:  .shares                        : 0
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: rt_rq[3]:/
Oct 20 23:18:05 newcastle kernel:  .rt_nr_running                 : 0
Oct 20 23:18:05 newcastle kernel:  .rt_throttled                  : 0
Oct 20 23:18:05 newcastle kernel:  .rt_time                       : 0.000000
Oct 20 23:18:05 newcastle kernel:  .rt_runtime                    : 
950.000000
Oct 20 23:18:05 newcastle kernel:
Oct 20 23:18:05 newcastle kernel: runnable tasks:
Oct 20 23:18:05 newcastle kernel:            task   PID         tree-key 
  switches  prio     exec-runtime         sum-exec        sum-sleep
Oct 20 23:18:05 newcastle kernel: 
----------------------------------------------------------------------------------------------------------
Oct 20 23:18:05 newcastle kernel:

