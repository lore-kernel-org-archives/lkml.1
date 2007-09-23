Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXIWFxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXIWFxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 01:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXIWFxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 01:53:08 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:58735 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752878AbXIWFxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 01:53:07 -0400
Message-ID: <390526785.26292@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 23 Sep 2007 13:53:03 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG 2.6.23-rc6-mm1] NMI Watchdog detected LOCKUP on CPU 0
Message-ID: <20070923055303.GA14899@mail.ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <390511737.19669@ustc.edu.cn> <20070922212236.db145c57.akpm@linux-foundation.org> <390525442.01749@ustc.edu.cn> <20070922223545.a1bdb1b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922223545.a1bdb1b5.akpm@linux-foundation.org>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 10:35:45PM -0700, Andrew Morton wrote:
> On Sun, 23 Sep 2007 13:30:40 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> 
> > > That's interensting.  serial_in().  We have had NMI watchdog expiries when
> > > the kernel is printing a large amount of stuff out a slow serial port with
> > > interrutps disabled.  But I thought we'd pretty much plugged those problems
> > > by sprinkling touch_nmi_watchdog() in various places.
> > > 
> > > Do you think this is what was happening on your system?
> > 
> > Very likely. I'm running linux with cmdline
> > "root=/dev/sda1 ro nmi_watchdog=1 console=ttyS0,115200 console=tty0",
> > and doing a lot of printks at the time ;-)
> 
> OK.  We need to find a suitable place to poke yet another
> touch_nmi_watchdog().  Maybe we should give up and put one in
> printk().
> 
> And you oopsed for different reasons in the nmi-watchdog handling
> code too.  I think I'll pretend I didn't see that.

Let's forget it for now.
I can try Ingo's latency tracing patches at some convenient time.

