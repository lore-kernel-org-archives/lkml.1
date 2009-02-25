Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbZBYUw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbZBYUw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbZBYUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:52:50 -0500
Received: from smtp1.Stanford.EDU ([171.67.219.81]:50443 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZBYUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:52:49 -0500
Subject: Re: [Announce] 2.6.29-rc6-rt3 (was 2.6.29-rc6-rt2)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1235513895.3816.11.camel@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain>
	 <1235513895.3816.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 12:52:40 -0800
Message-Id: <1235595160.9252.49.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 14:18 -0800, Fernando Lopez-Lezcano wrote:
> On Tue, 2009-02-24 at 17:30 +0100, Thomas Gleixner wrote:
> > On Tue, 24 Feb 2009, Thomas Gleixner wrote:
> > > >  [<c0440ef1>] internal_add_timer+0x88/0x8c
> > > 
> > > Can you try to enable the following config options:
> > > 
> > > CONFIG_DEBUG_OBJECTS
> > > CONFIG_DEBUG_OBJECTS_FREE
> > > CONFIG_DEBUG_OBJECTS_TIMERS
> > > CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT
> > 
> > Don't bother. Just noticed that this is nf_conntrack context. Working
> > on that right now.
> 
> I'm running rc6-rt3 and that problem seem to be gone (uptime of 2.5
> hours in my desktop, 1.33 hours on my laptop, both running FC9 with a
> 2.6.29 version of the Planet CCRMA rt kernel). So far so good!

I see this when going through a suspend/wakeup cycle on my laptop (but
no side effects I can see):

BUG: sleeping function called from invalid context at
kernel/rtmutex.c:683
in_atomic(): 0, irqs_disabled(): 1, pid: 8829, name: pm-suspend
Pid: 8829, comm: pm-suspend Not tainted
2.6.29-0.1.rt3.1.rc6.fc9.ccrma.i686.rtPAE #1
Call Trace:
 [<c06e62cf>] ? rt_spin_lock_slowlock+0x0/0x1db
 [<c043216b>] __might_sleep+0xec/0xf1
 [<c045716e>] rt_spin_lock_fastlock+0x27/0x5e
 [<c06e6b2e>] rt_spin_lock+0xd/0xf
 [<c040dc4e>] read_persistent_clock+0xe/0x25
 [<c045057c>] timekeeping_suspend+0x9/0x94
 [<c05c13fd>] sysdev_suspend+0x67/0x175
 [<c045c508>] suspend_devices_and_enter+0xea/0x179
 [<c045c6ec>] enter_state+0x130/0x190
 [<c045c7e0>] state_store+0x94/0xa8
 [<c045c74c>] ? state_store+0x0/0xa8
 [<c053b9d5>] kobj_attr_store+0x1a/0x22
 [<c04e8091>] sysfs_write_file+0xb7/0xe2
 [<c04e7fda>] ? sysfs_write_file+0x0/0xe2
 [<c04ab325>] vfs_write+0x84/0xdf
 [<c04ab419>] sys_write+0x3b/0x60
 [<c0408bab>] sysenter_do_call+0x12/0x2c

-- Fernando


