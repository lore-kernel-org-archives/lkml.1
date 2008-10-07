Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYJGFcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYJGFcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 01:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYJGFcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 01:32:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33820 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYJGFcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 01:32:05 -0400
Date: Tue, 7 Oct 2008 07:38:08 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jason Vas Dias <jason.vas.dias@gmail.com>
Subject: Re: [PATCH] x86 ACPI: Blacklist two HP machines with buggy BIOSes (Re: 2.6.27-rc8+ - first impressions)
Message-ID: <20081007053808.GB20740@one.firstfloor.org>
References: <200810060029.42471.rjw@sisk.pl> <20081006062235.GA2808@amd.corenet.prv> <200810061159.30103.rjw@sisk.pl> <alpine.LFD.2.00.0810060749570.3208@nehalem.linux-foundation.org> <20081006150055.GA16930@elte.hu> <alpine.LFD.1.10.0810061815060.10470@ftp.linux-mips.org> <87tzbpmocm.fsf@basil.nowhere.org> <alpine.LFD.1.10.0810062227100.10470@ftp.linux-mips.org> <20081006231002.GN3180@one.firstfloor.org> <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810070142060.10470@ftp.linux-mips.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 02:35:01AM +0100, Maciej W. Rozycki wrote:
> 
> > > It's not that we are unresponsive or do not take 
> > > responsibility for our bugs, is it?
> > 
> > These workarounds are not for mainline kernels but for specific
> > distribution releases (as in "fixes SLES/RHEL x.y" instead of 
> > "fixes 2.6.xy")
> 
>  I am happy to fix any bugs I introduced myself (as much as one can be 
> happy about mistakes once they have discovered they made them that is) and 
> certainly have a look into other Linux bugs by request of any vendor of a 
> Linux distribution made on behalf of a hardware manufacturer.
> 
>  OTOH I do not feel responsible even a little bit for someone else's bugs 
> like those of BIOS developers.  Though I will certainly consider providing 
> them with any assistance needed to get things related to Linux resolved in 
> a best possible way if they ask nicely.

To be honest I think you have a unrealistic approach to this.
That is not how it works.

For the BIOS developers OS are like some piece of random hardware
ot a OS developer. If something doesn't work and if they care
they will add a workaround. Just as the OS developer adds a workaround
for the hardware issue. And yes workarounds are typically not pretty.
And sometimes the workaround come later back to bite someone That is what 
happened here. But they still have to support the old releases if they 
worked before, otherwise they got a regression too.

Using a PCI ID quirk to disable the workaround is a reasonable
approach, although it has its issues too.

Also calling the workaround a BIOS bug is just unfair in this case. It really
isn't. 

> > >  Well, perhaps, but the thermal trip point phenomenon seems unique to this 
> > > family of systems.  The other aspects of the problem do not really matter 
> > > anymore as we seem to have addressed them robustly enough now.
> > 
> > When you need DMI entries you clearly haven't.
> 
>  You can't just break a piece of hardware randomly (setting the thermal 
> trip points based on an interrupt mask of an I/O APIC input is certainly 
> beyond the ACPI spec), hide its documentation and still demand it to be 
> supported correctly, possibly hurting all the other good equipment.  
> Sorry -- you have to draw a line somewhere.  Others seem to agree as 

Well you can blame everyone else, but it doesn't change the fact that
if systems who worked before don't work anymore you've caused regressions.
Which seems to be the case here.

-Andi
-- 
ak@linux.intel.com
