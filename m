Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXICMyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXICMyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbXICMx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:53:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXICMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:53:24 -0400
From: Andi Kleen <ak@suse.de>
To: "Robert Richter" <robert.richter@amd.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Mon, 3 Sep 2007 14:48:41 +0200
User-Agent: KMail/1.9.1
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070830174311.221133000@amd.com> <200709031215.03473.ak@suse.de> <20070903112746.GH7916@erda.amd.com>
In-Reply-To: <20070903112746.GH7916@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031448.42285.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 13:27, Robert Richter wrote:

> On 03.09.07 12:15:03, Andi Kleen wrote:
> > > But it is needed for some devices for full functionality.
> >
> > Examples? I can only think of PCI express error reporting, which
> > few drivers implement anyways and isn't really a show stopper
> > if it doesn't work. Besides I would be surprised if it even works
> > on the cheap desktop boards which have MCFG less BIOS.
>
> As you say, there are BIOSs that do not support MMCONFIG. Thus, CF8
> access is not only a workaround to boot a system. 

We're talking about accessing the extended part of config spaces. I'm not 
aware of any case where that is required to boot a system.

> Recent (10h) and upcomming CPU families make heavy use of PCI ext cfg
> space for certain CPU features. Setup of the extended interupt local
> vector table for IBS (used with Perfmon2) is one example. CPU
> designers do not take care anymore if a feature is in the base or
> extended config space. So access to PCI ECS is essential.

I don't think it's a big issue if IBS doesn't work on a few buggy BIOS
(which should hopefully become fewer anyways because Vista is out
which actually uses MCFG) 


> > > IMHO it is best to try to use MMCONFIG if it's working and to use
> > > a fallback (e.g. CF8 ECS access for family 0x10) if available.
> >
> > We only put in workarounds if there is a serious problem otherwise (e.g.
> > not booting etc.). I just don't see this here.
>
> As said above, I do not see CF8 access as a workaround. I expect my
> system to work in the same way also if MMCONFIG is not available.

It should boot sure, but exotic stuff not working is not a major issue

-Andi
