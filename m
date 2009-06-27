Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZF0WuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZF0WuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 18:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZF0Wtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 18:49:52 -0400
Received: from smtp-4.concepts.nl ([213.197.30.111]:54491 "EHLO
	smtp-4.concepts.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZF0Wtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 18:49:51 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jun 2009 18:49:51 EDT
Message-ID: <4A469C4A.5050309@hotmail.com>
Date: Sun, 28 Jun 2009 00:25:14 +0200
From: Arno Schuring <aelschuring@hotmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc1 WARNING: at drivers/char/tty_ldisc.c:210
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Concepts-MailScanner-Information: Please contact abuse@concepts.nl for more information
X-Concepts-MailScanner-ID: 1MKgKl-0006Pd-Eb
X-Concepts-MailScanner: Found to be clean
X-Concepts-MailScanner-SpamCheck: 
X-Concepts-MailScanner-From: aelschuring@hotmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to all,

Current 2.6.31-rc1 is triggering a warning on my machine (x86 non-smp).
I can reliably trigger this warning by booting single-user and
performing telinit 2 (which continues normal boot). I'm testing with
Radeon kernel modesetting enabled on an R300 card, but I'm not sure if
that is relevant.

First of all: if I'm posting to the wrong list, please kindly redirect
me to the correct location. I have found one reference to this warning,
it was on the PPC list:
http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg34679.html

Since I'm not on ppc, I don't think I should raise the issue there.
However, the thread suggested to enable TTY_DEBUG_HANGUP, which I have
done. The relevant warning and backtrace is below. I can provide the
full dmesg and .config (or other information), please let me know how I
can best provide more information.

Besides the warning, I have not noticed any problems on my machine: all
terminals are still functional and X is running as well. If this is a
harmless message, I'm quite happy to just ignore it just as well.


Detailed information:

aschuring@neminis:~/work/linux-GIT$ git describe HEAD
v2.6.31-rc1-114-g4075ea8

[   53.764065] WARNING: at drivers/char/tty_ldisc.c:210
tty_ldisc_put+0x77/0x90()
[   53.764069] Hardware name:
[   53.764070] Modules linked in: ipv6 ext3 jbd fuse dm_crypt dm_mod
w83627hf hwmon_vid i2c_sis96x parport_pc evdev parport pcspkr processor
serio_raw button xfs exportfs usbhid hid usb_storage ohci_hcd sg
ehci_hcd sr_mod cdrom sd_mod usbcore nls_base floppy thermal fan thermal_sys
[   53.764102] Pid: 2521, comm: sh Not tainted 2.6.31-rc1 #9
[   53.764105] Call Trace:
[   53.764110]  [<c11cc0b7>] ? tty_ldisc_put+0x77/0x90
[   53.764114]  [<c11cc0b7>] ? tty_ldisc_put+0x77/0x90
[   53.764121]  [<c10295a6>] ? warn_slowpath_common+0x76/0xd0
[   53.764125]  [<c11cc0b7>] ? tty_ldisc_put+0x77/0x90
[   53.764129]  [<c1029613>] ? warn_slowpath_null+0x13/0x20
[   53.764133]  [<c11cc0b7>] ? tty_ldisc_put+0x77/0x90
[   53.764137]  [<c11cc6b3>] ? tty_ldisc_reinit+0x13/0x40
[   53.764140]  [<c11cc82f>] ? tty_ldisc_hangup+0xff/0x1a0
[   53.764149]  [<c11c5ac2>] ? do_tty_hangup+0xf2/0x410
[   53.764153]  [<c11c5e0c>] ? tty_vhangup+0x2c/0x40
[   53.764161]  [<c10a8f00>] ? remove_vma+0x0/0x60
[   53.764166]  [<c10ab2df>] ? exit_mmap+0x11f/0x170
[   53.764174]  [<c10b9e07>] ? filp_close+0x47/0x80
[   53.764178]  [<c11c50f8>] ? get_current_tty+0x38/0x60
[   53.764184]  [<c134e338>] ? lock_kernel+0x18/0x30
[   53.764189]  [<c11c5e5a>] ? disassociate_ctty+0x3a/0x250
[   53.764194]  [<c102cde5>] ? do_exit+0x725/0x750
[   53.764202]  [<c103633a>] ? recalc_sigpending+0xa/0x30
[   53.764207]  [<c103805f>] ? dequeue_signal+0x2f/0x1d0
[   53.764211]  [<c102ce3b>] ? do_group_exit+0x2b/0xa0
[   53.764215]  [<c1038644>] ? get_signal_to_deliver+0x194/0x490
[   53.764220]  [<c1002a9d>] ? do_notify_resume+0xcd/0x830
[   53.764230]  [<c1134bcb>] ? task_has_perm+0x6b/0x90
[   53.764237]  [<c112d16c>] ? security_task_wait+0xc/0x10
[   53.764241]  [<c102b595>] ? wait_consider_task+0x75/0x940
[   53.764250]  [<c1040b56>] ? remove_wait_queue+0x36/0x50
[   53.764254]  [<c102c015>] ? do_wait+0x1b5/0x2f0
[   53.764258]  [<c1025230>] ? default_wake_function+0x0/0x10
[   53.764262]  [<c102c1e0>] ? sys_wait4+0x90/0xd0
[   53.764266]  [<c1003456>] ? work_notifysig+0x13/0x19
[   53.764270] ---[ end trace 1c55ed9a5fd77151 ]---
[   53.764303] error attempted to write to tty [0x(null)] = NULL


Kind regards,
Arno Schuring
