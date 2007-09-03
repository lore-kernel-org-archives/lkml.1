Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbXICL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbXICL3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 07:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbXICL3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 07:29:05 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:18690 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbXICL3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 07:29:03 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 3 Sep 2007 13:27:46 +0200
From: "Robert Richter" <robert.richter@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space
 access for AMD Barcelona
Message-ID: <20070903112746.GH7916@erda.amd.com>
References: <20070830174311.221133000@amd.com>
 <200709011211.52167.ak@suse.de>
 <20070903083242.GA22144@alberich.amd.com>
 <200709031215.03473.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200709031215.03473.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Sep 2007 11:27:46.0665 (UTC)
 FILETIME=[73BE1D90:01C7EE1D]
X-WSS-ID: 6AC5303C0X86411343-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On 03.09.07 12:15:03, Andi Kleen wrote:

> > But it is needed for some devices for full functionality.
> 
> Examples? I can only think of PCI express error reporting, which
> few drivers implement anyways and isn't really a show stopper
> if it doesn't work. Besides I would be surprised if it even works
> on the cheap desktop boards which have MCFG less BIOS.

As you say, there are BIOSs that do not support MMCONFIG. Thus, CF8
access is not only a workaround to boot a system. There are systems
that really use CF8 access. Also, MMCONFIG depends on many conditions
that must match. Cfg space must be mapped, the memory must be E820
reserved, MCFG table must be set, access to MMCONFIG must be enabled
for the device. Many things that may fail and can partly not be fixed
by the OS.

> > E.g. for perfmon (family 0x10/extended inerrupts) extended config space
> > access is a prerequisite.
> 
> How so? 

Recent (10h) and upcomming CPU families make heavy use of PCI ext cfg
space for certain CPU features. Setup of the extended interupt local
vector table for IBS (used with Perfmon2) is one example. CPU
designers do not take care anymore if a feature is in the base or
extended config space. So access to PCI ECS is essential.

> > IMHO it is best to try to use MMCONFIG if it's working and to use
> > a fallback (e.g. CF8 ECS access for family 0x10) if available.
> 
> We only put in workarounds if there is a serious problem otherwise (e.g. not 
> booting etc.). I just don't see this here.

As said above, I do not see CF8 access as a workaround. I expect my
system to work in the same way also if MMCONFIG is not available.

-Robert

-- 
AMD Saxony, Dresden, Germany
Operating System Research Center
email: robert.richter@amd.com


