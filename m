Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYIZCLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYIZCLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbYIZCLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:11:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35764 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbYIZCLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:11:36 -0400
Message-ID: <48DC44D4.8000103@garzik.org>
Date: Thu, 25 Sep 2008 22:11:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andres Freund <andres@anarazel.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: bad DMAR interaction with iwlagn and SATA
References: <200809251511.20132.andres@anarazel.de>
In-Reply-To: <200809251511.20132.andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Freund wrote:
> Hi,	
> 
> in some accident caused by wanting to create the .config/compile the kernel 
> for my new laptop (thinkpad t500) before the desperately needed sleeping I 
> activated DMAR...
> 
> I don't know if this is relevant, but I though i better report it.
> 
> 
> This was on fb478da5ba69ecf40729ae8ab37ca406b1e5be48 - sometime after 2.6.27-
> rc7
> 
> I stumbled over two buglets:
> First:
> [ 4184.617392] DMAR:[DMA Read] Request device [03:00.0] fault addr fa946000 
> [ 4184.617393] DMAR:[fault reason 06] PTE Read access is not set
> [ 4184.644081] iwlagn: Microcode HW error detected.  Restarting.
> [ 4186.646000] psmouse.c: TouchPad at isa0060/serio1/input0 lost 
> synchronization, throwing 1 bytes away.
> [ 4186.683034] Registered led device: iwl-phy0:radio
> [ 4186.683478] Registered led device: iwl-phy0:assoc
> [ 4186.683793] Registered led device: iwl-phy0:RX
> [ 4186.684094] Registered led device: iwl-phy0:TX
> [ 4186.689749] wlan0: authenticate with AP 00:1d:7e:42:fe:42
> [ 4186.691691] wlan0: authenticated
> [ 4186.691705] wlan0: associate with AP 00:1d:7e:42:fe:42
> [ 4186.696380] wlan0: RX ReassocResp from 00:1d:7e:42:fe:42 (capab=0x411 
> status=0 aid=2)
> [ 4186.696392] wlan0: associated
> 
> Most of the time when this happened, the machine wasnt reacting for 1-3 
> seconds and had audio buffer underruns, but I also had a hard lockup which I 
> couldnt diagnose so far.
> 
> Second:
> [ 2937.484251] DMAR:[DMA Read] Request device [00:1f.2] fault addr fffbf000 
> [ 2937.484255] DMAR:[fault reason 06] PTE Read access is not set
> [ 2937.484297] ata1.00: exception Emask 0x60 SAct 0x1 SErr 0x800 action 0x6 
> frozen
> [ 2937.484303] ata1.00: irq_stat 0x20000000, host bus error
> [ 2937.484309] ata1: SError: { HostInt }
> [ 2937.484319] ata1.00: cmd 61/08:00:c0:1d:6b/00:00:07:00:00/40 tag 0 ncq 4096 
> out
> [ 2937.484321]          res 40/00:00:c0:1d:6b/00:00:07:00:00/40 Emask 0x60 
> (host bus error)

Ouch, a host bus error is serious nastiness...

http://ata.wiki.kernel.org/index.php/Libata_error_messages#Error_classes

That's the ATA controller falling over after some serious machine hiccups.

	Jeff



