Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYFMSS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYFMSS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbYFMSSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:18:18 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:7375 "EHLO
	mail64-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751506AbYFMSSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:18:17 -0400
X-BigFish: VPS-41(zz1432R98dR62a3L7efV1805Mzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0K2EYST-02-5F3-01
Date: Fri, 13 Jun 2008 20:16:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Glauber Costa <glommer@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] x86: Move PCI IO ECS code to x86/pci
Message-ID: <20080613181627.GH10019@erda.amd.com>
References: <20080603072550.GR23679@erda.amd.com> <1213294763-19566-2-git-send-email-robert.richter@amd.com> <5d6222a80806131002t4f5c6e54tee63d4ed0fc222a6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80806131002t4f5c6e54tee63d4ed0fc222a6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 13 Jun 2008 18:16:27.0711 (UTC) FILETIME=[98BDCCF0:01C8CD81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.06.08 14:02:46, Glauber Costa wrote:
> > diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> > index 5c2799c..15f505d 100644
> > --- a/arch/x86/pci/amd_bus.c
> > +++ b/arch/x86/pci/amd_bus.c
> > @@ -1,5 +1,9 @@
> >  #include <linux/init.h>
> >  #include <linux/pci.h>
> > +#include "pci.h"
> > +
> > +#ifdef CONFIG_X86_64
> 
> Please, don't do that. We are in an ongoing effort to cleanup the
> remaining ifdefs in x86 code, and adding more of them would just make
> it harder.
> If you really need it, move the common part to a separate file (avoid
> the _32 and _64 naming), and have it compiled conditionally on your
> architecture.

Ok, so what about shared code? Keep all this in separate files:
amd_bus.c, (amd_bus_32.c), amd_bus_64.c, (amd_bus.h)?

Is the strategy to avoid #ifdefs and instead use the flags in
Makefiles? My intention was to coalesce the files. Maybe I was wrong
here.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

