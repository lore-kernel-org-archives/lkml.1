Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbXCJWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbXCJWa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXCJWa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:30:57 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46257 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXCJWaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:30:55 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 14:30:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173560473.2958.23.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703101424060.3679@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
  <1173556374.2958.12.camel@entropy>  <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
 <1173560473.2958.23.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Nicholas Miell wrote:

> I never complained about one timer per fd (although, now that you
> mention it, that would get a bit excessive if you have thousands of
> outstanding timers).

Right, of course.



> > The real-time and monotonic selection can be added. 
> 
> IOW, the timerfd patch is not suitable for inclusion as-is. (While
> you're at it, you should probably add a flags argument for future
> expansion.)

That's already in.



> > If you look at the posix timers code, that's a bunch of code over the real 
> > meat of it, that is hrtimer.c. The timerfd interface goes straight to 
> > that, without adding yet another meaning to the sigevent structure,
> 
> That's what the sigevent structure is for -- to describe how events
> should be signaled to userspace, whether by signal delivery, thread
> creation, or queuing to event completion ports. If if you think
> extending it would be bad, I can show you the line in POSIX where it
> encourages the contrary.

I'm sorry, I already explained you that linking the two (files and posix 
timers) is going to create more troubles than it actually solves.
The timerfd code provides the same functionality, with zero intrusion in 
existing code, and basically zero code (once if you remove the usual fd 
creation/cleanup).
The code of adding posix timers support would be *all* the existing one
(that is already a thin wrapper that calls hrtimer.c support - like 
posix timers do), plus adding more crud into the posix timers code, plus 
adding file references handling. If *you* want to do that, I can open you 
a door into the timerfd.




- Davide


