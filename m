Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZCCDiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZCCDiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 22:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZCCDh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 22:37:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbZCCDh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 22:37:56 -0500
Message-ID: <49ACA645.7080808@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 11:38:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: lockdep: possible fasync_lock/f_lock irq lock inversion dependency
References: <20090303024900.GA24473@localhost>
In-Reply-To: <20090303024900.GA24473@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hello,
> 
> I get a lockdep warning on HP 6910p:
> 

I saw this too, immediately when I opened Konsole after system boot,
and I was using 2.6.29-rc6-mm1.

> [  313.825353]
> [  313.825356] =========================================================
> [  313.825375] [ INFO: possible irq lock inversion dependency detected ]
> [  313.825385] 2.6.29-rc5-next-20090220 #62
> [  313.825393] ---------------------------------------------------------
> [  313.825401] swapper/0 just changed the state of lock:
> [  313.825409]  (fasync_lock){.-....}, at: [<ffffffff810ec9ae>] kill_fasync+0x2e/0x60
> [  313.825443] but this lock took another, HARDIRQ-READ-irq-unsafe lock in the past:
> [  313.825451]  (&f->f_lock){+.+...}
> [  313.825464]
> [  313.825465] and interrupts could create inverse lock ordering between them.
> [  313.825468]
> [  313.825484]
> [  313.825486] other info that might help us debug this:
> [  313.825497] 4 locks held by swapper/0:
> [  313.825504]  #0:  (&serio->lock){-.-...}, at: [<ffffffff8134afa1>] serio_interrupt+0x31/0xa0
> [  313.825539]  #1:  (&dev->event_lock){-.-...}, at: [<ffffffff8134fffc>] input_event+0x5c/0xa0
> [  313.825570]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff8134e570>] input_pass_event+0x0/0xf0
> [  313.825600]  #3:  (rcu_read_lock){.+.+..}, at: [<ffffffff813538d0>] evdev_event+0x0/0x120
> [  313.825630]

