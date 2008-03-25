Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbYCYQrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbYCYQrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYCYQrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:47:15 -0400
Received: from picture.zai.com ([12.47.112.36]:22448 "EHLO york.rivers.zai.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750910AbYCYQrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:47:14 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
Subject: RE: Performance changes between 2.6.13 and 2.6.23
Date: Tue, 25 Mar 2008 12:44:11 -0400
Message-ID: <D108F32273D3044F8C7B24328CB7713701A4D6@york.rivers.zai.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Performance changes between 2.6.13 and 2.6.23
Thread-Index: AciOlymCeeQuivWGS0O+LQR8samsugAAEovg
References: <D108F32273D3044F8C7B24328CB7713701A4D1@york.rivers.zai.com> <2c0942db0803250941j65be093et718bb838a2779e9c@mail.gmail.com>
From: "Sanders, Rob M." <sanders-rob@zai.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Cc: <linux-kernel@vger.kernel.org>, <bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




-----Original Message-----
From: madrabbit@gmail.com on behalf of Ray Lee
Sent: Tue 3/25/2008 12:41 PM
To: Sanders, Rob M.
Cc: linux-kernel@vger.kernel.org; bart.vanassche@gmail.com
Subject: Re: Performance changes between 2.6.13 and 2.6.23
 
On Tue, Mar 25, 2008 at 5:34 AM, Sanders, Rob M. <sanders-rob@zai.com> wrote:
> Hello all,
>   I've been lurking on the digest for some time (don't want to receive full lkml traffic at work) and saw the
>  posts about Wine performance regressions in 2.6.24.  Some of what I saw there, particularly Andi Kleen's
>  responses, mirror something that I see on my box at home.  I had emailed Andi directly since I only read the
>  digest, and I'm posting this here at his suggestion.  Please CC: rms@zai.com with any replies, as I'm only
>  getting the lkml digest.
>   I'm running on a dual 2GHZ G5 Powermac w/2GB ram.  I recently upgraded from YDL4.0.91 (2.6.13 kernel) to
>  YDL6 (2.6.23 kernel) and noticed that the overall performance of the box seems more sluggish after the upgrade.
>  Of more particular concern, the main application that I build has seen a 4-5X slowdown in performance.  Under
>  YDL4.0.91 I could process roughly 1e8 data points in ~2 seconds, and under YDL6.0 I now process 1e8 data points

So, two processors, and multiple processes passing data back and
forth. Key point seems to be:

>  in ~8 seconds.  Total CPU loading (from top) is about 5%, under both systems.  The application spawns multiple
>  processes and uses semaphores and shared memory to move data between the processes.  When I use 'vmstat 3' the
>  single biggest difference I see between YDL4.0.91 and YDL6 is that the YDL4.0.91 system is the YDL4.0.91 system is
>  context switching about 7000 per interval, whereas the YDl6 system is context switching about 1200 times per interval.

Many more context switches per second, so a lot less work is getting
done each time.

>   I've been talking somewhat with Owen Stampflee (works for the distro maker, TSS) and have rebuilt the kernel on
>  the 2.6 box removing some of the things that I don't need on my box (cell support, etc).  There did seem (subjectively)
>  to be a slight improvement after that.  When I get some more time to play at home I'm going to take the 2.6.13 .config
>  I use and build a 2.6.23 kernal using 'make oldconfig' and try to figure if it is a config issues.
>   I realize that going from 2.6.13 to 2.6.23 is a *huge* change, and that the problems may not be tied to the kernel
>  but to other things, but are there any other suggestions folks have for finding the cause of the performance slowdow

A lot has changed between 2.6.23 and current mainline as well.
Particularly in the scheduler, which I suspect is the issue for your
test. If possible, could you try a 2.6.25-rc-latest kernel, both
before and after an "echo 5 > /proc/sys/kernel/sched_features" and see
if that makes any difference?

===
Ray, 
  I'll add that to the list of things to try.  I do want to clarify that the YDL4 system with 7000 context switches every
3 seconds was processing 4-5 times as much data as the YLD6 system that had 1200 context switches.  The other test
I want to do is (re)install YDL5 and pull my app over to it.  I hadn't used YDL5 due to my compilers not working
on it.  I've upgraded those (at least to eval versions) now for YDL6.

Rob
