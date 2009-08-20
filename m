Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZHTV7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZHTV7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932093AbZHTV7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:59:55 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:33508 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZHTV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:59:54 -0400
Date: Thu, 20 Aug 2009 15:59:54 -0600
From: Alex Chiang <achiang@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090820215954.GH13061@ldl.fc.hp.com>
References: <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box> <20090820212024.GG13061@ldl.fc.hp.com> <1250803577.2754.30.camel@sbs-t61.sc.intel.com> <4A8DC349.5060508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8DC349.5060508@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin <hpa@zytor.com>:
> On 08/20/2009 02:26 PM, Suresh Siddha wrote:
> > On Thu, 2009-08-20 at 14:20 -0700, Alex Chiang wrote:
> >> It turns out I need to rework my patch anyway because I need
> >> to think about the case where a user disables some cores in
> >> the BIOS, in which case my (fragile) table selection scheme
> >> falls apart.
> > 
> > These are the sort of reasons why we want topology detection
> > to be completely based on what cpuid instruction says and
> > nothing else.
> 
> I agree... if this ID is used for topology detection, we
> shouldn't replace it arbitrarily with information from BIOS
> just to hope that it matches the motherboard stencil.

Well, to be fair, in my patch, the phys_proc_ids remained
consistent for a given physical processor package.

That is, if all the cores in a socket initially started with
phys_proc_id X, they all ended up with phys_proc_id Y.
Additionally, no other cores in other sockets ended up with Y.
So in that sense, there was no real change in how we detected CPU
topology. All the core/thread/sibling ids remained correct and
unchanged.

Second, my patch wasn't sticking arbitrary information in from
BIOS; it was merely rearranging the existing phys_proc_ids.

> *Furthermore*, there is no reason why motherboard stencilAs are
> purely numeric... consider the rather obvious case of two rows
> of four CPUs; they may have CPU slots labelled A1, A2, A3, A4,
> B1, B2, B3, B4.  It might very well be the right thing to
> support arbitrary strings for platforms we recognize.

But yes, I do agree that this is a good point, and even here at
HP, we have other platforms with complex physical topologies.

Once you go down this path of thinking though, ACPI starts
looming, and that has other issues associated with it (in my
mind, mostly around the cleanliness of implementation as ACPI
starts poking its fingers everywhere).

> As such I think we should have a socket name field in both
> /proc/cpuinfo and sysfs.

Well, now we have 2 yeas (hpa and Suresh), 1 nay (Andi), and 1
"tell me what you'd like" (me ;)

/ac

