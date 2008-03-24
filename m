Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYCXUTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYCXUTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYCXUTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:19:34 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:40782 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbYCXUTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:19:33 -0400
From: Chr <chunkeey@web.de>
To: linux-kernel@vger.kernel.org
Subject: PKTCDVD: possible recursive locking detected with 2.6.24.4/3
Date: Mon, 24 Mar 2008 21:19:30 +0100
User-Agent: KMail/1.9.9
Cc: petero2@telia.com, mingo@redhat.com, peterz@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803242119.30840.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+2q3RGoqC8GpN3/m3YC9ghUw1+2W2LyRbXjj13
	gToSCZUsvkaaaEirrxynOw4ywcweSdcoBKCFyMdI1jDspql8Wa
	30eA+T9M8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Whenever I start /etc/init.d/udftools. I get a warning from lockdep about
a possible recursive lockup... It looks like this:

--- 

Clocksource tsc unstable (delta = -80671344 ns)
pktcdvd: writer pktcdvd0 mapped to sr0

=============================================
[ INFO: possible recursive locking detected ]
2.6.24.4 #1
---------------------------------------------
scsi_id/4705 is trying to acquire lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a71a8>] do_open+0x74/0x2a9

but task is already holding lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a71a8>] do_open+0x74/0x2a9

other info that might help us debug this:
2 locks held by scsi_id/4705:
 #0:  (&bdev->bd_mutex){--..}, at: [<ffffffff802a71a8>] do_open+0x74/0x2a9
 #1:  (&ctl_mutex#2){--..}, at: [<ffffffff881ecf2a>] pkt_open+0x27/0xda1 
[pktcdvd]

stack backtrace:
Pid: 4705, comm: scsi_id Not tainted 2.6.24.4 #1

Call Trace:
 [<ffffffff80253b08>] __lock_acquire+0x1db/0xd3f
 [<ffffffff802a71a8>] do_open+0x74/0x2a9
 [<ffffffff802546f0>] lock_acquire+0x84/0xa8
 [<ffffffff802a71a8>] do_open+0x74/0x2a9
[...]
(full dmesg + backtrace: http://www.pastebin.ca/955702 )
---
Well, as you can see the function that tries to get the lock... has it 
already?! This sounds a bit bogus, what's going on here? Is this really
a locking bug or just lockdep noise?
(BTW: the pktcdvd device seems to work nonetheless...)

Regards,
	Christian
