Return-Path: <linux-kernel-owner+w=401wt.eu-S1161139AbXDJX5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161139AbXDJX5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161137AbXDJX5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:57:54 -0400
Received: from peabody.ximian.com ([130.57.169.10]:36051 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161139AbXDJX5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:57:53 -0400
Subject: Re: 2.6.21-rc6-mm1
From: Adam Belay <abelay@novell.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org
In-Reply-To: 20070410222009.GA26607@linux-os.sc.intel.com
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com>
	 <200704091940.53439.rjw@sisk.pl>
	 20070410222009.GA26607@linux-os.sc.intel.com
Content-Type: text/plain
Date: Tue, 10 Apr 2007 19:59:29 -0400
Message-Id: <1176249569.32554.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 15:20 -0700, Venki Pallipadi wrote:
> On Mon, Apr 09, 2007 at 07:40:52PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 9 April 2007 18:14, Pallipadi, Venkatesh wrote:
> > > 
> > > >-----Original Message-----
> > > >From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
> > > >Sent: Monday, April 09, 2007 9:08 AM
> > > >To: Andrew Morton
> > > >Cc: linux-kernel@vger.kernel.org; randy.dunlap@oracle.com; 
> > > >lenb@kernel.org; Pallipadi, Venkatesh
> > > >Subject: Re: 2.6.21-rc6-mm1
> > > >
> > > >On Sunday, 8 April 2007 23:35, Andrew Morton wrote:
> > > >> 
> > > >> 
> > > >ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2
> > > >.6.21-rc6/2.6.21-rc6-mm1/
> > > >> 
> > > >> 
> > > >> - Lots of x86 updates
> > > >> 
> > > >> - This is a 25MB diff against mainline, which is rather large.
> > > >
> > > >The cpuidle thing tends to hang my x86-64 machines on boot.
> > > >
> > > 
> > > Hi Rafael,
> > > 
> > > At what point during boot does it hang?
> > 
> > When mounting the root filesystem.  It hangs completely, even the magic SysRq
> > doesn't work
> > 
> 
> Rafael: Below patch should fix the hang.
> Len: Please include this patch in acpi-test.
> 
> Thanks,
> Venki
> 
> Prevent hang on x86-64, when ACPI processor driver is added as a module on
> a system that does not support C-states.
> 
> x86-64 expects all idle handlers to enable interrupts before returning from
> idle handler. This is due to enter_idle(), exit_idle() races. Make
> cpuidle_idle_call() confirm to this when there is no pm_idle_old.
> 
> Also, cpuidle look at the return values of attch_driver() and set
> current_driver to NULL if attach fails on all CPUs.

My vote would be to instead remove enter_idle() and exit_idle() from
x86-64, just as was done with i386.  Performance monitoring
infrastructure shouldn't be interfering with the idle interrupt
delivery, as that could only hurt performance...  Besides, there's
probably a better way of doing this than an idle notifier anyway.

-Adam


