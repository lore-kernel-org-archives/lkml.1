Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbXKSNnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbXKSNnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXKSNnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:43:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:51602 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbXKSNnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:43:07 -0500
Date: Mon, 19 Nov 2007 14:42:00 +0100
From: Chris Friedhoff <chris@friedhoff.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "chris@friedhoff.org" <chris@friedhoff.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system
 after loading - now 2.6.24-rc3
Message-Id: <20071119144200.6026ce62.chris@friedhoff.org>
In-Reply-To: <200711111945.06745.rjw@sisk.pl>
References: <20071110221629.1d180480.chris@friedhoff.org>
	<200711111945.06745.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.10.14; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/ssqNY1LsJ/C3zfo3Ia3mdwiD7fvgbvapAxX+
 1Grj7W4ZNwiXJCpmRLFkjTwaDvixwboCelArwGe77tSQDFLyfG
 2CsOvKnpGZxwAQQ+dw+Lr03BNzdd28J
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Rafael,

just to let you know: with 2.6.24-rc3 I have the same problem.

Chris


On Sun, 11 Nov 2007 19:45:06 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, 10 of November 2007, Chris Friedhoff wrote:
> > please cc me, I'm not not subscribed to LKML
> > 
> > Hello,
> > 
> > with kernel 2.6.24-rc2 STD with s2disk suspends the system to disk, but
> > when I start the system and the suspended systemimage is loaded, it
> > fails to "activate" this suspended systemimage and continues after some
> > time with following the normal boot sequence.
> > 
> > I can sucessfully STD the system with the following sequence
> >   echo platform > /sys/power/disk
> >   echo disk > /sys/power/state
> > and when I start the laptop the suspended system is sucessfully
> > restored.
> > 
> > Both behaviors are reliable reproducable.
> 
> Thanks for the report.
> 
> > googling for >"Freezing of tasks failed" swapper< brought
> > "Nigel Cunningham - PID namespaces break initrd+hibernate combination?"
> > http://lkml.org/lkml/2007/11/4/140
> 
> Yes, this looks similarly.
> 
> > dmesg output:
> > <<snip>>
> > RAMDISK: ext2 filesystem found at block 0
> > RAMDISK: Loading 2000KiB [1 disk] into ram disk... done.
> > EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> > VFS: Mounted root (ext2 filesystem).
> > swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
> > swsusp: Basic memory bitmaps created
> > Clocksource tsc unstable (delta = -128791628 ns)
> > Syncing filesystems ... done.
> > Freezing user space processes ... (elapsed 0.00 seconds) done.
> > Freezing remaining freezable tasks ... 
> > Freezing of tasks failed after 20.00 seconds (1 tasks refusing to
> > freeze): task                PC stack   pid father
> > swapper       S c1835a88     0     1      0
> >        00000000 00000046 c0118c80 c1835a88 00000004 00000001 c011e875
> > 00000286 c01025a6 00000000 00000000 c1835b64 00000000 ffffffff c1835a90
> > 00000001 00000000 00000000 00000000 00000000 0000007b 00000000 c1835a90
> > c0118c80 Call Trace:
> >  [<c0118c80>] default_wake_function+0x0/0x10
> >  [<c011e875>] do_wait+0x335/0xac0
> >  [<c01025a6>] kernel_thread+0x96/0xb0
> >  [<c0118c80>] default_wake_function+0x0/0x10
> >  [<c011f031>] sys_wait4+0x31/0x40
> >  [<c04b7a23>] initrd_load+0x1b3/0x3a0
> >  [<c04b5108>] prepare_namespace+0x98/0x1b0
> >  [<c016090f>] sys_access+0x1f/0x30
> >  [<c04b47c6>] kernel_init+0x166/0x260
> >  [<c0103f4a>] ret_from_fork+0x6/0x1c
> >  [<c04b4660>] kernel_init+0x0/0x260
> >  [<c04b4660>] kernel_init+0x0/0x260
> >  [<c0104b8f>] kernel_thread_helper+0x7/0x18
> >  =======================
> > kthreadd      S 0000038f     0     2      0
> >        00000000 00000046 c0487790 0000038f c183ff1c 00000000 c012d81b
> > c012d7b0 00000000 00000000 c0104b8f 00000000 00000000 00000000 00000000
> > 00000000 00000000 
> > Call Trace:
> >  [<c012d81b>] kthreadd+0x6b/0xd0
> >  [<c012d7b0>] kthreadd+0x0/0xd0
> >  [<c0104b8f>] kernel_thread_helper+0x7/0x18
> >  =======================
> > ksoftirqd/0   S 00000000     0     3      2
> >        00000000 00000046 fffffffc 00000000 c0120f00 00000000 c0120f7a
> > c012d782 c012d740 00000000 00000000 c0104b8f c183ff3c 00000000 00000000
> > 00000000 00000000 00000000 
> > Call Trace:
> >  [<c0120f00>] ksoftirqd+0x0/0x80
> >  [<c0120f7a>] ksoftirqd+0x7a/0x80
> >  [<c012d782>] kthread+0x42/0x70
> >  [<c012d740>] kthread+0x0/0x70
> >  [<c0104b8f>] kernel_thread_helper+0x7/0x18
> > 
> > <<snip>>
> 
> Can you please attach your kernel configuration file to the bugzilla entry
> at http://bugzilla.kernel.org/show_bug.cgi?id=9345 ?
> 
> Thanks,
> Rafael


--------------------
Chris Friedhoff
chris@friedhoff.org
