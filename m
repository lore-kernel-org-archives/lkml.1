Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbZHNT1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbZHNT1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbZHNT1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:27:31 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:27984 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbZHNT1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:27:30 -0400
Date: Fri, 14 Aug 2009 13:27:30 -0600
From: Alex Chiang <achiang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090814192730.GA6431@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com>:
> On Fri, 2009-08-14 at 09:36 -0700, Alex Chiang wrote:
> > As systems become larger and more complex, it is not always possible
> > to assume that an APIC ID maps directly to a given physical slot.
> > 
> > From a UI point-of-view, it's nice if the 'physical id' field in
> > /proc/cpuinfo matches the silk-screening or labelling on the system
> > chassis.
> > 
> > Add a quirk that allows oddball platforms to ensure that what the kernel
> > displays in /proc/cpuinfo matches the physical reality.
> 
> Alex, Does it makes sense to add a new entry in /proc/cpuinfo rather
> than overloading the 'physical id' by modifying phys_proc_id.

Hm, I'm not entirely sure about that, for two reasons.

First (and this is the weaker reason), I'd prefer not to keep
adding new fields to /proc/cpuinfo if we can help it, as it just
makes for a continually more complicated ABI/API for userspace.

Second, I guess I'm not sure what else 'physical id' /should/
represent. I'm willing to be corrected on this point, so if I'm
wrong, just call it simple ignorance. :)

> That way, even if there is a mis-match between the bios and the
> OS fixup tables, we won't screw up other topology setup etc in
> the kernel that are dependent on the phys_proc_id.

My quick grep earlier led me to believe that as long as the
phys_proc_ids were /consistent/ then it didn't seem to matter
what their /values/ were.

In other words, my patch simply says, "all cores that had
phys_proc_id X now have phys_proc_id Y". All the cores on a
physical package have identical phys_proc_ids, and cores on a
different physical package do /not/ collide.

But again, that just might be my ignorance again. If we do indeed
care about the values of phys_proc_ids, please let me know and
I'd be happy to rework the patch.

Thanks.

/ac

