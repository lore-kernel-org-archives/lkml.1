Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbXH1KUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbXH1KUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXH1KUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:20:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49841 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXH1KUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:20:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Date: Tue, 28 Aug 2007 12:30:40 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, vatsa@in.ibm.com,
       zwane@arm.linux.org.uk, kernel list <linux-kernel@vger.kernel.org>,
       satyam@infradead.org, akinobu.mita@gmail.com, ashok.raj@intel.com,
       ego@in.ibm.com, rusty@rustcorp.com.au
References: <20070827104350.GA2073@elf.ucw.cz> <200708272359.32484.rjw@sisk.pl> <20070827215822.GH3398@elf.ucw.cz>
In-Reply-To: <20070827215822.GH3398@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281230.41774.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 27 August 2007 23:58, Pavel Machek wrote:
> On Mon 2007-08-27 23:59:31, Rafael J. Wysocki wrote:
> > On Monday, 27 August 2007 23:32, Pavel Machek wrote:
> > > On Mon 2007-08-27 22:36:57, Jeff Chua wrote:
> > > > On 8/27/07, Pavel Machek <pavel@ucw.cz> wrote:
> > > > > On Mon 2007-08-27 12:43:50, Pavel Machek wrote:
> > > > > > Hi!
> > > > > >
> > > > > > Trying to do few onlines/offlines reliably hangs my machine (thinkpad
> > > > > > x60, i386 architecture).
> > > > 
> > > > I just 3 cycles of on-line/off-line on 2.6.23-rc3 on ThinkPad x60s,
> > > > and my system still survives.
> > > 
> > > Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> > > so cycles at one point.
> > > 
> > > ...or maybe difference is in the .config, or maybe I broken something
> > > in my kernel sources....
> > 
> > Well, something seems to be wrong with the CPU hotplug, but it's insanely
> > difficult to reproduce on my boxes.
> > 
> > I bet on one of the notifiers blocking while waiting on a frozen task.
> 
> It happens reliably for me, with this script... and randomly, when I
> just echo 0/1 > online from commandline... so it should not be
> anything with the frozen tasks.

That suggests the CPU hotplug just deadlocks internally.

Can you put some printk's into _cpu_down() and see where exactly it hangs?

> echo test > /sys/power/disk
> echo disk > /sys/power/state
> 
> reliably hangs on resume in the attached script. It works ok with
> nosmp.

Which step hangs it?  Or is it at random?

Rafael


> #!/bin/bash
> killall klogd
> 
> echo -n "testing refrigerator (testproc)..."
> echo testproc > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing drivers (test)..."
> echo test > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing swsusp (reboot)..."
> echo reboot > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing s2ram..."
> s2ram
> echo "okay"
> 
> sleep 2
> echo -n "testing swsusp (shutdown)..."
> echo shutdown > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing swsusp (platform)..."
> echo platform > /sys/power/disk
> echo disk > /sys/power/state
> echo "okay"
> 
> sleep 2
> echo -n "testing s2ram..."
> s2ram
> echo "okay"
>  
> 

-- 
"Premature optimization is the root of all evil." - Donald Knuth
