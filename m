Return-Path: <linux-kernel-owner+w=401wt.eu-S1751881AbZFOBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbZFOBqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbZFOBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 21:46:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52164 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbZFOBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 21:46:08 -0400
To: linux-kernel@vger.kernel.org
Subject: X server hung, kernel said "task blocked for >120 secs" (2.6.30)
X-Mailer: MH-E 8.1; nmh 1.3; GNU Emacs 22.3.1
Date: Sun, 14 Jun 2009 21:46:05 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1MG1Gv-0001Vq-6T@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm running vanilla 2.6.30 on an otherwise Debian 'unstable' system -- a
TP T60 with Intel graphics and wireless (no tainting).  The X server
[xorg 1.6.1.901 (1.6.2 RC 1), intel driver 2.7.1] hung in a way that it
often has with other versions: The mouse cursor moves around as normal,
but the keyboard or mouse buttons don't do anything.  I used sysrq half
competently to send TERM and KILL signals and then reboot.

The log message below was in the /var/log/messages from when the problem
happened.  Should I report this information to freedesktop.org or is it
a kernel issue belonging on the bugzilla?

[228600.676053] INFO: task events/0:9 blocked for more than 120 seconds.
[228600.676058] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[228600.676061] events/0      D 31efa204     0     9      2
[228600.676066]  c1bfc040 00000046 f7121a60 31efa204 c0439040 c0436134 c0101f70 f708f0c0
[228600.676075]  f708f274 00000000 00000000 f7121a8c c1bfc040 00000000 c011d842 c1bfc580
[228600.676083]  f708f0c0 f708f274 0366353a f626cac0 00000000 c0439040 c02f19c2 c03a8300
[228600.676090] Call Trace:
[228600.676099]  [<c0101f70>] ? __switch_to+0xbf/0x140
[228600.676105]  [<c011d842>] ? pick_next_task_fair+0x80/0x87
[228600.676111]  [<c02f19c2>] ? __schedule+0x6f2/0x74d
[228600.676115]  [<c02f1fc4>] ? __mutex_lock_common+0xe1/0x136
[228600.676120]  [<c02f2028>] ? __mutex_lock_slowpath+0xf/0x11
[228600.676123]  [<c02f1e78>] ? mutex_lock+0x10/0x1e
[228600.676127]  [<c02f1e78>] ? mutex_lock+0x10/0x1e
[228600.676133]  [<c0133e97>] ? queue_delayed_work_on+0x9c/0xa8
[228600.676150]  [<f8ff74f3>] ? i915_gem_retire_work_handler+0x1c/0x4e [i915]
[228600.676155]  [<c0133701>] ? worker_thread+0x13d/0x1bf
[228600.676168]  [<f8ff74d7>] ? i915_gem_retire_work_handler+0x0/0x4e [i915]
[228600.676174]  [<c01365a6>] ? autoremove_wake_function+0x0/0x2d
[228600.676178]  [<c01335c4>] ? worker_thread+0x0/0x1bf
[228600.676182]  [<c01362b6>] ? kthread+0x42/0x67
[228600.676186]  [<c0136274>] ? kthread+0x0/0x67
[228600.676190]  [<c0103ab7>] ? kernel_thread_helper+0x7/0x10
[228611.402991] SysRq : Keyboard mode set to system default
