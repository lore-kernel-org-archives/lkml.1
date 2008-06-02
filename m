Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbYFBAu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbYFBAu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 20:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFBAus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 20:50:48 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:47702 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFBAur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 20:50:47 -0400
Date: Sun, 01 Jun 2008 20:50:29 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: floppy question of the hour
In-reply-to: <alpine.LNX.1.10.0806012053440.4055@fbirervta.pbzchgretzou.qr>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Message-id: <200806012050.30124.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200805232114.20937.gene.heskett@gmail.com>
 <200805271826.18320.gene.heskett@gmail.com>
 <alpine.LNX.1.10.0806012053440.4055@fbirervta.pbzchgretzou.qr>
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008, Jan Engelhardt wrote:
>On Wednesday 2008-05-28 00:26, Gene Heskett wrote:
>>On Tuesday 27 May 2008, Phillip Susi wrote:
>>>Gene Heskett wrote:
>>
>>Also, does anyone know how long after a floppy is inserted before it is
>>recognized?  From observation today, it appears to be something in the 5
>> minute territory before a getfdprm returns data instead of "/dev/fd0: no
>> such device".
>
>I have a SONY USB floppy drive which used to get read within 2s
>after inserting a new floppy. Which means it somehow signalled
>the host, probably through an USB command.
>
>Just as I tried again now (with 2.6.23.17), this does not happen
>anymore so I suspect udev or the kernel changed in some way.

This is attached directly to end connector on the 34 pin floppy cable.

What I have found that seems to work, is to put the disk in, then hit it with a 
junk, 1 block read from dd.  That will take about 25-30 seconds to fail with an 
I/O error.

Then I can do the 'setfdprm' thing, check it with getfdprm, and go ahead and 
write the disk image with dd.

But if I don't knock on the door & fail once, just relying on getting a good 
response from getfdprm from the setfdprm operation before trying dd, it will 
_never_ work.  It has to be hammered on by dd before setfdprm and getfdprm will 
work, and then dd can write to it just fine.

Houston, we have a problem.  But I now know how to work around it sorta like 
McGiver would do I guess, but what about the next user who will never see this 
thread without a truly diligent search?  He will be similarly screwed, but the 
only heavy breathing will be from frustration.

If the kernel should somehow shrink so it could fit on a floppy again, I'd bet 
this would be fixed yet this week. :)  But we all know what the chances of that 
happening are. :(  It would however, be muchly appreciated by us old farts 
using floppies to get stuff to/from a legacy computer.

Thanks guys.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Wash: "It's Jayne being so generous with his cut that confuses and frightens
me."

Zoe: "It does kind of freeze the blood."
				--Episode #10, "War Stories"
