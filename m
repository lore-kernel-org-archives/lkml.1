Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbYGKJFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbYGKJFZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYGKJFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:05:16 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:7828 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYGKJFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:05:14 -0400
X-BigFish: VPS-14(z1039oz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U3WA-02-MQA-01
Date: Fri, 11 Jul 2008 11:04:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [x86, patch] turn x86 VISWS into a generic architecture
Message-ID: <20080711090457.GW7963@erda.amd.com>
References: <20080710170712.GA14583@elte.hu> <20080711083946.GU7963@erda.amd.com> <20080711085407.GB20987@elte.hu> <86802c440807110201u4ece646aw4d67a2630d653b33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440807110201u4ece646aw4d67a2630d653b33@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jul 2008 09:04:59.0304 (UTC) FILETIME=[32149280:01C8E335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.08 02:01:29, Yinghai Lu wrote:
> On Fri, Jul 11, 2008 at 1:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Robert Richter <robert.richter@amd.com> wrote:
> >
> >> On 10.07.08 19:07:12, Ingo Molnar wrote:
> >>
> >> [...]
> >>
> >> > diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
> >> > index 99d9f09..e515e8d 100644
> >> > --- a/arch/x86/pci/Makefile
> >> > +++ b/arch/x86/pci/Makefile
> >> > @@ -9,9 +9,7 @@ pci-y                               := fixup.o
> >> >  pci-$(CONFIG_ACPI)         += acpi.o
> >> >  pci-y                              += legacy.o irq.o
> >> >
> >> > -# Careful: VISWS overrule the pci-y above. The colons are
> >> > -# therefor correct. This needs a proper fix by distangling the code.
> >> > -pci-$(CONFIG_X86_VISWS)            := visws.o fixup.o
> >> > +pci-$(CONFIG_X86_VISWS)            += visws.o
> >>
> >> Ingo, if we turn this into generic code, we have to remove the
> >> subsys_initcall for this too. Otherwise subsystem initialization is
> >> running twice, in legacy.c and in visws.c.
> >
> > Ok. Mind sending a patch for this against tip/master? Both your changes
> > and the visws cleanups are all in there and are tested through on
> > typical hardware.
> >
> > (Also, there's the suggestion from Yinghai to first do the numa init.)
> 
> could change the numa.c to numaq.c too. that name is confusing..

Ok, I will send out patches that cover all this and also pci-y
removal.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

