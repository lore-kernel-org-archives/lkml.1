Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbXJYGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbXJYGA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 02:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXJYGAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 02:00:13 -0400
Received: from dlswww.dls.net ([216.145.234.92]:15692 "EHLO demolition.dls.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbXJYGAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 02:00:11 -0400
X-Greylist: delayed 1993 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 02:00:09 EDT
From: <mwester@dls.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>,
       Bill Gatliff <bgat@billgatliff.com>
Cc: svs1957@gmail.com, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2007 00:26:54 -0500
X-SentFrom: 12.27.45.5
X-SentAddr: 4675c051ba9e8885d6e5a82457605098ccf0a84b
User-Agent: DLS.net Webmail
References: <bug-9217-10286@http.bugzilla.kernel.org/> <20071024195717.0de6a248.akpm@linux-foundation.org>
In-Reply-To: <20071024195717.0de6a248.akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to kernel
Content-Type: text/plain; charset=us-ascii; format=flowed
Message-Id: <20071025052654.04A665C@demolition.dls.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 24 Oct 2007 05:32:14 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9217
> > 
> > &#160; &#160; &#160; &#160; &#160; &#160;Summary: CONFIG_CMDLINE doesn't pass to kernel
> > &#160; &#160; &#160; &#160; &#160; &#160;Product: Other
> > &#160; &#160; &#160; &#160; &#160; &#160;Version: 2.5
> > &#160; &#160; &#160;KernelVersion: 2.6.23
> > &#160; &#160; &#160; &#160; &#160; Platform: All
> > &#160; &#160; &#160; &#160; OS/Version: Linux
> > &#160; &#160; &#160; &#160; &#160; &#160; &#160; Tree: Mainline
> > &#160; &#160; &#160; &#160; &#160; &#160; Status: NEW
> > &#160; &#160; &#160; &#160; &#160; Severity: high
> > &#160; &#160; &#160; &#160; &#160; Priority: P1
> > &#160; &#160; &#160; &#160; &#160;Component: Other
> > &#160; &#160; &#160; &#160; AssignedTo: other_other@kernel-bugs.osdl.org
> > &#160; &#160; &#160; &#160; ReportedBy: svs1957@gmail.com
> > 
> > 
> > Most recent kernel where this bug did not occur:2.6.24-rc1
> > Distribution: Debian Armel (arm with EABI)
> > Hardware Environment: Sharp Zaurus 750 (ARM pxa255)
> > Software Environment: Debian
> > Problem Description:
> > I try to upgrade kernel from 2.6.22.9 to 2.6.23.
> > 2.6.22.9 works correct. Kernel 2.6.23 doesn't use &#160;CONFIG_CMDLINE and doesn't
> > pass bootparams:
> > CONFIG_CMDLINE="console=ttyS0,115200n8 console=tty1 noinitrd
> > root=/dev/mmcblk0p1 rootfstype=ext3 rw rootdelay=5"
> > But kernel still try to mount /dev/mtdblock2 using jffs2.
> > Steps to reproduce:
> > Compile kernel with CONFIG_CMDLINE and try to boot.
> > 
> > 
> 
> Something broke CONFIG_CMDLINE of ARM (at least) between 2.6.22 and 2.6.23.
> 
> I don't know whether it was an ARM patch one of those kernel-wide changes. 
> We have futzed with the command-line parsing a bit recently, but the 2.6.23
> changelog doesn't suggest anything obvious.

I think the zaurus kernel deliberately ignored the bootparams passed in by the device's bootloader.  The 2.6.23 kernel now honors the r2 setting from the bootloader, which is most likely pointing to those ATAGs that were being ignored earlier.

I suppose you can hack up the logic in setup.c where the ATAGs are parsed, but it seems to me that it would be better to work out some logic, perhaps in the fixup section for that machine, to do whatever is necessary to override or otherwise get along with the bootloader.

Mike (mwester)
