Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYEFGs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYEFGs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYEFGss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:48:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:40907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbYEFGsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:48:47 -0400
Date: Mon, 5 May 2008 23:47:41 -0700
From: Greg KH <gregkh@suse.de>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi_cpu_freq_init warning...
Message-ID: <20080506064741.GA6062@suse.de>
References: <86802c440805051951u153ebc21p15f0d73904496217@mail.gmail.com> <87k5i8hrmk.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5i8hrmk.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 03:29:55PM +0900, OGAWA Hirofumi wrote:
> > calling  acpi_cpufreq_init+0x0/0x68()
> > sysdev: class cpu: driver (ffffffff80da0110) has already been
> > registered to a class, something is wrong, but will forge on!
> > ------------[ cut here ]------------
> > WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x82/0x150()
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted
> > 2.6.26-rc1-sched-devel.git-x86-latest.git-00485-g253148c-dirty #333
> 
> I've seen this too. The following patch seems to work for me.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> 
> [PATCH] Fix bogus warning in sysdev_driver_register()
> 
> 	if ((drv->entry.next != drv->entry.prev) ||
> 	    (drv->entry.next != NULL)) {
> 
> warns list_empty(&drv->entry).

should we just call list_empty() here to make sure it is correct?

thanks,

greg k-h
