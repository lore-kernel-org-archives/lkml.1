Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYGKInq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYGKInq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYGKInh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:43:37 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:17850 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYGKIng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:43:36 -0400
X-BigFish: VPS-19(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U2WC-02-LL7-01
Date: Fri, 11 Jul 2008 10:43:22 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] x86/pci: patches for tip/x86/unify-pci
Message-ID: <20080711084322.GV7963@erda.amd.com>
References: <1215709106-9182-1-git-send-email-robert.richter@amd.com> <20080710171721.GA19737@elte.hu> <20080710181234.GA32174@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080710181234.GA32174@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 08:43:24.0231 (UTC) FILETIME=[2E281D70:01C8E332]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.07.08 20:12:34, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Robert Richter <robert.richter@amd.com> wrote:
> > 
> > > This patch series contains patches for tip/x86/unify-pci. It fixes 
> > > NUMA initialization code reflecting latest changes in tip/master. 
> > > Also there are build fixes and minor cleanups. Patch #5 is a cherry 
> > > pick that fixes build on UP systems. Code reboots for smp/nosmp, 
> > > acpi/noacpi, numaq, 32/64bit. It compiles for visws.
> > 
> > thanks Robert. Today i've eliminated the VISWS subarch which greatly 
> > simplified your series. I've picked up these two fixes:
> > 
> >  Robert Richter (2):
> >        x86/pci merge: fixing numaq initialization
> >        x86/pci: fix warnings in subsys_initcall functions
> 
> btw., this is how arch/x86/pci/Makefile looks like now in tip/master:
> 
> ----------------------------------------->
> pci-y                           := fixup.o
> pci-$(CONFIG_ACPI)              += acpi.o
> pci-y                           += legacy.o irq.o
> 
> pci-$(CONFIG_X86_VISWS)         += visws.o
> 
> pci-$(CONFIG_X86_NUMAQ)         += numa.o
> 
> obj-y                           += $(pci-y) common.o early.o
> obj-y                           += amd_bus.o
> <-----------------------------------------
> 
> it's _really_ clean now, and we dont have those weird overrides anymore. 
> Both VisWS and NUMAQ are now two straightforward runtime PCI overrides - 
> not build-time complications. Much more maintainable i think.

Yes, it really looks nice now.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

