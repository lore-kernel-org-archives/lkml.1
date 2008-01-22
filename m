Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbYAVJCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbYAVJCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 04:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbYAVJCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 04:02:21 -0500
Received: from slowhand.arndnet.de ([88.198.19.76]:59726 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755621AbYAVJCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 04:02:20 -0500
Message-ID: <4795B14C.7040502@i4.informatik.rwth-aachen.de>
Date: Tue, 22 Jan 2008 10:03:08 +0100
From: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
References: <20080116165606.3ebc06a4@ephemeral> <478F25D6.3060503@i4.informatik.rwth-aachen.de> <20080117134032.4cc1a1cf@ephemeral> <478FB255.5040001@i4.informatik.rwth-aachen.de> <20080117211917.GF8244@cosmic.amd.com> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <20080117223644.GK8244@cosmic.amd.com> <478FDC12.6020505@i4.informatik.rwth-aachen.de> <20080117225744.GL8244@cosmic.amd.com> <478FE733.2030806@i4.informatik.rwth-aachen.de> <20080121232709.GJ10837@cosmic.amd.com>
In-Reply-To: <20080121232709.GJ10837@cosmic.amd.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:
> Okay - I've been exploring a little bit more.  I talked to the TinyBIOS
> developer, and he verified that TinyBIOS shouldn't use any MFGPT timers.
> He also told me that the mysterious "MFGPT workaround" was in fact the 
> magic MFGPT erasing MSR that was in the old kernel driver.
> 
> So with the "MFGPT workaround" turned off, TinyBIOS should be acting like
> the OLPC firmware with regards to timers, yet it is not.  So that is 
> curious.  I think I might have identified a race condition in the code,
> but I'm not 100% sure thats the same problem that the ALIX platform is
> seeing.
> 
> Anrd and others - will you please try the attached patch on your platform
> with the "MFGPT workaround" turned off and mfgpts enabled, and send out
> the dmesg?

Of course, tinyBios version v0.99, "MFGPT workaround" turned off,
CONFIG_GEODE_MFGPT_TIMER=n:

[   67.369697] NET: Registered protocol family 16
[   67.383059] geode-mfgpt:  IRQ MSR=0:0
[   67.394058] geode-mfgpt:  NMI MSR=0:0
[   67.405049] geode-mfgpt:  Unrestricted sources=0
[   67.418909] geode:  8 MFGPT timers available.
[   67.433211] PCI: PCI BIOS revision 2.10 entry at 0xfcd03, last bus=0

same with CONFIG_GEODE_MFGPT_TIMER=y (sorry, without move printk patch):

[   22.289349] NET: Registered protocol family 16
[   22.302716] geode-mfgpt:  IRQ MSR=0:0
[   22.313716] geode-mfgpt:  NMI MSR=0:0
[   22.324704] geode-mfgpt:  Unrestricted sources=0
[   22.338566] geode-mfgpt:  Registered timer 0
[   22.351393] mfgpt-timer:  registering the MFGT timer as a clock event.
^^^^ Hangs here

> 
> This will give us some debug information that I can use to ensure that
> the interrupts are set up correctly.  You can leave the timer tick disabled
> if you want.

> 
> Thanks,
> Jordan
> 

Arnd
