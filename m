Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbYGTPpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbYGTPpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 11:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYGTPpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 11:45:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757138AbYGTPpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 11:45:06 -0400
Date: Sun, 20 Jul 2008 17:44:56 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Greg KH <gregkh@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Vivek Goyal <vgoyal@redhat.com>, kexec <kexec@lists.infradead.org>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
 trace_hardirqs_on_caller
Message-ID: <20080720174456.55e41e8b@kopernikus.site>
In-Reply-To: <20080720150341.7cd381c2@kopernikus.site>
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
	<20080720150341.7cd381c2@kopernikus.site>
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

* Bernhard Walle <bwalle@suse.de> [2008-07-20 15:03]:
> 
> Because I didn't know that interface. And because I don't see that
> interface on my two systems that I just checked. i386 and x86-64. What
> do I have to do to enable that interface?

That interface depends on CONFIG_MEMORY_HOTPLUG. But given to that
dependency list,

128 config MEMORY_HOTPLUG
129         bool "Allow for memory hot-add"
130         depends on SPARSEMEM || X86_64_ACPI_NUMA
131         depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
132         depends on (IA64 || X86 || PPC64 || SUPERH || S390)

that interface is off on *many* systems (i386, x86_64), so we can't rely
on that interface in kexec. I think on POWER it's much more common than
on PC architectures.



Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
