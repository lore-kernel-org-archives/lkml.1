Return-Path: <linux-kernel-owner+w=401wt.eu-S1761065AbYBFWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761065AbYBFWBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbYBFWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:01:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43081 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYBFWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:01:39 -0500
Subject: Re: [Regression] 2.6.24-git9: RT sched mishandles artswrapper
	(bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <200802062250.07758.rjw@sisk.pl>
References: <200802010237.59320.rjw@sisk.pl>
	 <200802061925.19474.rjw@sisk.pl> <1202334228.6274.1.camel@lappy>
	 <200802062250.07758.rjw@sisk.pl>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 23:01:00 +0100
Message-Id: <1202335261.6274.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-06 at 22:50 +0100, Rafael J. Wysocki wrote:
> On Wednesday, 6 of February 2008, Peter Zijlstra wrote:

> > Well, that whole queue.
> 
> It doesn't compile for me.

I did solve some compile issues since posting, Ingo should have the
compiling version in sched-devel soonish (don't know if he pushed it
already).

> > Your test program just failed to obtain realtime scheduling
> 
> Well, it shouldn't.  The expected result is to obtain realtime scheduling
> or we will break existing setups.

Thats a case of wrong expectations in my book. You enabled group
scheduling and hence behaviour changes. There is just nothing much one
can do about it, if you don't assign bandwidth to a group, it won't be
able to run anything. Better to refuse to run, than to sit idle, right?

But I appreciate the situation, therefore I made the whole rt-group
scheduling a separate .config option (which defaults to n)

