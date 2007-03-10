Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXCJTw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXCJTw6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbXCJTw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:52:58 -0500
Received: from sccrmhc11.comcast.net ([63.240.77.81]:37636 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbXCJTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:52:57 -0500
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
	 <1173510568.3108.17.camel@entropy>
	 <Pine.LNX.4.64.0703092323370.28135@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 11:52:54 -0800
Message-Id: <1173556374.2958.12.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 23:36 -0800, Davide Libenzi wrote:
> On Fri, 9 Mar 2007, Nicholas Miell wrote:
> 
> > On Fri, 2007-03-09 at 22:53 -0800, Davide Libenzi wrote:
> > > On Fri, 9 Mar 2007, Nicholas Miell wrote:
> > > > 
> > > > So extend the existing POSIX timer API to deliver expiry events via a
> > > > fd.
> > > 
> > > It'll be out of standard as timerfd is, w/out code savings. Look at the 
> > > code and tell me what could be saved. Prolly the ten lines of the timer 
> > > callback. Lines that you'll have to drop inside the current posix timer 
> > > layer. Better leave standards alone, especially like in this case, when 
> > > the savings are not there.
> > > 
> > 
> > OK, here's a more formal listing of my objections to the introduction of
> > timerfd in this form:
> > 
> > A) It is a new general-purpose ABI intended for wide-scale usage, and
> > thus must be maintained forever.
> 
> Yup
> 
> 
> > B) It is less functional than the existing ABIs -- modulo their
> > "delivery via signals only" limitation, which can be corrected (and has
> > been already in other operating systems).
> 
> Less functional? Please, do tell me ...
> 

Try reading the timer_create man page.

In short, you're limited to a single clock, so you can't set timers
based on wall-clock time (subject to NTP correction), monotomic time
(not subject to NTP, will not ever go backwards or skip ticks), the
high-res versions of the previous two clocks, per-thread or per-process
CPU usage time, or any other clocks that may get introduced in the
future.

In addition, you've introduced an entirely new incompatible API that
probably doesn't fit easily into existing software that already uses
POSIX timers.


> 
> > C) Being an entirely new creation that completely ignores past work in
> > this area, it has no hope of ever getting into POSIX.
> > 
> > which means
> > 
> > D) At some point in time, Linux is going to get the POSIX version (in
> > whatever form it takes), making this new ABI useless dead weight (see
> > point A).
> 
> Adding parameters/fields to a standard is going to create even more 
> confusion than a new *single* function. And the code to cross-link the 
> timerfd and the current posix timers is going to end up in being more 
> complex than the current one.
> 

Yes, but the standard explicitly allows you to do this. Furthermore, if
you work within the existing framework, you can lobby for the inclusion
of your API in the next version of POSIX.

Simplicity of the code is only a virtue if you don't have to do the
exact same thing again with a different interface later while keeping
the maintenance burden of the existing proprietary (and, thus,
unpopular) interface.

-- 
Nicholas Miell <nmiell@comcast.net>

