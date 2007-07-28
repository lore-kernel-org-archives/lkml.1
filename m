Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbXG1TOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbXG1TOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 15:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXG1TNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 15:13:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59114 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXG1TNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 15:13:54 -0400
Date: Sat, 28 Jul 2007 21:13:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
Subject: Re: Linus 2.6.23-rc1
In-Reply-To: <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707282054330.15125@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
  <1185588279.1654.1.camel@localhost>  <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
 <1185615848.13701.16.camel@localhost> <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 28 2007 10:50, Linus Torvalds wrote:
>On Sat, 28 Jul 2007, Kasper Sandberg wrote:
>>
>> First off, i've personally run tests on many more machines than my own,
>> i've had lots of people try on their machines, and i've seen totally
>> unrelated posts to lkml, plus i've seen the experiences people are
>> writing about on IRC. Frankly, im not just thinking of myself.
>
>Ok, good. Has anybody tried to figure out why 3D games seem to be such a 
>special case? 

Is it specific to 3D? I would not think so. dosbox, bochs should have
the same issue. Games with "a lot of motion" usually implement their event
handling and screen drawing in a busy loop to get the maximum possible
frame rate.

Usually, only the GL thread would need to run at full power, and reducing the
input subsystem to a simple event-based loop (for example reading a pipe in
blocking mode). This could IMO makes games a bit more responsive.

However, most games combine the input subsystem and graphics output in one
thread. Due to the way CFS works, it may mean that processes get scheduled
too fair, though I'd suspect that a GL busy loop has no interactivity bonus at
all anyway in the old scheduler or SD.




I/O is also something that can hurt games in their framerate and/or handling
(something the user cares most about). Since I have not tried 2.6.23-rc yet, I
can only speak for the old scheduler. I have always turned cron off so that
updatedb does not run, because it makes games sluggish for some reason,
even though updatedb (or subordinate processes) don't take a lot of CPU time
according to `top`. What's more, running BOINC in the background (nice 20)
while running unreal (nice 0), everything is ok.
(But not if BOINC is at nice 0).

Time to investigate...



	Jan
-- 
