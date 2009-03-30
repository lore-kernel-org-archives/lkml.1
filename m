Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbZC3Qaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbZC3Qaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZC3QaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:30:21 -0400
Received: from rtr.ca ([76.10.145.34]:34145 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3QaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:30:20 -0400
Message-ID: <49D0F399.5010407@rtr.ca>
Date: Mon, 30 Mar 2009 12:30:17 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca> <49D0E4E8.20508@redhat.com> <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Ric Wheeler wrote:
>> A modern S-ATA drive has up to 32MB of write cache. If you lose power or
>> suffer a sudden reboot (that can reset the bus at least), I am pretty sure
>> that your above assumption is simply not true.
> 
> At least traditionally, it's worth to note that 32MB of on-disk cache is 
> not the same as 32MB of kernel write cache.
> 
> The drive caches tend to be more like track caches - you tend to have a 
> few large cache entries (segments), not something like a sector cache. And 
> I seriously doubt the disk will let you fill them up with writes: it 
> likely has things like the sector remapping tables in those caches too.
..

I spent an entire day recently, trying to see if I could significantly fill
up the 32MB cache on a 750GB Hitach SATA drive here.

With deliberate/random write patterns, big and small, near and far,
I could not fill the drive with anything approaching a full second
of latent write-cache flush time.

Not even close.  Which is a pity, because I really wanted to do some testing
related to a deep write cache.  But it just wouldn't happen.

I tried this again on a 16MB cache of a Seagate drive, no difference.

Bummer.  :)
