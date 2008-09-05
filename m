Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYIESja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYIESja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYIESjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:39:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYIESjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:39:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Anders Aagaard <aagaande@gmail.com>
Subject: Re: [Suspend-devel] Resume performance
Date: Fri, 5 Sep 2008 20:43:38 +0200
User-Agent: KMail/1.9.9
Cc: suspend-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <48C10908.60101@gmail.com> <200809051308.14079.rjw@sisk.pl> <48C13827.1010409@gmail.com>
In-Reply-To: <48C13827.1010409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809052043.38677.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of September 2008, Anders Aagaard wrote:
> Rafael J. Wysocki wrote:
> > On Friday, 5 of September 2008, Anders Aagaard wrote:
> >> Hi
> > 
> > Hi,
> > 
> > This is a kernel problem, so let's CC the LKML.
> > 
> >> I have a intel P35 board with a quad core cpu in it, it's currently 
> >> running as a server for a small network, and I'd like to be able to shut 
> >> it down when idle, and use wake on lan to wake it up when it's needed. 
> >> Now I got that part working quite well, but for some reason I have a 
> >> long delay in resume.
> >>
> >> I seem to remember being able to resume this computer in 2-3 seconds 
> >> when I was testing it, now it needs 35 seconds to resume.  It seems 
> >> regardless of resume options used, and it always resumes to a working 
> >> state without problems.
> > 
> > What kernel are you using at the moment and which one was used for the
> > testing?
> 
> I'm using gentoo's 2.6.25-r7, I've also tried vanilla sources.

Would it be possible to test 2.6.27-rc5-gi7 from kernel.org?

> >> I've tried quite a lot of things, booting with noapic/nosmp, booting a 
> >> kernel without usb/network drivers, disabling ahci (using ata_piix 
> >> driver instead of ahci), and there's always that one long delay.  And 
> >> I'm not quite sure how the kernel printk timing information works, so 
> >> I'm not sure whats causing that delay.
> >>
> >> Output from dmesg when booting with nosmp (to get accurate timing data):
> >> scripts/show_delta -b "Force enabled HPET at resume"
> >> [349.821150 < 7.039261 >] ata3.00: configured for UDMA/133
> >> [349.821160 < 7.039271 >] sd 2:0:0:0: [sdc] 976773168 512-byte hardware 
> >> sectors (500108 MB)
> >> [349.821165 < 7.039276 >] sd 2:0:0:0: [sdc] Write Protect is off
> >> [349.821166 < 7.039277 >] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> >> [349.821173 < 7.039284 >] sd 2:0:0:0: [sdc] Write cache: enabled, read 
> >> cache: enabled, doesn't support DPO or FUA
> >> [349.972801 < 7.190912 >] ata1: SATA link up 3.0 Gbps (SStatus 123 
> >> SControl 300)
> >> [349.979060 < 7.197171 >] ata1.00: configured for UDMA/133
> >> [349.979070 < 7.197181 >] sd 0:0:0:0: [sda] 976771055 512-byte hardware 
> >> sectors (500107 MB)
> >> [349.979075 < 7.197186 >] sd 0:0:0:0: [sda] Write Protect is off
> >> [349.979076 < 7.197187 >] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> >> [349.979083 < 7.197194 >] sd 0:0:0:0: [sda] Write cache: enabled, read 
> >> cache: enabled, doesn't support DPO or FUA
> > 
> > It looks like this happens here.  Can you try to unload the network driver
> > before suspend, please?
> 
> I tried to build a kernel without it, and it still takes the exact same 
> amount to boot, I've also tried unloading usb drivers and it takes the 
> exact same amount of time.

Can you try to boot with init=/bin/bash and suspend to RAM?  (Please have a
look at section 2 of Documentation/power/basic-pm-debugging.txt in the newer
kernel sources).

Thanks,
Rafael
