Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbYATQgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbYATQgy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 11:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYATQgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 11:36:47 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:15865 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYATQgp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 11:36:45 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Sun, 20 Jan 2008 09:34:47 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Andres Salomon" <dilinger@queued.net>, marc.jones@amd.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       wim@iguana.be
Subject: Re: Geode GX/LX watchdog timer (was 2.6.24-rc8 hangs at
 mfgpt-timer)
Message-ID: <20080120163447.GA1711@cosmic.amd.com>
References: <20080116165606.3ebc06a4@ephemeral>
 <478F25D6.3060503@i4.informatik.rwth-aachen.de>
 <20080117134032.4cc1a1cf@ephemeral>
 <478FB255.5040001@i4.informatik.rwth-aachen.de>
 <20080117211917.GF8244@cosmic.amd.com>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <20080117223644.GK8244@cosmic.amd.com>
 <478FDC12.6020505@i4.informatik.rwth-aachen.de>
 <20080119010624.GA25328@cosmic.amd.com>
 <47934B2E.3020707@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <47934B2E.3020707@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 20 Jan 2008 16:33:49.0937 (UTC)
 FILETIME=[3C864E10:01C85B82]
X-WSS-ID: 6B8DA8640QK8285841-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/08 14:22 +0100, Arnd Hannemann wrote:
> Hi,
> 
> Jordan Crouse wrote:
> > On 17/01/08 23:52 +0100, Arnd Hannemann wrote:
> >>>> Watchdog for the new API would be great :-)
> >>> Coming soon.
> > 
> > As promised, a watchdog driver for the Geode GX/LX processors is attached.
> > I basically just ported the previous patch forward to 2.6.24.
> 
> Great work!
> 
> > 
> > I also have good news or bad news depending on your perspective.  I wanted
> > to test this against 2.6.24, and OLPC is stuck at an older kernel version,
> > so I had to test this with coreboot (LinuxBIOS) on another Geode 
> > platform.  Like all BIOSen execpt for the OLPC firmware, coreboot uses
> > VSA (SMM handler) which consumes all the timers.
> > 
> > So I used the magical MSR and surprise! - the timer tick hung.  
> > I compiled out the timer tick, and tested the watchdog timer instead,
> > and it worked fine on timer 0.  So I don't think the MFGPTs themselves
> > have anything to do with this problem, but I do think it might be 
> > related to VSA and possibly interrupts too.  I'm going to invoke the
> > strong BIOS fu of our LinuxBIOS / BIOS expert Marc Jones, and see what
> > he comes up with.
> > 
> > I don't know how much of a hassle it would be for Andres to get a 2.6.24
> > kernel running on the OLPC to make sure that this isn't a regression
> > in the timer tick code (I suspect it isn't a regression, but you never
> > know).  I also think that it would probably be in our best interest to
> > default CONFIG_GEODE_MFGPT_TIMER to 'n' until we get this figured
> > out.  Since most BIOSen don't have timers available, that shouldn't affect
> > too many people.
> > 
> > So, anyway, enjoy the watchdog timer - I hope it meets everybody's
> > expectations for the 2.6.25 kernel.
> 
> Thanks a lot for this, it works great! (with CONFIG_GEODE_MFGPT_TIMER
> not set).
> However some minor issues:
> Could the name of the /dev entry perhaps be changed from
> "geode-watchdog" to "watchdog" instead?
> I think all other watchdogs use "watchdog", and using two different
> watchdogs in the same machine won't work anyway, because of the same
> minor number, right?

Very much yes -  complete oversight on my part.

> As a second point my gcc (4.1.2) issues a warning:
> 
> drivers/watchdog/geodewdt.c: In function ‘geodewdt_remove’:
> drivers/watchdog/geodewdt.c:256: warning: control reaches end of
> non-void function
> 
> which I think is a valid one.

Yes again.  I'll refactor.  Thanks for your comments.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


