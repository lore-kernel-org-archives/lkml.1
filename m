Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbYFSRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbYFSRCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYFSRCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:02:10 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:10605 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYFSRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:01:45 -0400
X-BigFish: VPS-45(zz1432R98dR4015M62a3L7efV1805Mzz10d3izzz32i6bh87i61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K2PZA6-02-MQU-01
Date: Thu, 19 Jun 2008 19:00:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Stephane Eranian <eranian@googlemail.com>
Subject: Re: [patch 1/2] x86: apic: Export symbols for extended interrupt
	LVT functions
Message-ID: <20080619170056.GI10019@erda.amd.com>
References: <20080213151811.804698000@amd.com> <20080213151841.520543000@amd.com> <20080213143256.54e9a3c7@laptopd505.fenrus.org> <20080214094036.GA16892@erda.amd.com> <20080214084749.2a936f85@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080214084749.2a936f85@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Jun 2008 17:00:57.0603 (UTC) FILETIME=[0B10AD30:01C8D22E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan,

do you see a way of how to get these EXPORT_SYMBOLs mainline? Better
use EXPORT_SYMBOL_GPL? Or is it common sense to add EXPORT_SYMBOLs to
mainline not until there are already use cases in the mainline?

At least the IBS symbol is needed for Perfmon but potentially also for
OProfile. This will allow the use of loadable Perfmon kernel modules,
especially if some lightwight Perfmon features are already upstream.

Also, APIC setup is more general and not Perfmon related. So I
think the Perfmon tree is not the right place to keep the code.

I don't know, if there is a use case for loadable MCE modules. We
could skip this, but as I said, code consistency...

Thanks,

-Robert

On 14.02.08 08:47:49, Arjan van de Ven wrote:
> > > > +EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
> > > 
> > > which modules would even consider using any of these?
> > > Doesn't sound like something we should export..
> > 
> > For IBS it is Perfmon. See here:
> > http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git;a=commit;h=7caef3e19d17349f869884f5adf7c9823e32ade7
> > 
> 
> perfmon doesn't seem to go anywhere lately, so realistically this chunk should be part of the perfmon tree.

[...]

> > MCE export has been added for consistency reasons to allow modules to
> > enable MCE.
> 
> no module does that right now, nor should it. MCE is really something the core kernel should do right?
> "consistency reasons" isn't "just export everything used or not", it's "oh this makes sense as part of a well
> thought out, generic consistent api". This one isn't./

[...]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

