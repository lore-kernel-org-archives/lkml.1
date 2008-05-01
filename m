Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYEADyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYEADyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 23:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYEADxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 23:53:53 -0400
Received: from cpsmtpo-eml01.kpnxchange.com ([213.75.38.150]:14064 "EHLO
	cpsmtpo-eml01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbYEADxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 23:53:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 05:53:48 +0200
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, w@1wt.eu, davem@davemloft.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jirislaby@gmail.com
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org> <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
In-reply-To: <alpine.LFD.1.10.0804301831330.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805010553.50264.elendil@planet.nl>
X-OriginalArrivalTime: 01 May 2008 03:53:50.0899 (UTC) FILETIME=[F783C830:01C8AB3E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> IOW, I argue that the high speed of merging very much is a big part of
> what gives us quality in the end. It may result in bugs along the way, but
> it also results in fixes, and lots of people looking at the result (and
> looking at it in *context*, not just as a patch flying around).

The main problem as I see it is with the huge number of hard, confirmed bugs 
that are *not* getting fixed.

With the current development model, developers only really care about 
current regressions. In a large part this is due to the excellent work of 
Rafael with his tracking of regressions since the previous release.
But it does mean older regressions fall by the wayside, even if they've been 
confirmed, bisected and the submitter is responsive.
For a while Natalie Protasevich did some work on trying to get attention for 
older regressions, but that effort seems to have died out.

Two concrete examples from my personal experience:
- http://bugzilla.kernel.org/show_bug.cgi?id=9749; the error:
  sysctl table check failed:
  /dev/parport/parport0/devices/ppdev0/timeslice  Sysctl already exists
  First reported for 2.6.24-rc5, just now confirmed with 2.6.25
  Acknowledged by maintainer, but no follow-up [1].

- http://bugzilla.kernel.org/show_bug.cgi?id=9310; the error:
  completely blank console with FRAMEBUFFER_CONSOLE_DETECT_PRIMARY set when
  framebuffer is active, but no VGA=xxx parameter is passed
  First reported for 2.6.23, confirmed for 2.6.24-rc6, almost certainly
  still present in 2.6.25
  Acknowledged by maintainer, but no follow-up despite later pings.


Another issue is that sometimes developers really are too eager to get their 
changes into mainline even when there are known issues or when they know in 
their heart that the changes have not received enough testing.

Example is a a scheduler change [2] that causes a completely reproducible 
regression (music skips and key repeats) on my box with one specific 
workload. Ingo and Peter have been great doing debugging after I reported 
it for 2.6.25-rc8 and it was reverted just before the release, but I was 
very surprised to see the patch resubmitted for 2.6.26 without the 
regression being resolved first.
It is now confirmed to still be there and there has been additional effort 
on it, but so far without result.

This really is nothing against Ingo (in fact he is in my experience one of 
the most responsive developers when issues are reported), but in this case 
I personally do feel the patch should not have been reintroduced into 
mainline before the regression had been sorted out.

Cheers,
FJP

[1] Update: Eric just added a nice reply in Bugzilla.
[2] http://bugzilla.kernel.org/show_bug.cgi?id=10428
    http://lkml.org/lkml/2008/4/19/181
