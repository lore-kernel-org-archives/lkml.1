Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbZC3UQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbZC3UQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbZC3UQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:16:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759145AbZC3UQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:16:03 -0400
Date: Mon, 30 Mar 2009 13:05:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rik van Riel <riel@redhat.com>
cc: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D11BDD.70702@redhat.com>
Message-ID: <alpine.LFD.2.00.0903301259490.4093@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
 <49D11BDD.70702@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Rik van Riel wrote:
> 
> Maybe a stupid question, but aren't tracks so small compared to
> the disk head that a physical head crash would take out multiple
> tracks at once?  (the last on I experienced here took out a major
> part of the disk)

Probably. My experiences (not _that_ many drives, but more than one) have 
certainly been that I've never seen a _single_ read error.

> Another case I have seen years ago was me writing data to a disk
> while it was still cold (I brought it home, plugged it in and
> started using it).  Once the drive came up to temperature, it
> could no longer read the tracks it just wrote - maybe the disk
> expanded by more than it is willing to seek around for tracks
> due to thermal correction?   Low level formatting the drive
> made it work perfectly and I kept using it until it was just
> too small to be useful :)

I've had one drive that just stopped spinning. On power-on, it would make 
these pitiful noises trying to get the platters to move, but not actually 
ever work. If I recall correctly, I got the data off it by letting it just 
cool down, then powering up (successfully) and transferring all the data 
I cared about off the disk. And then replacing the disk.

> > And my point is, IT MAKES SENSE to just do the elevator barrier, _without_
> > the drive command. 
> 
> No argument there.  I have seen NCQ starvation on SATA disks,
> with some requests sitting in the drive for seconds, while
> the drive was busy handling hundreds of requests/second
> elsewhere...

I _thought_ we stopped feeding new requests while the flush was active, so 
if you actually do a flush, that should never actually happen. But I 
didn't check.

		Linus
