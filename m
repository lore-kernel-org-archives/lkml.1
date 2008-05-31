Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYFAOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYFAOqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYFAOpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:45:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4289 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752721AbYFAOpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:45:08 -0400
Date: Sat, 31 May 2008 23:17:50 +0200
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080531211749.GN5405@ucw.cz>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <20080527140440.GD5181@dirshya.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080527140440.GD5181@dirshya.in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The following RFC patch tries to implement scaled CPU utilisation
> > > statistics using APERF and MPERF MSR registers in an x86 platform.
> > > 
> > > The CPU capacity is significantly changed when the CPU's frequency is
> > > reduced for the purpose of power savings.  The applications that run
> > > at such lower CPU frequencies are also accounted for real CPU time by
> > > default.  If the applications have been run at full CPU frequency,
> > > they would have finished the work faster and not get charged for
> > > excessive CPU time.
> > > 
> > > One of the solution to this problem it so scale the utime and stime
> > > entitlement for the process as per the current CPU frequency.  This
> > > technique is used in powerpc architecture with the help of hardware
> > > registers that accurately capture the entitlement.
> > > 
> > 
> > there are some issues with this unfortunately, and these make it
> > a very complex thing to do. 
> > Just to mention a few:
> > 1) What if the BIOS no longer allows us to go to the max frequency for
> > a period (for example as a result of overheating); with the approach
> > above, the admin would THINK he can go faster, but he cannot in reality,
> > so there's misleading information (the system looks half busy, while in
> > reality it's actually the opposite, it's overloaded). Management tools
> > will take the wrong decisions (such as moving MORE work to the box, not
> > less)
> > 2) On systems with Intel Dynamic Acceleration technology, you can get
> > over 100% of cycles this way. (For those who don't know what IDA is;
> > IDA is basically a case where if your Penryn based dual core laptop is
> > only using 1 core, the other core can go faster than 100% as long as
> > thermals etc allow it). How do you want to deal with this?
> 
> Hi Arjan,
> 
> Thanks you for the inputs.  The above issues are very valid and our
> solution should be able to react appropriately to the above situation.
> 
> What we are proposing is a scaled time value that is scaled to the
> current CPU capacity.  If the scaled utilisation is 50% when the CPU
> is at 100% capacity, it is expected to remain at 50% even if the CPU's
> capacity is dropped to 50%, while the traditional utilisation value
> will be 100%.

time one-second-busy-loop should return close to one second. That's
current behaviour. You don't like it, but it is useful.

If you change it, that's called 'regression'.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
