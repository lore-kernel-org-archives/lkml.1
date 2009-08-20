Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZHTVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZHTVUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZHTVUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:20:24 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:31648 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZHTVUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:20:24 -0400
Date: Thu, 20 Aug 2009 15:20:24 -0600
From: Alex Chiang <achiang@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090820212024.GG13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820210342.GC29994@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org>:
> > I am leaning towards sysfs, and prefer:
> > 
> >  	/sys/devices/system/cpu/$cpu/chassis_id
> > 
> > How does that sound?
> 
> I would prefer to simply use the existing physical id for this
> like in your original patch.  We already have a bewildering zoo
> of different CPU IDs, no need to increase the confusion even
> more.

This was my initial instinct as well, and was why I was trying to
find out the original intent of "physical id". It seemed
unambiguous to me, but I was trying to figure out what history
(if any) there was around its semantics.

Since "physical id" is basically a made-up field (i.e., isn't
represented directly in cpuid instruction), it does seem like the
appropriate place for any quirky platforms to hook into if
necessary.

> Incidentially mcelog already knows how to use physical ID for this,
> would need to be changed for a new sysfs interface

There is probably a lot of userspace stuff that looks at physical
id that would need to be taught about a new interface.

It turns out I need to rework my patch anyway because I need to
think about the case where a user disables some cores in the
BIOS, in which case my (fragile) table selection scheme falls
apart.

But I would like to get some agreement/guidance about how we
end up presenting the information to the user.

Thanks.

/ac

