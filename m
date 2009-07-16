Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZGPSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZGPSto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932941AbZGPSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:49:44 -0400
Received: from cmpxchg.org ([85.214.51.133]:55606 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbZGPStn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:49:43 -0400
Date: Thu, 16 Jul 2009 20:48:46 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Alan Cox <alan@xorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Hangups in n_tty_read()
Message-ID: <20090716184846.GA1470@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

I regularly get hung terminals when ^Cing a foreground process.  The
terminal won't show any sign of input or output anymore then.

Here is an excerpt from sysrq+w:

Jul 16 17:33:10 chigurh kernel: [20907.892444] conf          S 0000000000000000     0 10946  10888 0x00000000
Jul 16 17:33:10 chigurh kernel: [20907.892444]  ffff88000e1efd58 0000000000000082 ffff88000e1efcc8 ffffffff8103423b
Jul 16 17:33:10 chigurh kernel: [20907.892444]  0000000000004000 0000000000012240 000000000000dc78 ffff880001639240
Jul 16 17:33:10 chigurh kernel: [20907.892444]  ffff88000e1efce8 ffff880024688000 ffff88002f8651c0 ffff880024688378
Jul 16 17:33:10 chigurh kernel: [20907.892444] Call Trace:
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8103423b>] ? try_to_wake_up+0x29e/0x2b0
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8103423b>] ? try_to_wake_up+0x29e/0x2b0
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8134f675>] schedule_timeout+0x26/0x190
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff811ea909>] n_tty_read+0x496/0x74d
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8103424d>] ? default_wake_function+0x0/0xf
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff811e65a5>] tty_read+0x7d/0xba
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8109a33b>] vfs_read+0xab/0x122
Jul 16 17:33:10 chigurh kernel: [20907.892444]  [<ffffffff8109a476>] sys_read+0x47/0x6f

Killing the hung foreground process from another terminal works.  But
it won't recover the screwed terminal and the terminal does not show
any reaction to it (like a prompt) even when the process is gone.

I remember one hang without X where the cursor-blinking was still
affected by keyboard input.

Unfortunately, I hadn't had the chance to test if input comes through
by blindly executing something disk heavy and watch the LEDs or
similar, so I can't say for sure if it's just output or if input is
affected as well.

First kernel I noticed this with was something past .30.  And it
certainly happens with Linus' latest.

Any idea?

	Hannes
