Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYKCHmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYKCHmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbYKCHma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:42:30 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34736 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395AbYKCHm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:42:29 -0500
Message-ID: <490EAB65.1000908@lwfinger.net>
Date: Sun, 02 Nov 2008 23:42:29 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: System hang from holding left shift key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While absentmindedly holding down the left shift key as I was thinking about my
next input, I froze the keyboard. After 3 seconds, the system sounded a high
beep, and then a low beep after another 3 seconds. At that point, no key entry
had any effect. From the beeps, one might conclude that the input buffer is
full, but a CTRL/U did not clear it. Fortunately, a short press on the power
button shut down the machine cleanly.

I don't know if this is a regression. I found it in v2.6.28-rc2, but the oldest
kernel that I could test (v2.6.24) already has the problem.

When the beeps occur, a stack dump is as follows:

Pid: 2989, comm: Xorg Not tainted 2.6.28-rc2-Linus-00473-g67d1128-dirty #2
Call Trace:
  [<ffffffff803957ce>] kd_mksound+0x69/0xa9
  [<ffffffff8039196c>] vt_ioctl+0x3c4/0x1744
  [<ffffffff8038b097>] tty_ioctl+0x793/0x7fa
  [<ffffffff8025c6c0>] ? trace_hardirqs_off+0xd/0xf
  [<ffffffff8044f94a>] ? _spin_unlock_irqrestore+0x3d/0x4c
  [<ffffffff802bf102>] vfs_ioctl+0x2f/0x7d
  [<ffffffff802bf4fe>] do_vfs_ioctl+0x3ae/0x3e0
  [<ffffffff8020c07c>] ? sysret_check+0x27/0x62
  [<ffffffff802bf577>] sys_ioctl+0x47/0x6a
  [<ffffffff8020c04b>] system_call_fastpath+0x16/0x1b

Thanks,

Larry


