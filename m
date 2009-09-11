Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbZIKPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbZIKPcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbZIKPcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 11:32:51 -0400
Received: from relay1.vsu.ru ([62.76.169.14]:48259 "EHLO relay1.vsu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbZIKPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 11:32:51 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 11:32:50 EDT
X-drweb-hash: 
To: linux-kernel@vger.kernel.org
Subject: i915 and x11 freezes
From: Vladimir Volovich <vvv@vsu.ru>
Date: Fri, 11 Sep 2009 18:32:39 +0400
Message-ID: <87zl91wnzs.fsf@vvv.org.vrn.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

there are very annoying freezes of X11 recently on my desktop running
2.6.30-1-amd64 (from debian) on the DG33TL motherboard. i think, it is
the same as described here:

https://bugs.freedesktop.org/show_bug.cgi?id=20560
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525231

such freezes happen during output to the screen under X11, and could
occur while scrolling gnome-terminal, running firefox (iceweasel),
switching virtual desktops, etc.

when such "freeze" occurs, i can usually move the mouse pointer but
nothing more (and the keyboard is locked, e.g. the caps lock led could
not be toggled); although i can remotely login via ssh, and even via
remote X11.

interestingly, when i run remotely "init 6" to reboot, it sometimes does
not reboot until i move the mouse (or press some keys on keyboard), and
also recently i saw these messages in dmesg:

[19320.640013] INFO: task events/1:16 blocked for more than 120 seconds.
[19320.640017] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[19320.640020] events/1      D ffff8800280600c0     0    16      2
[19320.640026]  ffff88022b1414d0 0000000000000046 0000000000000000 0000000000000000
[19320.640031]  ffffffff8020e5a9 00000000000120c0 000000000000e250 ffff88022b1807f0
[19320.640036]  ffff88022b180ae0 0000000128062a48 ffffffff80235f65 ffff880028060128
[19320.640040] Call Trace:
[19320.640049]  [<ffffffff8020e5a9>] ? __switch_to+0xae/0x263
[19320.640054]  [<ffffffff80235f65>] ? dequeue_entity+0xf/0x11f
[19320.640061]  [<ffffffff804b4ad5>] ? __mutex_lock_common+0x10f/0x17f
[19320.640077]  [<ffffffffa071de52>] ? i915_gem_retire_work_handler+0x0/0x64 [i915]
[19320.640082]  [<ffffffff804b4944>] ? mutex_lock+0x12/0x28
[19320.640095]  [<ffffffffa071de79>] ? i915_gem_retire_work_handler+0x27/0x64 [i915]
[19320.640100]  [<ffffffff80250fe1>] ? worker_thread+0x174/0x211
[19320.640104]  [<ffffffff8025473e>] ? autoremove_wake_function+0x0/0x2e
[19320.640108]  [<ffffffff80250e6d>] ? worker_thread+0x0/0x211
[19320.640112]  [<ffffffff80250e6d>] ? worker_thread+0x0/0x211
[19320.640117]  [<ffffffff80254382>] ? kthread+0x54/0x80
[19320.640121]  [<ffffffff80210aca>] ? child_rip+0xa/0x20
[19320.640125]  [<ffffffff8025432e>] ? kthread+0x0/0x80
[19320.640129]  [<ffffffff80210ac0>] ? child_rip+0x0/0x20

which suggests that there is probably some incorrect locking going on
(which is supported by the above-described behavior that i usually need
to do some mouse moving, which generates interrupts, to get the reboot
process to proceed).

since i was seeing the above dmesg output, i don't exclude the
possibility that this hang is caused by some bug in the kernel, rather
than e.g. in the xserver-xorg-video-intel driver.

hope some gurus could help to fix this very annoying bug.

Best,
v.
