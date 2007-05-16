Return-Path: <linux-kernel-owner+w=401wt.eu-S1762490AbXEPUMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762490AbXEPUMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:12:15 -0400
Received: from www17.your-server.de ([213.133.104.17]:4184 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXEPUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:12:14 -0400
Message-ID: <1179346302.464b657e70b7b@213.133.104.17>
Date: Wed, 16 May 2007 22:11:42 +0200
From: thomas@m3y3r.de
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de
Subject: [BUG] unable to handle kernel NULL pointer dereference at virtual address 00000003
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.60.74
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This Oops happens under heavy load with 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b104bcb8e460e45a1aebe3da9b86aacdb4cab12
 head.

Also i run the powertop tool in parallel of the build process.

This is what i could capture with netconsole:

"BUG: unable to handle kernel NULL pointer dereference at virtual address
00000003
 printing eip:
c0136e32
*pde = 00000000
Oops: 0000 [#1]
SMP 
Modules linked in: applesmc evdev snd_seq snd_seq_device"

System.map says:
c0136d47 t tick_nohz_handler
c0136e30 t match_entries
c0136e5a t tstats_open

match_entries is part of kernel/time/timer_stats.c
and only used within timer_stats.c

I guess without stack values this is hard to debug...

I cc'ed Ingo Molnar and Thomas Gleixner as they signed of the initial patch for
the timer_stats support:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=82f67cd9fca8c8762c15ba7ed0d5747588c1e221

mfg
thomas

