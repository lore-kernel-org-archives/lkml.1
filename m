Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYATUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYATUQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbYATUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:16:06 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42473 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094AbYATUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:16:05 -0500
Date: Sun, 20 Jan 2008 15:16:03 -0500
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>,
       Andres Salomon <dilinger@queued.net>, marc.jones@amd.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, wim@iguana.be
Subject: Re: [GEODE] Geode GX/LX watchdog timer (was 2.6.24-rc8 hangs at mfgpt-timer)
Message-ID: <20080120201603.GQ2310@csclub.uwaterloo.ca>
References: <20080116161912.7b449466@ephemeral> <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080119010624.GA25328@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119010624.GA25328@cosmic.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 06:06:24PM -0700, Jordan Crouse wrote:
> As promised, a watchdog driver for the Geode GX/LX processors is attached.
> I basically just ported the previous patch forward to 2.6.24.
> 
> I also have good news or bad news depending on your perspective.  I wanted
> to test this against 2.6.24, and OLPC is stuck at an older kernel version,
> so I had to test this with coreboot (LinuxBIOS) on another Geode 
> platform.  Like all BIOSen execpt for the OLPC firmware, coreboot uses
> VSA (SMM handler) which consumes all the timers.

Hmm, the Geode LX platform I work with uses VSA/SMM and I have had no
problems using timer 2 for a watchdog.  Some of the timers are certainly
already setup by something in the BIOS, but quite a few are not in use.
The board I am using is the compulab iGLX module.  I did have to mangle
together a watchdog driver myself some time ago since there wasn't one
for the Geode LX at the time.

Of course I haven't gone past 2.6.18 kernel for now (I am tracking
Debian stable for the most part), so I have no idea if something in a
newer kernel breaks things.

> So I used the magical MSR and surprise! - the timer tick hung.  
> I compiled out the timer tick, and tested the watchdog timer instead,
> and it worked fine on timer 0.  So I don't think the MFGPTs themselves
> have anything to do with this problem, but I do think it might be 
> related to VSA and possibly interrupts too.  I'm going to invoke the
> strong BIOS fu of our LinuxBIOS / BIOS expert Marc Jones, and see what
> he comes up with.
> 
> I don't know how much of a hassle it would be for Andres to get a 2.6.24
> kernel running on the OLPC to make sure that this isn't a regression
> in the timer tick code (I suspect it isn't a regression, but you never
> know).  I also think that it would probably be in our best interest to
> default CONFIG_GEODE_MFGPT_TIMER to 'n' until we get this figured
> out.  Since most BIOSen don't have timers available, that shouldn't affect
> too many people.
> 
> So, anyway, enjoy the watchdog timer - I hope it meets everybody's
> expectations for the 2.6.25 kernel.

--
Len Sorensen
