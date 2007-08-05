Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXHES4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXHES4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXHES4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:56:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44238 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751918AbXHES4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:56:03 -0400
Date: Sun, 5 Aug 2007 20:55:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Message-ID: <20070805185558.GE1758@elf.ucw.cz>
References: <1184483593.1898.98.camel@caritas-dev.intel.com> <20070731110458.GA1777@elf.ucw.cz> <1185932071.1363.13.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185932071.1363.13.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > root@amd:~# kexec -p /data/l/linux/arch/i386/boot/bzImage --append="init=/bin/bash kexec_jump_buf_pfn=`cat /sys/kernel/kexec_jump_buf_pfn`"
> > Could not find a free area of memory of 9000 bytes...
> > locate_hole failed
> > root@amd:~#
> > 
> > What am I doing wrong?
> 
> The kexec-tools version 1.101 does not work perfectly with relocatable
> kernel. This would have been solved if I worked against kexec-tools
> testing tree. I will work against testing tree in the next version.
> 
> But, with some trick, it can work. When configure kernel, make sure the
> following option is set:
> 
> CONFIG_PHYSICAL_START=0x4000000 # if crashkernel=<XX>M@64M

Did the trick, I got the kernel to load, and it even attempted
exec... but I got doublefault (or what is it?)

Int 6: ... EIP: c4739906. Address is in reserve_bootmem_core.

Do I have to disable ACPI completely? I tried with acpi=off,
nosmp... but problem does not seem device related.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
