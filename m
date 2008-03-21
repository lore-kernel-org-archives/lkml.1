Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbYCUXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbYCUXTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbYCUXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:08:13 -0400
Received: from xes-mad.com ([216.165.139.214]:37681 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690AbYCUXIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:08:10 -0400
X-Greylist: delayed 641 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2008 19:08:10 EDT
Subject: Re: [PATCH 3/3] EDAC Add e752x parameter for sysbus_parity
	selection
From: Peter Tyser <ptyser@xes-inc.com>
To: Doug Thompson <norsk5@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>
In-Reply-To: <920687.59522.qm@web50104.mail.re2.yahoo.com>
References: <920687.59522.qm@web50104.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Fri, 21 Mar 2008 17:56:47 -0500
Message-Id: <1206140207.4490.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +
> > > +	/* Allow module paramter override, else see if CPU supports parity */
> > > +	if (sysbus_parity != -1) {
> > > +		enable = sysbus_parity;
> > > +	} else if (cpu_id[0] &&
> > > +		   ((strstr(cpu_id, "Pentium") && strstr(cpu_id, " M ")) ||
> > > +		    (strstr(cpu_id, "Celeron") && strstr(cpu_id, " M ")) ||
> > > +		    (strstr(cpu_id, "Core") && strstr(cpu_id, "Duo")))) {
> > > +		e752x_printk(KERN_INFO, "System Bus Parity not "
> > > +			     "supported by CPU, disabling\n");
> > > +		enable = 0;
> > > +	}
> > 
> > Is that the best way of working out whether the CPU supports system bus
> > parity?  We do have cpu capability infrastructure in x86 core and I'd have
> > thought it would be better for x86 core to work this out, set the suitable
> > flag and have clients (ie: EDAC) test that flag?
> > 

The above implementation was the only way I could think of to
dynamically determine if hardware supported system bus parity at
runtime.  I agree that adding a new x86 cpu capability flag for system
bus parity support would be an ideal way to support this feature for use
by subsystems such as EDAC.  However, there are a whole lot of possible
x86 CPU/Northbridge combinations and I could think of no clean way to
easily determine which of those combinations do or don't support system
bus parity.  The logic needed to compare the incredibly large number of
CPU and Northbridge combinations seems rather daunting...

The current patch was manageable in that only a few CPU/Northbridge
combinations needed to be accounted for and a module parameter would
allow for a manual override if necessary.

If others have suggestions as far as a more generic or generally cleaner
approach, I'd be happy to implement and test.

