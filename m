Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXDKFXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXDKFXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXDKFXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:23:51 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:55451 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161202AbXDKFXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:23:50 -0400
Date: Tue, 10 Apr 2007 22:20:07 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Adam Belay <abelay@novell.com>, Andi Kleen <ak@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, lenb@kernel.org
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070411052007.GA24056@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <653FFBB4508B9042B5D43DC9E18836F539ADFB@scsmsx415.amr.corp.intel.com> <200704091940.53439.rjw@sisk.pl> <1176249569.32554.229.camel@localhost.localdomain> <20070411001513.GA2975@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411001513.GA2975@linux-os.sc.intel.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venki,

On Tue, Apr 10, 2007 at 05:15:14PM -0700, Venki Pallipadi wrote:
> > > x86-64 expects all idle handlers to enable interrupts before returning from
> > > idle handler. This is due to enter_idle(), exit_idle() races. Make
> > > cpuidle_idle_call() confirm to this when there is no pm_idle_old.
> > > 
> > > Also, cpuidle look at the return values of attch_driver() and set
> > > current_driver to NULL if attach fails on all CPUs.
> > 
> > My vote would be to instead remove enter_idle() and exit_idle() from
> > x86-64, just as was done with i386.  Performance monitoring
> > infrastructure shouldn't be interfering with the idle interrupt
> > delivery, as that could only hurt performance...  Besides, there's
> > probably a better way of doing this than an idle notifier anyway.
> > 
> 
> Agreed. I did not like local_irq_enable() in cpuidle either, but added it
> anyway as it was a corner case when cpuidle is active and no driver is
> active and not a common case. I thought we will have it as a bandaid solution
> until enter_idle, exit_idle is around.
> 
> Andi/Stephane: What are the plans around enter_idle exit_idle in x86-64.
> Is it still being used by perfmon for x86-64 arch?
> 
The next kernel patch for Perfmon will not make use of the idle notification
anymore on any platform.

-- 
-Stephane
