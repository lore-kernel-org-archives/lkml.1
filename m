Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIEMmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIEMmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYIEMmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:42:35 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:6649 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYIEMme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:42:34 -0400
X-BigFish: VPS-37(z518kz1432R98dR1805M179dR936fQ3117K19c2kzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6Q3AM-01-944-01
Date: Fri, 5 Sep 2008 14:42:03 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert commit e8aa4667baf74dfd85fbaab86861465acb811085
Message-ID: <20080905124203.GD6743@alberich.amd.com>
References: <20080904144657.GC15987@alberich.amd.com> <20080904153206.GB7120@elte.hu> <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809041812450.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Sep 2008 12:42:10.0951 (UTC) FILETIME=[D0AE1970:01C90F54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2008 at 06:14:38PM +0200, Thomas Gleixner wrote:
> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> 
> > 
> > * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > 
> > > This reverts commit e8aa4667baf74dfd85fbaab86861465acb811085
> > >  (x86: enable hpet=force for AMD SB400)
> > > 
> > > Since ATI/AMD decided not to support HPET on SB4xx it doesn't
> > > make sense to enable this unsupported feature.
> > > (I was not aware of this when submitting the quirk.)
> > > 
> > > If a system with SB4xx chipset provides an ACPI HPET table and does
> > > not boot, "nohpet" should be used as kernel parameter.
> > > 
> > > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > applied to tip/x86/urgent, thanks Andreas. I guess a system broke due to 
> > this commit?
> 
> Hmm, why do we remove something which needs to be force enabled by the
> user anyway ?  

> Is the HPET on these systems not working at all so the force enable
> code is useless ?

The current quirk is incomplete. Some more chipset fiddling has to be
done to enable HPET interrupts. I have a patch that would do this.
And from my tests it seems to work faultlessly.

But the official statement is that HPET is not supported on SB4XX.

Thus there are 2 alternatives:
(1) Remove the current (incomplete) quirk.
(2) Extent the quirk.
    But whoever forces HPET would use it on his own risk.

I decided to do (1) because it's safest.
Other opinions?


Regards,

Andreas


