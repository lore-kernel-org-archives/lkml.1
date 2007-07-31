Return-Path: <linux-kernel-owner+w=401wt.eu-S1759060AbXGaLEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbXGaLEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 07:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878AbXGaLEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 07:04:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37542 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751701AbXGaLEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 07:04:44 -0400
Date: Tue, 31 Jul 2007 13:04:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Message-ID: <20070731110458.GA1777@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184483593.1898.98.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 3. Boot kernel compiled for normal usage, the reserved crash kernel
>    memory region must be added to kernel command line as following:
> 
>    crashkernel=<XX>M@<XX>M
> 
>    Where, <XX> should be replaced by the real memory size and
> position.

I used crashkernel=64M@64M .


> 4. Load kernel compiled for hibernating usage as a crashdump kernel
>    with kexec, the same kernel as that of 3 can be used if
>    CONFIG_RELOCATABLE=y is selected. The kernel command line option as
>    following must be appended to kernel command line.
> 
>    kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`
> 
>    For example, the shell command line can be as follow:
> 
>    kexec -p /boot/vmlinux --args-linux --append="root=/dev/hdb signal
>        kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"

I think I followed the instructions closely. Now I'm trying to do 

kexec -p /data/l/linux/vmlinux --args-linux --append="init=/bin/bash
kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"

but it tells me:

Invalid memory segment 0x100000 - 0x7a0fff

(and nothing in dmesg) 

If I try to load bzImage (corresponding to vmlinux I tried to use),  I
get:

root@amd:~# kexec -p /data/l/linux/arch/i386/boot/bzImage --append="init=/bin/bash kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
Could not find a free area of memory of 9000 bytes...
locate_hole failed
root@amd:~#

What am I doing wrong?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
