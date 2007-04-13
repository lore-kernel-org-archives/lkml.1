Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDMTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDMTOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbXDMTOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:14:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbXDMTOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:14:17 -0400
Date: Fri, 13 Apr 2007 15:14:15 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: i8042 lockdep false positive.
Message-ID: <20070413191415.GA27682@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just had a user file the report below, which iirc, was deemed a false
positive.  Didn't we add something to the code so that lockdep would
ignore what this was doing ?  Did we regress?

(This was .21-rc5, during resume)

	Dave

 > =============================================
 > [ INFO: possible recursive locking detected ]
 > 2.6.20-1.3062.fc7 #1
 > ---------------------------------------------
 > kseriod/216 is trying to acquire lock:
 >  (&ps2dev->cmd_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 > 
 > but task is already holding lock:
 >  (&ps2dev->cmd_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 > 
 > other info that might help us debug this:
 > 5 locks held by kseriod/216:
 >  #0:  (serio_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 >  #1:  (&s->rwsem){----}, at: [<c05882de>] serio_find_driver+0x13/0x50
 >  #2:  (&serio->drv_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 >  #3:  (psmouse_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 >  #4:  (&ps2dev->cmd_mutex){--..}, at: [<c0614fa2>] mutex_lock+0x21/0x24
 > 
 > stack backtrace:
 >  [<c04061e9>] show_trace_log_lvl+0x1a/0x2f
 >  [<c04067ad>] show_trace+0x12/0x14
 >  [<c0406831>] dump_stack+0x16/0x18
 >  [<c0442089>] __lock_acquire+0x11f/0xba4
 >  [<c0442f00>] lock_acquire+0x56/0x6f
 >  [<c0614e0a>] __mutex_lock_slowpath+0xf7/0x26e
 >  [<c0614fa2>] mutex_lock+0x21/0x24
 >  [<c058ad30>] ps2_command+0x92/0x319
 >  [<c05912d8>] psmouse_sliced_command+0x1c/0x5a
 >  [<c0594861>] synaptics_pt_write+0x1e/0x41
 >  [<c058ac0c>] ps2_sendbyte+0x39/0xcb
 >  [<c058adaa>] ps2_command+0x10c/0x319
 >  [<c0590f13>] psmouse_probe+0x1d/0x6c
 >  [<c0591f90>] psmouse_connect+0xed/0x205
 >  [<c05882a3>] serio_connect_driver+0x1e/0x2e
 >  [<c05882c9>] serio_driver_probe+0x16/0x18
 >  [<c0562b45>] really_probe+0xc7/0x150
 >  [<c0562c63>] driver_probe_device+0x95/0xa1
 >  [<c0562c77>] __device_attach+0x8/0xa
 >  [<c0562035>] bus_for_each_drv+0x3a/0x65
 >  [<c0562d00>] device_attach+0x68/0x7d
 >  [<c05882e9>] serio_find_driver+0x1e/0x50
 >  [<c0588f39>] serio_thread+0x153/0x2a6
 >  [<c043830f>] kthread+0xb3/0xdc
 >  [<c0405cd3>] kernel_thread_helper+0x7/0x10
 >  =======================


-- 
http://www.codemonkey.org.uk
