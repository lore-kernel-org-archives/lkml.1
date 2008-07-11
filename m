Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbYGKIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbYGKIVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbYGKIVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:21:24 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:8937 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYGKIVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:21:22 -0400
X-BigFish: VPS-19(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U1VA-02-KEE-01
Date: Fri, 11 Jul 2008 10:20:43 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080711082042.GT7963@erda.amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu> <20080710195249.GB17255@uranus.ravnborg.org> <20080710195425.GB23322@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710195425.GB23322@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 08:20:45.0080 (UTC) FILETIME=[040A2180:01C8E32F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.08 21:54:25, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Thu, Jul 10, 2008 at 08:12:34PM +0200, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > * Robert Richter <robert.richter@amd.com> wrote:
> > > > 
> > > > > This patch series contains patches for tip/x86/unify-pci. It fixes 
> > > > > NUMA initialization code reflecting latest changes in tip/master. 
> > > > > Also there are build fixes and minor cleanups. Patch #5 is a cherry 
> > > > > pick that fixes build on UP systems. Code reboots for smp/nosmp, 
> > > > > acpi/noacpi, numaq, 32/64bit. It compiles for visws.
> > > > 
> > > > thanks Robert. Today i've eliminated the VISWS subarch which greatly 
> > > > simplified your series. I've picked up these two fixes:
> > > > 
> > > >  Robert Richter (2):
> > > >        x86/pci merge: fixing numaq initialization
> > > >        x86/pci: fix warnings in subsys_initcall functions
> > > 
> > > btw., this is how arch/x86/pci/Makefile looks like now in tip/master:
> > > 
> > > ----------------------------------------->
> > > pci-y                           := fixup.o
> > > pci-$(CONFIG_ACPI)              += acpi.o
> > > pci-y                           += legacy.o irq.o
> > > 
> > > pci-$(CONFIG_X86_VISWS)         += visws.o
> > > 
> > > pci-$(CONFIG_X86_NUMAQ)         += numa.o
> > > 
> > > obj-y                           += $(pci-y) common.o early.o
> > > obj-y                           += amd_bus.o
> > > <-----------------------------------------
> > 
> > So if I am not mistaken you can kill pci-y entirely:

Yes, but...

> > 
> > obj-y                           := fixup.o

... this is with a plus:

obj-y                           += fixup.o

> > obj-$(CONFIG_ACPI)              += acpi.o
> > obj-y                           += legacy.o irq.o
> > 
> > obj-$(CONFIG_X86_VISWS)         += visws.o
> > 
> > obj-$(CONFIG_X86_NUMAQ)         += numa.o
> > 
> > obj-y                           += common.o early.o
> > obj-y                           += amd_bus.o
> 
> ah, indeed :-) Very nice.
> 
> 	Ingo
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

