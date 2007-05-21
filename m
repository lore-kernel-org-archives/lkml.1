Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbXEUCIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbXEUCIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 22:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbXEUCIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 22:08:05 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:60035 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXEUCID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 22:08:03 -0400
Date: Mon, 21 May 2007 11:05:09 +0900
From: Mattia Dongili <malattia@linux.it>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Message-ID: <20070521020508.GA3484@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home> <200705201138.05146.david-b@pacbell.net> <20070521004119.GA3103@inferi.kami.home> <200705201822.24138.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705201822.24138.david-b@pacbell.net>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-3 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 06:22:23PM -0700, David Brownell wrote:
> On Sunday 20 May 2007, Mattia Dongili wrote:
> > 
> > $ cat /proc/acpi/wakeup
> > Device	S-state	  Status   Sysfs node
> > PWRB	  S4	*enabled   
> > S1F0	  S4	 disabled  
> > S1F1	  S4	 disabled  
> > S1F2	  S4	 disabled  
> > S1F3	  S4	 disabled  
> > S1F4	  S4	 disabled  
> > S1F5	  S4	 disabled  
> > S1F6	  S4	 disabled  
> > S1F7	  S4	 disabled  
> > TLAN	  S3	 disabled  pci:0000:07:00.0
> > DLAN	  S3	 disabled  
> > S6F0	  S4	 disabled  
> > S6F1	  S4	 disabled  
> > S6F2	  S4	 disabled  
> > S6F3	  S4	 disabled  
> > S6F4	  S4	 disabled  
> > S6F5	  S4	 disabled  
> > S6F6	  S4	 disabled  
> > S6F7	  S4	 disabled  
> > USB1	  S3	 disabled  pci:0000:00:1d.0
> > USB2	  S3	 disabled  pci:0000:00:1d.1
> > USB3	  S3	 disabled  pci:0000:00:1d.2
> > USB4	  S3	 disabled  pci:0000:00:1d.3
> > USB7	  S3	 disabled  pci:0000:00:1d.7
> > SLT0	  S4	 disabled  
> > LANC	  S3	 disabled  
> > EC0	  S5	 disabled  
> 
> That's strangely busy ... what ARE all those devices?  :)

the S[16]F* are tons of acpi devices... don't know what they are, they
are attached to the PCI-E port
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
if you're interested the DSDT is here:
http://www.linux.it/~malattia/sony-laptop/DSDT.sz72b.type3.dsl

> But only the PCI ones -- or certain devices connected to USB
> root hubs -- could be affected by that patch.
> 
> So another experiment you could do, if you want faster info
> than "git bisect" can provide, is building drivers for those
> PCI devices as modules (ehci-hcd, uhci-hcd, sky2) and then
> finding which one causes the trouble by removing them before
> STR.

it's ehci-hcd! and apart from the fact that removing it causes a BUG in
cpufreq no the system stays correctly asleep when suspended.

...
> > > My suspicion, based on the dmesg and seeing what drivers actually
> > > try to enable wakeup, would be the 'sky2' driver.  The other two
> > 
> > FWIW the sky2 is never functional upon resume, I need to ifdown, rmmod,
> > modprobe and ifup again to get some networking...
> 
> Try "rmmod sky2" *before* suspend, to see if that matters.
> 
> Also "rmmod uhci-hcd", which will keep USB from doing anything
> with that biometric thingie.
> 
> I suspect one or the other of those will be the issue.

very close :)
-- 
mattia
:wq!
