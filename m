Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbZE0LxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbZE0LxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 07:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759425AbZE0LxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 07:53:03 -0400
Received: from web32603.mail.mud.yahoo.com ([68.142.207.230]:20430 "HELO
	web32603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756293AbZE0LxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 07:53:01 -0400
Message-ID: <840102.98312.qm@web32603.mail.mud.yahoo.com>
X-YMail-OSG: 8zrLS0cVM1kK0ScG1p6wyoHyZjJvA11RXTPqUgiEbOczABzutBVUZNVy6Trx7M_FtCIjUmPvO4HeUZum.VotXlJIluRF6vVdWtO_0cpRLVhMkN4wRSsm_h3zWt5kyyNkLvfWTyoDJMFBB.N6G9T3z9nlSTw6T0_Sbb6pNr7Ihz7LYG1nYdq.xdH585M1NdbFFHrjGyrym4Bz8i.hrP6URT9nGAnwVOE_KSryhOnfF1LNJrSvRJ5oEfGla21wH0ge7VYnubUrjeq1DVGcDrQi_761pRcwfnNCVtMxDHqE1l5YD18RQSgjCwePRkPVAtpWpYwEWGbrX2LfR0U20Pm9Uvz6
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.43 YahooMailWebService/0.7.289.10
References: <1240977096.5478.3.camel@marge.simson.net> <20090429011755.c141c599.akpm@linux-foundation.org> <20090429120827.GI8633@ZenIV.linux.org.uk> <1241014725.15095.19.camel@marge.simson.net> <20090505154911.e0309a4f.akpm@linux-foundation.org> <1241585140.5196.28.camel@marge.simson.net> <957194.27869.qm@web32605.mail.mud.yahoo.com> <1241599065.18090.18.camel@marge.simson.net> <461911.6351.qm@web32603.mail.mud.yahoo.com> <20090526233102.b86e7f84.akpm@linux-foundation.org> <20090527112153.GE5816@parisc-linux.org>
Date: Wed, 27 May 2009 04:53:02 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, viro@ZenIV.linux.org.uk, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk,
       Kay Sievers <kay.sievers@vrfy.org>, shemminger@vyatta.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       mike miller <mike.miller@hp.com>
In-Reply-To: <20090527112153.GE5816@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Matthew Wilcox <matthew@wil.cx>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: Martin Knoblauch <knobi@knobisoft.de>; Mike Galbraith <efault@gmx.de>; viro@ZenIV.linux.org.uk; rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uks; Kay Sievers <kay.sievers@vrfy.org>; shemminger@vyatta.com; Jesse Barnes <jbarnes@virtuousgeek.org>
> Sent: Wednesday, May 27, 2009 1:21:53 PM
> Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
> 
> On Tue, May 26, 2009 at 11:31:02PM -0700, Andrew Morton wrote:
> > On Wed, 20 May 2009 03:22:28 -0700 (PDT) Martin Knoblauch 
> wrote:
> > 
> > > 
> > > ----- Original Message ----
> > > 
> > > > From: Mike Galbraith 
> > > > To: Martin Knoblauch 
> > > > Cc: Andrew Morton ; viro@ZenIV.linux.org.uk; 
> rjw@sisk.pl; linux-kernel@vger.kernel.org; tigran@aivazian.fsnet.co.uk
> > > > Sent: Wednesday, May 6, 2009 10:37:45 AM
> > > > Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> > > > 
> > > > On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:
> > > > 
> > > > >  just to bring this back to my problem :-)
> > > > 
> > > > Good idea :-)
> > > > 
> > > > >  Last week I reported that the "new" sysfs entry in /proc/mounts already 
> comes 
> > > > out of initrd. Does this ring a bell?
> > > > > 
> > > > > http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html
> > > > 
> > > > Nope, no bells.
> > > > 
> > > > The only thing I can suggest is that you try a bisection.
> > > > 
> > > >     -Mike
> > > 
> > >  OK, so I finally managed to bisect the issue down to the following commit. 
> Not much that I can say about it. Someone else suggested that it might all be a 
> question of timing. Might very well be. I will try it out on a system with a 
> different SCSI/RAID controller. The failing system has an "Smart Array 6i" 
> (cciss). "cciss", "ext3" and "jbd" are all modules coming from initrd.
> > > 
> > > |commit 1120f8b8169fb2cb51219d326892d963e762edb6
> > > |Author: Stephen Hemminger 
> > > |Date:   Thu Dec 18 09:17:16 2008 -0800
> > > |
> > > |    PCI: handle long delays in VPD access
> > > |
> > > |    Accessing the VPD area can take a long time.  The existing
> > > |    VPD access code fails consistently on my hardware. There are comments
> > > |
> > > |    Change the access routines to:
> > > |      * use a mutex rather than spinning with IRQ's disabled and lock held
> > > |      * have a much longer timeout
> > > |      * call cond_resched while spinning
> > > |
> > > |    Signed-off-by: Stephen Hemminger 
> > > |    Reviewed-by: Matthew Wilcox 
> > > |    Signed-off-by: Jesse Barnes 
> > > 
> > 
> > 
> 
> This is the first I've seen of this report ...
> 
> > So afacit what's happening is that the above change caused one of your
> > PCI devices to take a very long time to initialise, yes?  Was it the
> > CCISS driver?
> > 
> > If you add "printk.time=y" to the kernel boot command line then you'll
> > get timestamped boot messages which will make it easier to determine
> > where the time was consumed.  Adding `initcall_debug' to the boot line
> > will help us delve further into the delay, assuming that the offending
> > driver is build into vmlinux (which it might not be).
> 
> The two message logs posted show NTP starting up within a second of
> each other.  What was the problem again?
> 

 Just to recap. Starting with 2.6.29-rc1, /proc/mounts has two "sysfs" lines:

|none /sys sysfs rw,relatime 0 0
| /sys /sys sysfs rw,relatime 0 0

 The first of them already comes out of initrd, which somehow means that the explicit umount in the initrd/init script seems to fail. This is observable on a HP/DL380G4 with a "SmartArray 6" controller (cciss driver).

 As a result of the two lines, the hotplug/firmware script in my RHEL4.3 userspace failed to determine the "/sys" mountpoint, which in turn resulted in a 60 second timeout for each firmware load attempt, adding 6 minutes to the boot sequence (4 CPUs, 2 tg3s). I have since then just fixed the hotplug script to do "the right thing". Therefore you are not seeing a big difference in the two posted dmesg logs. The underlying issue remains.

 In a next step I managed to bisect the appearance of the second "sysfs" line down to the following commit:

|commit 1120f8b8169fb2cb51219d326892d963e762edb6
|Author: Stephen Hemminger <shemminger@vyatta.com>
|Date:   Thu Dec 18 09:17:16 2008 -0800
|
|    PCI: handle long delays in VPD access
|
|    Accessing the VPD area can take a long time.  The existing
|    VPD access code fails consistently on my hardware. There are comments
|
|    Change the access routines to:
|      * use a mutex rather than spinning with IRQ's disabled and lock held
|      * have a much longer timeout
|      * call cond_resched while spinning
|
|    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
|    Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
|    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

 The commit itself may just show a problem/bug elsewhere. It definitely changes locking and timing around PCI.

 Next, I tried to run an identically configured kernel on a different system (IBM/x3650 with aacraid). The problem was not observable. This now either points to CCISS, or leaves timing.

 Finally, today I built the ccsii driver into the kernel. It was previously modularized and loaded from initrd. The second "sysfs" line went away. But does this make cciss guilty? It is now loaded about 2 seconds earlier in the boot sequence, which is a big change in timing I guess.

 Enlighten me :-)

Cheers
Martin
