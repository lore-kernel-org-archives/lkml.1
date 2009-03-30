Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZC3RaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZC3RaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZC3RaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:30:05 -0400
Received: from rtr.ca ([76.10.145.34]:43569 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZC3RaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:30:03 -0400
Message-ID: <49D10195.7090501@rtr.ca>
Date: Mon, 30 Mar 2009 13:29:57 -0400
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
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca> <49D0E4E8.20508@redhat.com> <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain> <49D0F399.5010407@rtr.ca> <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Mark Lord wrote:
>> I spent an entire day recently, trying to see if I could significantly fill
>> up the 32MB cache on a 750GB Hitach SATA drive here.
>>
>> With deliberate/random write patterns, big and small, near and far,
>> I could not fill the drive with anything approaching a full second
>> of latent write-cache flush time.
>>
>> Not even close.  Which is a pity, because I really wanted to do some testing
>> related to a deep write cache.  But it just wouldn't happen.
>>
>> I tried this again on a 16MB cache of a Seagate drive, no difference.
>>
>> Bummer.  :)
> 
> Try it with laptop drives. You might get to a second, or at least hundreds 
> of ms (not counting the spinup delay if it went to sleep, obviously). You 
> probably tested desktop drives (that 750GB Hitachi one is not a low end 
> one, and I assume the Seagate one isn't either).
> 
> You'll have a much easier time getting long latencies when seeks take tens 
> of ms, and the platter rotates at some pitiful 3600rpm (ok, I guess those 
> drives are hard to find these days - I guess 4200rpm is the norm even for 
> 1.8" laptop harddrives).
> 
> And also - this is probably obvious to you, but it might not be 
> immediately obvious to everybody - make sure that you do have TCQ going, 
> and at full depth. If the drive supports TCQ (and they all do, these days) 
> it is quite possible that the drive firmware basically limits the write 
> caching to one segment per TCQ entry (or at least to something smallish).
..

Oh yes, absolute -- I tried with and without NCQ (the SATA replacement
for old-style TCQ), and with varying NCQ queue depths.  No luck keeping
the darned thing busy flushing afterwards for anything more than
perhaps a few hundred millseconds.  I wasn't really interested in anything
under a second, so I didn't measure it exactly though.

The older and/or slower notebook drives (4200rpm) tend to have smaller
onboard caches, too.  Which makes them difficult to fill.

I suspect I'd have much better "luck" with a slow-ish SSD that has
a largish write cache.  Dunno if those exist, and they'll have to get
cheaper before I pick one up to deliberately bash on.  :)

Cheers
