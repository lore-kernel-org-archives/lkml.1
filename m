Return-Path: <linux-kernel-owner+w=401wt.eu-S965795AbXJSGue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965795AbXJSGue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 02:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762666AbXJSGuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 02:50:22 -0400
Received: from www.tglx.de ([62.245.132.106]:47744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbXJSGuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 02:50:19 -0400
Date: Fri, 19 Oct 2007 08:50:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlos Corbacho <cathectic@slackadelic.com>
cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: nVidia HPET force enable - merge requirements? (resend)
In-Reply-To: <200710190423.31714.cathectic@slackadelic.com>
Message-ID: <alpine.LFD.0.9999.0710190847500.22770@localhost.localdomain>
References: <200710190423.31714.cathectic@slackadelic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Carlos Corbacho wrote:
> Back in April, Mikko posted a patch to force enable the HPET on some nVidia 
> chipsets:
>
> A) There is now a force_hpet boot parameter in the x86 tree (mm branch) 
> (rather than relying on the solution in the earlier patches of a config 
> option).

There is still a config option for hpet. the hpet=force boot param is
there to allow force enable hpet for not documented chip set features.
 
> B) On the other hand, the force-quirk's are going into quirks.c, whilst 
> Mikko's patch requires PCI scanning in early_quirks.c (could the PCI scanning 
> be done in early_quirks.c and the actual HPET enabling handled in quirks.c 
> later - or if not, could this early quirk play be made to obey the force_hpet 
> boot option)?

It's not necessary to scan in early_quirks.c at all. The force hpet
code handles the late DECLARE_PCI_FIXUP_HEADER() based detection just
fine.

So if there are working quirks, please refactor them analogous to the
existing ones in quirks.c.

All undocumented chipset poking needs to be protected by the
hpet=force boot option, so the default is not to do scan for it.

Thanks,

        tglx
