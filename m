Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZD2Dvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZD2Dvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZD2Dvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:51:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:59908 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752455AbZD2Dvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:51:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18smgcqOmQsanTAQxPMODDrQi7vTe+9C7Cb06WR+F
	pMaCZ1iKkY2/p3
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Knoblauch <knobi@knobisoft.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090428182837.62c51f26.akpm@linux-foundation.org>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	 <20090428182837.62c51f26.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Apr 2009 05:51:36 +0200
Message-Id: <1240977096.5478.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 18:28 -0700, Andrew Morton wrote: 
> On Fri, 24 Apr 2009 05:45:19 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:
> 
> > 
> > 
> >  OK, I just found the reason for both intel-ucode and tg3 failures. Apparently between 2.6.28 and 2.6.29 the mount of sysfs has subtely changed from:
> > 
> > /sys /sys sysfs rw 0 0
> > 
> > to:
> > 
> > none /sys sysfs rw,relatime 0 0
> 
> I assume that you're referring to the contents of /proc/mounts?
> 
> >  The "none" breaks the RHEL-4 provided hotplug script "firmware.agent" when it tries to parse the mount point for "/sys". As a result, the firmware loading is never properly finished and the driver(s) just timeout on the value  in /sys/class/firmware/timeout. Bingo. Simple fix in user-pace possible - cool down Martin :-)
> > 
> > Questions remains: was this intentional? It breaks existing userspace and should therefore be considered a regression - right? On the other hand, it will never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets backported. Any ideas?
> 
> afaik that was unintentional and was probably a mistake.
> 
> I wonder how we did that.

<paste>
> [hotplug]# grep sysfs /proc/mounts
> none /sys sysfs rw,relatime 0 0
> /sys /sys sysfs rw,relatime 0 0

﻿(I wonder how the heck that is accomplished)



