Return-Path: <linux-kernel-owner+w=401wt.eu-S1753789AbYCLPpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbYCLPpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 11:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYCLPph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 11:45:37 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:23195 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYCLPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 11:45:36 -0400
Date: Wed, 12 Mar 2008 09:45:35 -0600
From: Alex Chiang <achiang@hp.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: lenb@kernel.org, linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Create 'slot' sysfs attribute
	in/sys/devices/system/cpu/cpuN/topology/
Message-ID: <20080312154535.GB9996@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Luck, Tony" <tony.luck@intel.com>, lenb@kernel.org,
	linux-ia64@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080310222735.GA22619@ldl.fc.hp.com> <1FE6DD409037234FAB833C420AA843ECC8960D@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECC8960D@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luck, Tony <tony.luck@intel.com>:
> > A while back, I submitted a patch to expose the value of the _SUN
> > method for CPUs. On ia64, the "physical id" field in
> > /proc/cpuinfo isn't sufficient for some legacy HP ia64 platforms,
> > as they do not have a modern SAL or PAL.
> 
> Do these legacy systems with ancient SAL/PAL actually support
> processor hot plug?

No, they do not; that was simply the most convenient / obvious
example I could think of for someone reading changelogs a few
years later and wondering why we created this sysfs attribute.

A real world example would be HP managability software keeping
track of CMC/CPE data for CPUs over a long period of time for the
purpose of doing long-term failure analysis.

This software can already grab a bunch of info from IPMI, such as
CPU serial number, date code, physical location, but cannot
correlate it to the kernel's idea of logical CPU number and
physloc.

Having the kernel expose the physical slot ties it all together.

This example is something any vendor selling higher level
managability software might want to do, and specifically HP wants
to do it to take care of our customers who have large deployments
of these legacy systems.

Hopefully that is enough justification to warrant at least
looking at the patch and telling me why it sucks. ;)

> Perhaps this next rant is beyond the scope of Linux architecture
> and more on overall systems useabilty.  It is just asking for
> trouble to print a message on the console telling the user to go
> pull out the board in "slot 2".  Do the slot numbers count from
> "0" or from "1"?  Are they numbered left-to-right or right-to-left?
> What if the rack is non-standard so the system was rotated 90
> degrees?  Now are they numbered top-to-bottom or bottom-to-top.

Well, at least for HP ia64 machines, we have lots of
silk-screening on the backplane, as well as pretty diagrams on
chassis covers, and we took care in making sure our what our
firmware matches up with those pictures.

But in general, I like the idea of das blinkenlights too. :)

> Best idea is to have a (blinking) (red) light on the board and
> instruct the operator to pull out the board with the fail-light
> (but even then a red-green colour blind operator will still
> mess it up for you and pull the wrong board :-)

Heh, then just make the failure light either blink (for failure)
or not blink (default). Then as long as the operator can detect
lumens, he/she would just be able to pull the blinky board. :)

Thanks.

/ac

