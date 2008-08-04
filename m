Return-Path: <linux-kernel-owner+w=401wt.eu-S1763607AbYHDVSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763607AbYHDVSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757123AbYHDVR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:17:56 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:8734 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972AbYHDVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:17:55 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=xGfjZxgYTzcgX_OJYJ8A:9 a=Tigg3cRvZ397KgzPgSYA:7 a=uLWjh2V-MPpIl0trFidj1e5cfkAA:4 a=ZCnnSLshPu8A:10 a=lN1hEWcJ4VIA:10
Message-ID: <48977200.3050307@shaw.ca>
Date: Mon, 04 Aug 2008 15:17:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
References: <fa.OGeO7gZvBG4obEzRbVltjSebgTQ@ifi.uio.no> <fa.KtvYE2B2yrJqUleolhtMPN9ljAQ@ifi.uio.no> <fa.AqEKTvguYFAzDFHy/We/8MpOqmo@ifi.uio.no> <48976168.3020804@shaw.ca> <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804205508.20a3f917@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I was looking into the 32-bit PIO issue a bit yesterday. It looks like 
>> some of the VLB libata drivers are doing this internally already, so it 
>> shouldn't be hard to do this in the core. Only question is how we know 
>> generically if the controller can do it or not? It looks like in old
> 
> You don't. Basically it is controller dependant. Pretty much all the
> newer controllers support the 32bit PIO data cycles. Most PCI controllers
> it makes no speed difference but host bus controllers (especially
> PIIX/ICH) really benefit.
> 
>> supported. I couldn't track down where that bit was actually defined in 
>> the first place, all the way back to ATA-1 it seems to be indicated as 
>> reserved. Actually, I'm not sure why the drive cares in the first place, 
>> it would seem like a pure host controller issue..
> 
> It goes back before IDE into the depths of the original compaq spec. When
> you have a device wired basically directly to the ISA bus (original IDE)
> it mattered. I don't believe it is relevant to any of the PCI controllers.

I guess that bit doesn't really make any difference with remotely modern 
drives, then.. Could we make that ata_id_has_dword_io check always 
return true if ata_id_is_ata returns true and only check word 48 if not?

I saw Willy Tarreau's patch from February for this, I agree that we 
should likely use a separate data_xfer method for 32-bit transfer (or if 
enough controllers should support 32-bit, then just make it be the 
default and make a separate 16-bit only function for those that don't), 
rather than punting the decision to the user with hdparm.

You mentioned in the thread for Willy's patch that "some
controllers have quirky rules for 32bit xfers" - any details anywhere?
