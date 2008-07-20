Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbYGTNDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbYGTNDz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 09:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbYGTNDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 09:03:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:45735 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbYGTNDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 09:03:45 -0400
Date: Sun, 20 Jul 2008 15:03:41 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Greg KH <gregkh@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Vivek Goyal <vgoyal@redhat.com>, kexec <kexec@lists.infradead.org>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
 trace_hardirqs_on_caller
Message-ID: <20080720150341.7cd381c2@kopernikus.site>
In-Reply-To: <1216544462.9311.20.camel@nimitz>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	<200807190928.33978.m.kozlowski@tuxland.pl>
	<19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	<19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
	<20080719221723.GB5578@suse.de>
	<19f34abd0807191527u61c5ed61kffe2279c8d46915d@mail.gmail.com>
	<19f34abd0807191544nfd73be5nf7dde4b61992a7e8@mail.gmail.com>
	<20080719225817.GA6264@suse.de>
	<19f34abd0807191611y7cabf405iad307ba79591e04f@mail.gmail.com>
	<1216544462.9311.20.camel@nimitz>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2008-07-20 02:01]:
>
> It is possible that it could run later.  But, I do know that there are
> at least a couple of these tables (on various arches) that we toss out
> of memory or become unavailable later in boot.  
> 
> I do this this:
> 
>     sysfs: add /sys/firmware/memmap
> 
> is really being done at the wrong level.

I posted that patches multiple times. They were reviewed by the kdump
maintainer and by the kexec maintainer. Why didn't you mention it
*there* that this is the wrong way?

> I don't, for instance, see
> *any* reference to memory hotplug in these patches.

Right. The idea was to add memory hotplugging later. I decided to
create the patch series, get some review, and then fix the rest of the
systems that use memory hot-plugging. So, do you see a problem (in
theory) to add memory and remove memory in that sysfs interface? Of
course the code must be extended to handle modifications in the linked
list afterwards. Yes, I should have made that extension just after the
patch went into tip. Unfortunately, I didn't have time so far.

> Secondly, why don't we just modify the existing /sys/devices/system/memory

Because I didn't know that interface. And because I don't see that
interface on my two systems that I just checked. i386 and x86-64. What
do I have to do to enable that interface?

Does that interface export the *used* memory or just export the memory
that is available? Because exactly that was the reason why I made that
modification -- because kexec needs to know the *available* memory even
if that memory is disabled via 'memmap' or 'mem' command line
parameters.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
