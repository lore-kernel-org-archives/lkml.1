Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbYEQAPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbYEQAPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYEQAOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:14:52 -0400
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:41841 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYEQAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:14:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoAACfALUicIvmz/2dsb2JhbAAIinqiaQ
Message-ID: <482E2378.9020007@gmail.com>
Date: Fri, 16 May 2008 21:14:48 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
References: <20080514174955.GA515@elte.hu>
In-Reply-To: <20080514174955.GA515@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

<snip description and patches>

I decided to give this tree a try, and I got:


[4294034.386085] ------------[ cut here ]------------
[4294034.387882] WARNING: at fs/proc/generic.c:669 
create_proc_entry+0x3d/0xc5()
[4294034.390059] Pid: 2565, comm: Xorg Not tainted 
2.6.26-rc2-00456-gd9df34e #35
[4294034.392682]
[4294034.392683] Call Trace:
[4294034.394071]  [<ffffffff8022a8ac>] warn_on_slowpath+0x53/0x81
[4294034.394077]  [<ffffffff802b57b4>] ? proc_register+0xf7/0x162
[4294034.394081]  [<ffffffff802b580b>] ? proc_register+0x14e/0x162
[4294034.394087]  [<ffffffff804afa05>] ? _spin_unlock+0x30/0x4b
[4294034.394091]  [<ffffffff802b580b>] ? proc_register+0x14e/0x162
[4294034.394095]  [<ffffffff8021a127>] ? startup_ioapic_irq+0x54/0x5f
[4294034.394099]  [<ffffffff802b5fcc>] create_proc_entry+0x3d/0xc5
[4294034.394103]  [<ffffffff80252008>] register_irq_proc+0x84/0xa0
[4294034.394108]  [<ffffffff80250b1a>] setup_irq+0x1b2/0x21b
[4294034.394113]  [<ffffffff80250cc8>] request_irq+0xf1/0x117
[4294034.394117]  [<ffffffff8038aaaa>] ? radeon_driver_irq_handler+0x0/0x7e
[4294034.394122]  [<ffffffff803789b6>] ? drm_control+0x0/0x186
[4294034.394126]  [<ffffffff80378acf>] drm_control+0x119/0x186
[4294034.394130]  [<ffffffff803770be>] drm_ioctl+0x1d3/0x265
[4294034.394589]  [<ffffffff80283e5e>] vfs_ioctl+0x5e/0x77
[4294034.394593]  [<ffffffff802840d2>] do_vfs_ioctl+0x25b/0x270
[4294034.394598]  [<ffffffff804af23e>] ? trace_hardirqs_on_thunk+0x35/0x3a
[4294034.394601]  [<ffffffff80284129>] sys_ioctl+0x42/0x65
[4294034.394606]  [<ffffffff8020b2eb>] system_call_after_swapgs+0x7b/0x80
[4294034.411597]
[4294034.411601] ---[ end trace 7f52164e4c2b9927 ]---

I have no idea if that is even related to the BKL or not, I haven't even 
opened the source file yet, but I figured I'd report it.

-- 
Kevin Winchester
