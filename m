Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZHTUy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZHTUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbZHTUyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:54:25 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:33894 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZHTUyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:54:25 -0400
Date: Thu, 20 Aug 2009 14:54:25 -0600
From: Alex Chiang <achiang@hp.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090820205425.GF13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com>:
> On Wed, 2009-08-19 at 14:02 -0700, Alex Chiang wrote:
> > I agree with you (although I thought that they should be
> > 0-based) but this quirk addresses a specific platform, where
> > I can assume certain things about the BIOS, etc.
> 
> What happens if for some reason, newer bios/newer cpu
> generations on this platform start having holes in the physical
> id space? We can't rule out these kind of changes and we don't
> want to go behind distros requesting fixes.
> 
> > I agree with you in general, but again, this is a specific
> > platform quirk where I have a good idea of what is a
> > supported configuration.
> 
> I am just nervous about future bios changes etc.

Ok, let's separate the two conversations happening here.

To me, the BIOS concerns are moot. I work closely with the BIOS
engineers for this platform; I have knowledge of future plans for
this BIOS and platform; and I know that they will not make any
changes that break the assumptions in my patch.

If they do, we will catch it during platform testing, file a bug,
and not let them release their BIOS until it's fixed. Does that
satisfy you? :)

So the algorithm for mapping an APIC ID to a physical/chassis ID
for this platform will not ever change.

Now on the other hand, the /interface/ that we present to the
user is the interesting conversation to have.

> > > Easiest route will be to add a new entry in /proc/cpuinfo
> > 
> > Well, if you remain unconvinced that fixing up 'physical id' is
> > the proper thing to do, here are some alternate proposals:
> > 
> > 	/proc/cpuinfo/chassis id
> > 	/sys/devices/system/cpu/$cpu/chassis id
> > 	/sys/devices/system/cpu/$cpu/topology/chassis id
> > 
> 
> I really like this alternate proposal. This is simple and straight
> forward to everyone.

I am leaning towards sysfs, and prefer:

 	/sys/devices/system/cpu/$cpu/chassis_id

How does that sound?

Thanks.

/ac

