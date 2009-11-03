Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZKCQXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZKCQXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:23:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZKCQXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:23:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbZKCQXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:23:06 -0500
Subject: Re: [-next regression] lockdep? tracing? BUG: unable to handle
 kernel paging request at
From: Eric Paris <eparis@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, mingo@elte.hu,
       zhaolei@cn.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lizf@cn.fujitsu.com
In-Reply-To: <1257264170.26028.3340.camel@gandalf.stny.rr.com>
References: <1257263296.2891.97.camel@dhcp231-106.rdu.redhat.com>
	 <1257264170.26028.3340.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 11:22:30 -0500
Message-Id: <1257265350.2891.102.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 11:02 -0500, Steven Rostedt wrote:
> [ Added Peter Zijlstra ]
> 
> On Tue, 2009-11-03 at 10:48 -0500, Eric Paris wrote:
> > Linux-next from Oct 30 did not have this problem.  Linux next from
> > yesterday (and today) I always hit this on boot.
> 
> Could you also give the SHA1 of Linux-next, as well as the config you
> used.

cb9267934a27b149416762308a36e8a61f04ecb2

> > 
> > [    7.989630] BUG: unable to handle kernel paging request at 00000000000160de
> > [    7.990538] IP: [<ffffffff8123cdbf>] strcmp+0xf/0x30
> > [    7.990538] PGD 77f7e067 PUD 77ff1067 PMD 0 
> > [    7.990538] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > [    7.990538] last sysfs file: /sys/devices/platform/i8042/serio0/input/input2/event2/uevent
> > [    7.990538] CPU 0 
> > [    7.990538] Modules linked in: ata_piix(+)
> > [    7.990538] Pid: 1024, comm: modprobe Not tainted 2.6.32-rc5-fanotify-next-20091102 #150 
> 
> Just curious, what module were you loading?

Looking at strace of the modprobe command it shows at the bottom I
believe it was ata_generic.  But I don't really know.

> Hmm, event_mutex is defined with
> 
> DEFINE_MUTEX(event_mutex);
> 
> in trace_events.c (well, in my kernel, I'm not looking at linux-next
> right now). This should set up lockdep without any issues.

It's a DEFINE_MUTEX in linux-next as well.

> Would be better to get more info (as asked above). You can send
> the .config privately to me, as not to spam LKML with it.

Incoming along will full dmesg.

