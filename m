Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYDEAu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYDEAu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 20:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYDEAut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 20:50:49 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:39480 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDEAus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 20:50:48 -0400
Date: Sat, 05 Apr 2008 02:50:47 +0200
Message-Id: <226243507@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: rogerheflin@gmail.com
Cc: dan.hecht@vmware.com, johnstul@us.ibm.com, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org
Subject: =?iso-8859-15?Q?Re:_Clock_has_stopped_(time/date_looping_over_5_second?=
 =?iso-8859-15?Q?s),_things_are?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18Ubf5AqZwOLuY1Dp13Kb0qP3VT1WAvPgtUpIaPtizpgf21Z
 nduGPWNpUknvbIojdj7sb6sBwzmz5n2wLfckRgHkhMxUHZCeAo=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so, this happens on real hardware for you?

i could reproduce this with a linux virtual machine on vmware - whenever i suspended the windows host with a linux vm running in vmware, after resume the linux vm showed exactly this issue.
after some investigation i found, that it would recover from that state after some time - and the time needed for recover was (more or less) proportional to that time the host was in suspend(hibernate) state.

also see http://marc.info/?l=linux-kernel&m=120186717701371&w=2

i thought that was vmware related and i gave a bug report to dan hecht - i didn`t hear anything since then, but i think it`s worth CC`ing him.

not sure if 
[PATCH 1/2] Introduce clocksource_forward_now -> http://marc.info/?l=linux-kernel&m=120716471203567&w=2
[PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW -> http://marc.info/?l=linux-kernel&m=120596518521892&w=2 
is related ? (also CC`d the patch authors, they will probably know)

regards
roland



List:       linux-kernel
Subject:    Clock has stopped (time/date looping over 5 seconds), things are
From:       Roger Heflin <rogerheflin () gmail ! com>
Date:       2008-04-04 21:27:11
Message-ID: 47F69D2F.8010607 () gmail ! com
[Download message RAW]

So far what I have is that the clock is moving between
10:01:03 to 10:01:07 (when it gets to 07 it goes back to 03), doing rdate -s
results in things changing:

16:12:38 to 16:12:43 (resets back to :38).

Doing this:
while true ; do date; usleep 1000000; done
Fri Apr  4 16:12:39 CDT 2008
Fri Apr  4 16:12:40 CDT 2008
Fri Apr  4 16:12:41 CDT 2008
Fri Apr  4 16:12:42 CDT 2008
Fri Apr  4 16:12:43 CDT 2008

It stops at :43, ^C is required, and you can then restart it with repeatable 
results.

This F7 - 2.6.23.15-80.fc7

dmesg/messages contain nothing abnormal.

This machine has done it several times, a freqency of maybe 1x per every couple 
of weeks or so.   I believe it had also done this with: 2.6.22.9-91.fc7 so it
has been doing this for a while.   It used to work with some older kernel (I 
don't know which).

Given what the clock is doing, things that sleep at the wrong time hang forever, 
and a number of other things fail to work.

vmstat 1 results in a single line being printed out, and then a floating point 
exception.

"shutdown -r now" fails to complete, power cycle is required to get the machine
back up.

I don't believe any hardware failure that I can think of would cause the clock 
to do what mine is doing.

Ideas?

                                Roger
_________________________________________________________________________
Mit der Gruppen-SMS von WEB.DE FreeMail können Sie eine SMS an alle 
Freunde gleichzeitig schicken: http://freemail.web.de/features/?mc=021179



