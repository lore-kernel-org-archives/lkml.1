Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZC3PVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZC3PVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZC3PVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:21:08 -0400
Received: from rtr.ca ([76.10.145.34]:36553 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbZC3PVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:21:06 -0400
Message-ID: <49D0E35E.9080003@rtr.ca>
Date: Mon, 30 Mar 2009 11:21:02 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>
Cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	<49CD7B10.7010601@garzik.org>	<49CD891A.7030103@rtr.ca>	<49CD9047.4060500@garzik.org>	<49CE2633.2000903@s5r6.in-berlin.de>	<49CE3186.8090903@garzik.org>	<49CE35AE.1080702@s5r6.in-berlin.de>	<49CE3F74.6090103@rtr.ca>	<20090329231451.GR26138@disturbed>	<20090330003948.GA13356@mit.edu>	<49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com>
In-Reply-To: <49D0DDFE.5080701@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
>
> I am confused as to why you think that barriers (flush barriers 
> specifically) are not equivalent to drive write cache. We disable 
> barriers when the write cache is off, use them only to insure that our 
> ordering for fs transactions survives any power loss. No one should be 
> enabling barriers on linux file systems if your write cache is disabled 
> or if you have a battery backed write cache (say on an enterprise class 
> disk array).
> 
> Chris' test of barriers (with write cache enabled) did show for desktop 
> class boxes that you would get file system corruption (i.e., need to 
> fsck the disk) a huge percentage of the time.
..

Sure, no doubt there.  But it's due to the kernel crash,
not due to the write cache on the drive.

Anything in the drive's write cache very probably made it to the media
within a second or two of arriving there.

So with or without a write cache, the same result should happen
for those tests.  Of course, if you disable barriers *and* write cache,
then you are no longer testing the same kernel code.

I'm not arguing against battery backup or UPSs,
or *for* blindly trusting write caches without reliable power.

Just pointing out that they're not the evil that some folks
seem to believe they are.

Cheers
