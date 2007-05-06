Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXEFPAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXEFPAA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 11:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXEFPAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 11:00:00 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:33688 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbXEFO77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 10:59:59 -0400
Message-ID: <463DED69.4020507@simon.arlott.org.uk>
Date: Sun, 06 May 2007 15:59:53 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/07 09:49, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

I'm currently in the middle of a bisect over the last week of commits to linus' 
tree, but I got the following with -mm1 that isn't showing up in the latest 
2.6.21-git:

[   15.644778] BUG: sleeping function called from invalid context at kernel/mutex.c:86
[   15.644873] in_atomic():1, irqs_disabled():1
[   15.644882] 2 locks held by modprobe/2765:
[   15.644889]  #0:  (devlist_lock){--..}, at: [<b052dc7f>] mutex_lock+0x1f/0x30
[   15.645058]  #1:  (modlist_lock){....}, at: [<b0147b1d>] __symbol_get+0x1d/0x90
[   15.645207] irq event stamp: 11772
[   15.645271] hardirqs last  enabled at (11771): [<b016d793>] slab_free+0xc3/0x200
[   15.645289] hardirqs last disabled at (11772): [<b052f476>] _spin_lock_irqsave+0x16/0x60
[   15.645364] softirqs last  enabled at (11216): [<b0125286>] __do_softirq+0x96/0xb0
[   15.645439] softirqs last disabled at (11211): [<b01069f2>] do_softirq+0x82/0x100
[   15.645517]  [<b0104f0a>] show_trace_log_lvl+0x1a/0x30
[   15.645586]  [<b0104f32>] show_trace+0x12/0x20
[   15.645654]  [<b0105045>] dump_stack+0x15/0x20
[   15.645665]  [<b011d6ad>] __might_sleep+0xcd/0xf0
[   15.645737]  [<b052dc78>] mutex_lock+0x18/0x30
[   15.645806]  [<b01b1b7c>] sysfs_create_link+0x6c/0x130
[   15.645823]  [<b0146dba>] use_module+0x11a/0x170
[   15.645892]  [<b0147b6c>] __symbol_get+0x6c/0x90
[   15.645904]  [<f086ac2c>] dvb_init+0x98c/0xd70 [saa7134_dvb]
[   15.645984]  [<b036861d>] mpeg_ops_attach+0x3d/0x50
[   15.646058]  [<b0369109>] saa7134_ts_register+0x29/0x70
[   15.646070]  [<f086f010>] dvb_register+0x10/0x12 [saa7134_dvb]
[   15.646141]  [<b01491b7>] sys_init_module+0xf7/0x150
[   15.646153]  [<b0104172>] sysenter_past_esp+0x5f/0x99
[   15.646221]  =======================

And this fantastic Oops:
[   40.965119] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000080
[   40.965252]  printing eip:
[   40.965252] b016d4a5
[   40.965300] *pde = 00000000
[   40.965352] Oops: 0000 [#1]
[   40.965467] PREEMPT 

It occurs when racoon is started so must be IPSEC related, I'll have more information 
once I finish bisecting and merge -mm1 again.

-- 
Simon Arlott
