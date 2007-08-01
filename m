Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbXHABey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbXHABey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXHABep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:34:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:59816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbXHABeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:34:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,206,1183359600"; 
   d="scan'208";a="275019479"
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070731110458.GA1777@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
	 <20070731110458.GA1777@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Aug 2007 09:34:31 +0800
Message-Id: <1185932071.1363.13.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 01 Aug 2007 01:34:40.0264 (UTC) FILETIME=[20F68080:01C7D3DC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 13:04 +0200, Pavel Machek wrote:
> Hi!
> 
> > 3. Boot kernel compiled for normal usage, the reserved crash kernel
> >    memory region must be added to kernel command line as following:
> > 
> >    crashkernel=<XX>M@<XX>M
> > 
> >    Where, <XX> should be replaced by the real memory size and
> > position.
> 
> I used crashkernel=64M@64M .
> 
> 
> > 4. Load kernel compiled for hibernating usage as a crashdump kernel
> >    with kexec, the same kernel as that of 3 can be used if
> >    CONFIG_RELOCATABLE=y is selected. The kernel command line option as
> >    following must be appended to kernel command line.
> > 
> >    kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`
> > 
> >    For example, the shell command line can be as follow:
> > 
> >    kexec -p /boot/vmlinux --args-linux --append="root=/dev/hdb signal
> >        kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
> 
> I think I followed the instructions closely. Now I'm trying to do 
> 
> kexec -p /data/l/linux/vmlinux --args-linux --append="init=/bin/bash
> kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
> 
> but it tells me:
> 
> Invalid memory segment 0x100000 - 0x7a0fff
> 
> (and nothing in dmesg) 
> 
> If I try to load bzImage (corresponding to vmlinux I tried to use),  I
> get:
> 
> root@amd:~# kexec -p /data/l/linux/arch/i386/boot/bzImage --append="init=/bin/bash kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
> Could not find a free area of memory of 9000 bytes...
> locate_hole failed
> root@amd:~#
> 
> What am I doing wrong?

The kexec-tools version 1.101 does not work perfectly with relocatable
kernel. This would have been solved if I worked against kexec-tools
testing tree. I will work against testing tree in the next version.

But, with some trick, it can work. When configure kernel, make sure the
following option is set:

CONFIG_PHYSICAL_START=0x4000000 # if crashkernel=<XX>M@64M

Best Regards,
Huang Ying
