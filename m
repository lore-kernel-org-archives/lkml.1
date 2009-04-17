Return-Path: <linux-kernel-owner+w=401wt.eu-S1760378AbZDQKks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760378AbZDQKks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbZDQKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:40:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35610 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757436AbZDQKkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:40:03 -0400
Message-ID: <49E85C7E.5020200@garzik.org>
Date: Fri, 17 Apr 2009 06:39:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] AHCI updates: Marvell AHCI PATA works; pata_marvell
 fate?
References: <20090417023949.GA14469@havoc.gtf.org> <20090417105031.607a771e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090417105031.607a771e@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Marvell PATA on 6121 and similar chips should also work, but that hasn't
>> yet been tested.  Here's the full list of what still needs testing:
>>
>> - master + slave devices
>> - ATAPI
>> - 6121 (6123? others?)
> 
> LBA48

And 80-pin cables...  I cannot find where it permits cable detection or 
where DMA/PIO mode in AHCI mode, complicating things :(


>> Also, there is the open question of how to deal with pata_marvell
>> co-existence
> 
> I think for the moment make PATA support by AHCI a config option and as
> soon as we trust it we can get rid of the option and of pata_marvell.

I'm not sure I see the worth of making PATA, solely, a config option?

Today, the choice is either pata_marvell (PATA) or ahci w/ module option 
(SATA).

My patches morph that choice into: pata_marvell (PATA) or mv-ahci (PATA 
+ SATA).

Thus, considering the hardware, if the user disables PATA support in 
mv-ahci, they still have the problem of two drivers competing for the 
same PCI IDs - no matter that the drivers would each probe different bus 
types (PATA, or SATA).

We could skip SATA_MV_AHCI if PATA_MARVELL is set in .config...  Now 
that mv-ahci solely contains Marvell PCI IDs, that would have the effect 
at compile-time that a module option would have at runtime.

	Jeff


