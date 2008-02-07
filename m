Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYBGQ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYBGQ6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbYBGQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:58:46 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:39425 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbYBGQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:58:45 -0500
Message-ID: <47AB38AB.8050001@qualcomm.com>
Date: Thu, 07 Feb 2008 08:58:19 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, john.ronciak@intel.com,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       auke-jan.h.kok@intel.com
Subject: Re: e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz>
In-Reply-To: <20080207141718.GA2030@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> I have the famous e1000 latency problems:
> 
> 64 bytes from 195.113.31.123: icmp_seq=68 ttl=56 time=351.9 ms
> 64 bytes from 195.113.31.123: icmp_seq=69 ttl=56 time=209.2 ms
> 64 bytes from 195.113.31.123: icmp_seq=70 ttl=56 time=1004.1 ms
> 64 bytes from 195.113.31.123: icmp_seq=71 ttl=56 time=308.9 ms
> 64 bytes from 195.113.31.123: icmp_seq=72 ttl=56 time=305.4 ms
> 64 bytes from 195.113.31.123: icmp_seq=73 ttl=56 time=9.8 ms
> 64 bytes from 195.113.31.123: icmp_seq=74 ttl=56 time=3.7 ms
> 
> ...and they are still there in 2.6.25-git0. I had ethernet EEPROM
> checksum problems, which I fixed by the update, but problems are not
> gone.
> 
> irqpoll helps.
> 
> nosmp (which implies XT-PIC is being used) does not help.
> 
>  16:       1925          0   IO-APIC-fasteoi   ahci, yenta, uhci_hcd:usb2, eth0
> 
> Booting kernel with nosmp/ no yenta, no usb does not help.
> 
> Hmm, as expected, interrupt load on ahci (find /) makes latencies go
> away.
> 
> It should be easily reproducible on x60 with latest bios, it is 100%
> reproducible for me...

So you don't think it's related to the interrupt coalescing by any chance ?
I'd suggest to try and disable the coalescing and see if it makes any difference.
We've had lots of issues with coalescing misbehavior. Not this bad (ie 1 second) though.

Add this to modprobe.conf and reload e1000 module

options e1000 RxIntDelay=0,0 RxAbsIntDelay=0,0 InterruptThrottleRate=0,0 TxIntDelay=0,0 TxAbsIntDelay=0,0

Max

