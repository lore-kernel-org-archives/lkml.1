Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbYAVKdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbYAVKdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbYAVKdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:33:45 -0500
Received: from mx01.qsc.de ([213.148.129.14]:56022 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461AbYAVKdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:33:44 -0500
X-Greylist: delayed 1341 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jan 2008 05:33:44 EST
From: Lars Heete <hel@admin.de>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Date: Tue, 22 Jan 2008 11:11:20 +0100
User-Agent: KMail/1.9.7
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Andres Salomon <dilinger@queued.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20080116165606.3ebc06a4@ephemeral> <478FCDB6.4010708@i4.informatik.rwth-aachen.de> <4795B14C.7040502@i4.informatik.rwth-aachen.de>
In-Reply-To: <4795B14C.7040502@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801221111.21240.hel@admin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday 22 January 2008 10:03:08 am Arnd Hannemann wrote:
> Jordan Crouse wrote:
> > Okay - I've been exploring a little bit more.  I talked to the TinyBIOS
> > developer, and he verified that TinyBIOS shouldn't use any MFGPT timers.
> > He also told me that the mysterious "MFGPT workaround" was in fact the
> > magic MFGPT erasing MSR that was in the old kernel driver.
> >
> > So with the "MFGPT workaround" turned off, TinyBIOS should be acting like
> > the OLPC firmware with regards to timers, yet it is not.  So that is
> > curious.  I think I might have identified a race condition in the code,
> > but I'm not 100% sure thats the same problem that the ALIX platform is
> > seeing.
> >
> > Anrd and others - will you please try the attached patch on your platform
> > with the "MFGPT workaround" turned off and mfgpts enabled, and send out
> > the dmesg?
>
> Of course, tinyBios version v0.99, "MFGPT workaround" turned off,
> CONFIG_GEODE_MFGPT_TIMER=n:
>
> [   67.369697] NET: Registered protocol family 16
> [   67.383059] geode-mfgpt:  IRQ MSR=0:0
> [   67.394058] geode-mfgpt:  NMI MSR=0:0
> [   67.405049] geode-mfgpt:  Unrestricted sources=0
> [   67.418909] geode:  8 MFGPT timers available.
> [   67.433211] PCI: PCI BIOS revision 2.10 entry at 0xfcd03, last bus=0
>
> same with CONFIG_GEODE_MFGPT_TIMER=y (sorry, without move printk patch):
>
> [   22.289349] NET: Registered protocol family 16
> [   22.302716] geode-mfgpt:  IRQ MSR=0:0
> [   22.313716] geode-mfgpt:  NMI MSR=0:0
> [   22.324704] geode-mfgpt:  Unrestricted sources=0
> [   22.338566] geode-mfgpt:  Registered timer 0
> [   22.351393] mfgpt-timer:  registering the MFGT timer as a clock event.
> ^^^^ Hangs here
I had the same problem with MFGPT Timers and alix (BIOS v0.99). I found that 
if you use a different interrupt than the default 7 for MFGPT (just append 
mfgpt_irq=8 to the kernel commandline), the timer seems to work.

CPU0
  0:         33    XT-PIC-XT        timer
  2:          0    XT-PIC-XT        cascade
  4:       1662    XT-PIC-XT        serial
  8:        766    XT-PIC-XT        mfgpt-timer
 14:        473    XT-PIC-XT        libata
NMI:          0
ERR:          0


> > This will give us some debug information that I can use to ensure that
> > the interrupts are set up correctly.  You can leave the timer tick
> > disabled if you want.
> >
> >
> > Thanks,
> > Jordan
>
> Arnd

Lars
