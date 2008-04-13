Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYDMNxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYDMNxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757052AbYDMNx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:53:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbYDMNx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:53:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.25-rc6 regression - hang on resume
Date: Sun, 13 Apr 2008 15:53:14 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207985262.4372.3.camel@localhost> <20080413085343.GD8949@elf.ucw.cz>
In-Reply-To: <20080413085343.GD8949@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131553.15573.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 13 of April 2008, Pavel Machek wrote:
> On Sat 2008-04-12 09:27:42, Soeren Sonnenburg wrote:
> > On Fri, 2008-04-11 at 23:04 +0200, Pavel Machek wrote:
> > > On Fri 2008-04-04 08:31:29, Soeren Sonnenburg wrote:
> > > > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > > > > The following report is on the current list of known regressions
> > > > > from 2.6.24.  Please verify if the issue is still present in the
> > > > > mainline.
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10319
> > > > > Subject		: 2.6.25-rc6 regression - hang on resume
> > > > > Submitter	: Soeren Sonnenburg <kernel@nn7.de>
> > > > > Date		: 2008-03-25 04:44 (10 days old)
> > > > 
> > > > Yes. The machine resumes and display stays black using s2ram -f -p
> > > > (blindly typing reboot etc on keyboard does what is expected). However
> > > > display comes back on 2.6.24.
> > > 
> > > Could you get us any debugging output from s2ram? Or maybe even strace
> > > it in both working and broken case, and comparing them? (You may want
> > > to disable randomization so that results are comparable).
> > 
> > I did on 2.6.24
> > 
> > strace -ff s2ram >s2ram24.trace 2>&1
> > 
> > and .25
> > 
> > ???strace -ff s2ram >s2ram25.trace 2>&1
> > 
> > with the .24 bringing the display back and .25 not. Files are here
> > 
> > http://nn7.de/debugging/s2ram24.trace.bz2
> > ???http://nn7.de/debugging/s2ram25.trace.bz2
> 
> Hmm: 
> 
> /sys/bus/pci/devices/0000:00:1b.0/irq
> 
> contains 21 in one case and 22 in another... as do other
> interrupts. Is that expected? Can you post /proc/interrupts for both
> versions?
> 
> Hmm, big part of trace is:
> 
> vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> implemented)
> vm86old(0xb7f76c8c)                     = -1 ENOSYS (Function not
> implemented)
> 
> ...I wonder why we do it so many times?
> 
> And here's the difference. .25 says:
> 
> vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> implemented)
> vm86old(0xb809ac8c)                     = -1 ENOSYS (Function not
> implemented)
> Error: something went wrong performing real mode call
> open("/sys/class/graphics",
> O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY|0x80000) = -1 ENOENT (No
> such file or directory)
> open("/dev/tty", O_RDWR|O_LARGEFILE)    = 6
> ioctl(6, KDGKBTYPE, 0xbfae8887)         = 0
> 
> ...can you perhaps add printf-s to s2ram to find out what changed?

Well, that looks suspiciously similar to
http://bugzilla.kernel.org/show_bug.cgi?id=10155 .

Thanks,
Rafael
