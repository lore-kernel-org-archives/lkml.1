Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYE1Vu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYE1Vu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYE1Vqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:46:45 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:50796 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbYE1Vqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:46:43 -0400
Date: Wed, 28 May 2008 17:46:30 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <20080528134257.GA16164@csclub.uwaterloo.ca>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-id: <200805281746.30925.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <483C81DE.8060002@cfl.rr.com> <20080528134257.GA16164@csclub.uwaterloo.ca>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2008, Lennart Sorensen wrote:
>On Tue, May 27, 2008 at 05:49:18PM -0400, Phillip Susi wrote:
>> Yes, the interleave slows you down, since after accessing sector 1, the
>> head must wait to pass over 3 other sectors before finally reaching
>> sector 2, therefore, you can only read 1/4 of the sectors on the track
>> each revolution of the disk.  That leaves 4 revolutions at 300 rpm
>> giving 0.8s to read a track, or 64 seconds to read all 80 tracks, plus
>> seek time.  That still does not explain 3 minutes though... not sure
>> what else could be slowing you down.
>
>Just do what the Amiga did:  Read the entire track into a buffer in
>memory, then deal with the sectors, and write the entire track back. :)

That would be a huge improvement, but I'm afraid it would need someone far more 
familiar with floppy.c than I.

I am beginning to figure out how to make it work though.  The sequence goes 
something like this:
1. insert disk in drive, wait 5 minutes just in case, didn't help.
2. setfdprm /dev/fd0 COCO7203.5
3. getfdprm /dev/fd0 (fails, no such device)
4. dd if=/dev/fd0 bs=256 count=1
5. wait 20 to 40 secs for it to fail with an i/o error
6. setfdprm /dev/fd0 COCO7203.5
7. getfdprm /dev/fd0
DS DD sect=18 ssize=256
8. dd if=disk.image of=/dev/fd0 bs=256

then about 4 minutes later:

9. dd if=dev/fd0 of=test.dsk;cmp disk.image test.dsk
Eof "disk.image" (its shorter than the 720k disk itself)

3 more minutes for step 9 and I know if I have a good write.  You can do the 
setfdprm 100 times and it fails silently everytime, but attack it with dd once, 
and /dev/fd0 gets well and works.  4 or 5 years ago it all worked straight off 
with the tools we had then.

FWIW, kernel is now 2.6.26-rc4, stable so far with a 49 hour uptime.

Hell of a way to run a train, guys, really. :)

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Ambidextrous, adj.:
	Able to pick with equal skill a right-hand pocket or a left.
		-- Ambrose Bierce, "The Devil's Dictionary"
