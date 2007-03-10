Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbXCJFbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbXCJFbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 00:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXCJFbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 00:31:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993173AbXCJFbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 00:31:43 -0500
Date: Sat, 10 Mar 2007 00:31:33 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>
Subject: 2.6.21-rc3 snd-usb-audio lockdep report.
Message-ID: <20070310053133.GA6466@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

=============================================
[ INFO: possible recursive locking detected ]
2.6.20-1.2962.fc7 #1
---------------------------------------------
rosegardenseque/5229 is trying to acquire lock:
 (&grp->list_mutex){----}, at: [<ffffffff881d4352>] snd_seq_deliver_event+0x93/0x173 [snd_seq]

but task is already holding lock:
 (&grp->list_mutex){----}, at: [<ffffffff881d4352>] snd_seq_deliver_event+0x93/0x173 [snd_seq]

other info that might help us debug this:
1 lock held by rosegardenseque/5229:
 #0:  (&grp->list_mutex){----}, at: [<ffffffff881d4352>] snd_seq_deliver_event+0x93/0x173 [snd_seq]

stack backtrace:

Call Trace:
 [<ffffffff802a303b>] __lock_acquire+0x151/0xbc4
 [<ffffffff802a3ea4>] lock_acquire+0x4c/0x65
 [<ffffffff881d4352>] :snd_seq:snd_seq_deliver_event+0x93/0x173
 [<ffffffff8029eab8>] down_read+0x3e/0x4a
 [<ffffffff881d4352>] :snd_seq:snd_seq_deliver_event+0x93/0x173
 [<ffffffff881d56c6>] :snd_seq:snd_seq_kernel_client_dispatch+0x54/0x68
 [<ffffffff881fd05f>] :snd_seq_dummy:dummy_input+0x54/0x5a
 [<ffffffff881d41cb>] :snd_seq:snd_seq_deliver_single_event+0xf8/0x1ec
 [<ffffffff881d43a1>] :snd_seq:snd_seq_deliver_event+0xe2/0x173
 [<ffffffff881d4819>] :snd_seq:snd_seq_dispatch_event+0xed/0x110
 [<ffffffff881d6e0e>] :snd_seq:snd_seq_check_queue+0xbc/0x105
 [<ffffffff881d70e3>] :snd_seq:snd_seq_enqueue_event+0xb6/0xca
 [<ffffffff881d4501>] :snd_seq:snd_seq_client_enqueue_event+0xcf/0x101
 [<ffffffff881d5db2>] :snd_seq:snd_seq_write+0x140/0x198
 [<ffffffff8021634f>] vfs_write+0xcf/0x178
 [<ffffffff80216d64>] sys_write+0x47/0x70
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1


-- 
http://www.codemonkey.org.uk
