Return-Path: <linux-kernel-owner+w=401wt.eu-S933507AbXCJHOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507AbXCJHOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933511AbXCJHOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:14:33 -0500
Received: from alnrmhc14.comcast.net ([204.127.225.94]:56124 "EHLO
	alnrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933507AbXCJHOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:14:32 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 02:14:32 EST
Subject: Re: [patch 6/9] signalfd/timerfd v1 - timerfd core ...
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703091535360.3761@alien.or.mcafeemobile.com>
	 <1173508384.3108.1.camel@entropy>
	 <Pine.LNX.4.64.0703092235430.28135@alien.or.mcafeemobile.com>
	 <1173509019.3108.4.camel@entropy>
	 <Pine.LNX.4.64.0703092248420.28135@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 23:09:28 -0800
Message-Id: <1173510568.3108.17.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 22:53 -0800, Davide Libenzi wrote:
> On Fri, 9 Mar 2007, Nicholas Miell wrote:
> 
> > On Fri, 2007-03-09 at 22:38 -0800, Davide Libenzi wrote:
> > > On Fri, 9 Mar 2007, Nicholas Miell wrote:
> > > 
> > > > Why did you ignore the existing POSIX timer API?
> > > 
> > > The existing POSIX API is a standard and a very good one. Too bad it does 
> > > not deliver to files. The timerfd code is, as you can probably read from 
> > > the code, a really thin wrapper around the existing hrtimer.c Linux code.
> > 
> > So extend the existing POSIX timer API to deliver expiry events via a
> > fd.
> 
> It'll be out of standard as timerfd is, w/out code savings. Look at the 
> code and tell me what could be saved. Prolly the ten lines of the timer 
> callback. Lines that you'll have to drop inside the current posix timer 
> layer. Better leave standards alone, especially like in this case, when 
> the savings are not there.
> 

OK, here's a more formal listing of my objections to the introduction of
timerfd in this form:

A) It is a new general-purpose ABI intended for wide-scale usage, and
thus must be maintained forever.

B) It is less functional than the existing ABIs -- modulo their
"delivery via signals only" limitation, which can be corrected (and has
been already in other operating systems).

C) Being an entirely new creation that completely ignores past work in
this area, it has no hope of ever getting into POSIX.

which means

D) At some point in time, Linux is going to get the POSIX version (in
whatever form it takes), making this new ABI useless dead weight (see
point A).


-- 
Nicholas Miell <nmiell@comcast.net>

