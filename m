Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYAVSQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYAVSQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYAVSQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:16:46 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:29621 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbYAVSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:16:45 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
Date: Tue, 22 Jan 2008 11:15:42 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Lars Heete" <hel@admin.de>, "Andres Salomon" <dilinger@queued.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122181542.GB5241@cosmic.amd.com>
References: <20080116165606.3ebc06a4@ephemeral>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <4795B14C.7040502@i4.informatik.rwth-aachen.de>
 <200801221111.21240.hel@admin.de>
 <4795D120.7070806@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <4795D120.7070806@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 22 Jan 2008 18:14:29.0388 (UTC)
 FILETIME=[A124E4C0:01C85D22]
X-WSS-ID: 6B88ED610QK8490730-13-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/08 12:18 +0100, Arnd Hannemann wrote:
> Hi Lars,
> 
> Lars Heete schrieb:
> > Hello,
> > 
> > On Tuesday 22 January 2008 10:03:08 am Arnd Hannemann wrote:
> >> Jordan Crouse wrote:
> >>> Okay - I've been exploring a little bit more.  I talked to the TinyBIOS
> >>> developer, and he verified that TinyBIOS shouldn't use any MFGPT timers.
> >>> He also told me that the mysterious "MFGPT workaround" was in fact the
> >>> magic MFGPT erasing MSR that was in the old kernel driver.
> >>>
> >>> So with the "MFGPT workaround" turned off, TinyBIOS should be acting like
> >>> the OLPC firmware with regards to timers, yet it is not.  So that is
> >>> curious.  I think I might have identified a race condition in the code,
> >>> but I'm not 100% sure thats the same problem that the ALIX platform is
> >>> seeing.
> >>>
> >>> Anrd and others - will you please try the attached patch on your platform
> >>> with the "MFGPT workaround" turned off and mfgpts enabled, and send out
> >>> the dmesg?
> >> Of course, tinyBios version v0.99, "MFGPT workaround" turned off,
> >> CONFIG_GEODE_MFGPT_TIMER=n:
> >>
> >> [   67.369697] NET: Registered protocol family 16
> >> [   67.383059] geode-mfgpt:  IRQ MSR=0:0
> >> [   67.394058] geode-mfgpt:  NMI MSR=0:0
> >> [   67.405049] geode-mfgpt:  Unrestricted sources=0
> >> [   67.418909] geode:  8 MFGPT timers available.
> >> [   67.433211] PCI: PCI BIOS revision 2.10 entry at 0xfcd03, last bus=0
> >>
> >> same with CONFIG_GEODE_MFGPT_TIMER=y (sorry, without move printk patch):
> >>
> >> [   22.289349] NET: Registered protocol family 16
> >> [   22.302716] geode-mfgpt:  IRQ MSR=0:0
> >> [   22.313716] geode-mfgpt:  NMI MSR=0:0
> >> [   22.324704] geode-mfgpt:  Unrestricted sources=0
> >> [   22.338566] geode-mfgpt:  Registered timer 0
> >> [   22.351393] mfgpt-timer:  registering the MFGT timer as a clock event.
> >> ^^^^ Hangs here
> > I had the same problem with MFGPT Timers and alix (BIOS v0.99). I found that 
> > if you use a different interrupt than the default 7 for MFGPT (just append 
> > mfgpt_irq=8 to the kernel commandline), the timer seems to work.
> 
> Indeed.
> Strange, it works at least with mfgpt_irq=8 (rtc) and mfgpt_irq=5 (audio):

That is very unfortunate.  We must continue to investigate.

> [   21.805129] geode-mfgpt:  IRQ MSR=0:0
> [   21.816129] geode-mfgpt:  NMI MSR=0:0
> [   21.827116] geode-mfgpt:  Unrestricted sources=0
> [   21.840979] geode-mfgpt:  Registered timer 0
> [   21.853806] mfgpt-timer:  registering the MFGT timer as a clock event.
> [   21.873576] geode:  8 MFGPT timers available.
> [   21.887962] PCI: PCI BIOS revision 2.10 entry at 0xfcd03, last bus=0
> 
<snip>

> I noted that "rtc" disappeared, do I have any drawback of this?
> I assume that the mfgpt-timer cannot be shared?

No.  We figured that was the best way to go.  I don't know if there
are any technical reasons why it can't be shared, other then latency
problems.

But I would still prefer to figure out why 7 doesn't work - because there
is nothing in the hardware or kernel code that should prevent that.

Arnd - if you don't mind doing a little bit more debug work.  You've already
given us the MSRs for 0x51400020 - 0x51400023.  Can you now give us 
0x51400024-0x51400027, as well as 5140004E?  Our current working theory
is that IRQ7 (traditionally used by the LPT port) is still conflicting
somewhere.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


