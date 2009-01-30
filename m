Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZA3OP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZA3OP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 09:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZA3OPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 09:15:11 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:45294 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZA3OPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 09:15:09 -0500
Date: Fri, 30 Jan 2009 15:15:08 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
cc: "V.Radhakrishnan" <rk@atr-labs.com>, linux-kernel@vger.kernel.org
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
In-Reply-To: <1233298113.17301.17.camel@localhost>
Message-ID: <alpine.LSU.2.00.0901301458220.29805@fbirervta.pbzchgretzou.qr>
References: <1233294584.28741.2.camel@localhost>  <1233296279.3395.13.camel@atlas> <1233298113.17301.17.camel@localhost>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-01-30 07:48, Nathanael Hoyle wrote:
>On Fri, 2009-01-30 at 11:47 +0530, V.Radhakrishnan wrote:
>> 
>> However, the kernel also supports SCHED_FIFO and SCHED_RR which supports
>> Real Time capabilities, albeit as root.
>> [...]
>> If you wish 100% smooth display, you could make it run as SCHED_FIFO
>> which means that your foldingathome would wait quietly for the movie to
>> get completed fully. What's "wrong" with that aproach, which is
>> essentially what you want ?
>
>My view of what's "wrong" with that approach is that it requires root
>privileges to boost the scheduling priority of each and every process
>(although in this case, mplayer is the issue) which I want to not be
>affected by foldingathome's CPU usage.

SCHED_FIFO is dangerous - it is easy to essentially lock up your box
simply because the process in question (e.g. video decoder) just runs
forever (e.g. bug causing busyloop, and/or others do not get to run
(no other processes in the same priority class). Or they (X.org, for
displaying your video and handling user input) run only for short
amounts of time only, giving a borked responsiveness experience to
the user.

It was about time SCHED_{BATCH,IDLE} came along ;-)

>While I happen to be root on
>this system, since it is my desktop, I would imagine there are instances
>where the root user/administrator of a system wanted to be able to run
>items which had no impact on other users, including allowing them to run
>fast and responsive applications.  Aside from that, it's a PITA to start
>mplayer playing, go renice -19 it and resume watching my movie every
>time.

Even making mplayer -19 will not completely cause FAH to get zero CPU
time if the Regular Desktop Processes Everybody Needs would already
max out the CPU.

