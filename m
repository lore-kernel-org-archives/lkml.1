Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbZC3T0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbZC3T0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756864AbZC3TZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:25:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbZC3TZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:25:56 -0400
Message-ID: <49D11BDD.70702@redhat.com>
Date: Mon, 30 Mar 2009 15:22:05 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Mon, 30 Mar 2009, Ric Wheeler wrote:

>> Heat is a major killer of spinning drives (as is severe cold). A lot of times,
>> drives that have read errors only (not failed writes) might be fully
>> recoverable if you can re-write that injured sector.
> 
> It's not worked for me, and yes, I've tried.

It's worked here.  It would be nice to have a device mapper module
that can just insert itself between the disk and the higher device
mapper layer and "scrub" the disk, fetching unreadable sectors from
the other RAID copy where required.

> I'm sure it works for some "ok, the write just failed to take, and the CRC 
> was bad" case, but that's apparently not what I've had. I suspect either 
> the track markers got overwritten (and maybe a disk-specific low-level 
> reformat would have helped, but at that point I was not going to trust the 
> drive anyway, so I didn't care), or there was actual major physical damage 
> due to heat and/or head crash and remapping was just not able to cope.

Maybe a stupid question, but aren't tracks so small compared to
the disk head that a physical head crash would take out multiple
tracks at once?  (the last on I experienced here took out a major
part of the disk)

Another case I have seen years ago was me writing data to a disk
while it was still cold (I brought it home, plugged it in and
started using it).  Once the drive came up to temperature, it
could no longer read the tracks it just wrote - maybe the disk
expanded by more than it is willing to seek around for tracks
due to thermal correction?   Low level formatting the drive
made it work perfectly and I kept using it until it was just
too small to be useful :)

> And my point is, IT MAKES SENSE to just do the elevator barrier, _without_ 
> the drive command. 

No argument there.  I have seen NCQ starvation on SATA disks,
with some requests sitting in the drive for seconds, while
the drive was busy handling hundreds of requests/second
elsewhere...

-- 
All rights reversed.
