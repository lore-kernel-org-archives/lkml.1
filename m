Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXIWFg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXIWFg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 01:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXIWFgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 01:36:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752878AbXIWFgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 01:36:19 -0400
Date: Sat, 22 Sep 2007 22:35:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.23-rc6-mm1] NMI Watchdog detected LOCKUP on CPU 0
Message-Id: <20070922223545.a1bdb1b5.akpm@linux-foundation.org>
In-Reply-To: <390525442.01749@ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<390511737.19669@ustc.edu.cn>
	<20070922212236.db145c57.akpm@linux-foundation.org>
	<390525442.01749@ustc.edu.cn>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007 13:30:40 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> > That's interensting.  serial_in().  We have had NMI watchdog expiries when
> > the kernel is printing a large amount of stuff out a slow serial port with
> > interrutps disabled.  But I thought we'd pretty much plugged those problems
> > by sprinkling touch_nmi_watchdog() in various places.
> > 
> > Do you think this is what was happening on your system?
> 
> Very likely. I'm running linux with cmdline
> "root=/dev/sda1 ro nmi_watchdog=1 console=ttyS0,115200 console=tty0",
> and doing a lot of printks at the time ;-)

OK.  We need to find a suitable place to poke yet another
touch_nmi_watchdog().  Maybe we should give up and put one in
printk().

And you oopsed for different reasons in the nmi-watchdog handling
code too.  I think I'll pretend I didn't see that.

