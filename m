Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbXCJUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbXCJUlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 15:41:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXCJUlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 15:41:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:46209 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbXCJUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 15:41:41 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 12:41:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
In-Reply-To: <1173556374.2958.12.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703101230010.29503@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com> 
 <1173508384.3108.1.camel@entropy>  <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
  <1173509019.3108.4.camel@entropy>  <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
  <1173510568.3108.17.camel@entropy>  <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
 <1173556374.2958.12.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Nicholas Miell wrote:

> Try reading the timer_create man page.
> 
> In short, you're limited to a single clock, so you can't set timers
> based on wall-clock time (subject to NTP correction), monotomic time
> (not subject to NTP, will not ever go backwards or skip ticks), the
> high-res versions of the previous two clocks, per-thread or per-process
> CPU usage time, or any other clocks that may get introduced in the
> future.

One timer per fd yes. So?
The real-time and monotonic selection can be added. 
If you look at the posix timers code, that's a bunch of code over the real 
meat of it, that is hrtimer.c. The timerfd interface goes straight to 
that, without adding yet another meaning to the sigevent structure, and 
yet another case inside the posix timers trigger functions. That will be 
as unstandard as timerfd is, and even more, since you cannot use that 
interface and hope to be portable in any case.
On top of that, handing over files to the posix timers will creates 
problems with references kept around.
The timerfd code is just a *really* thin layer (if you exclude the 
includes, the structure definitions and the fd setup code, there's 
basically *nothing*) over hrtimer.c and does not mess up with other kernel 
code in any way, and offers the same functionalities. I'd like to keep it 
that way.



- Davide


