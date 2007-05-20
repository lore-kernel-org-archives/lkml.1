Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbXETKSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbXETKSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXETKSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:18:38 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:10399 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbXETKSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:18:38 -0400
Date: Sun, 20 May 2007 12:18:00 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] local_softirq_pending storm
Message-ID: <20070520101800.GC9892@osiris.ibm.com>
References: <200705091942.22920.kernel@prachanda.hub> <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos> <200705191525.28400.kernel@prachanda.hub> <1179601868.12981.127.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179601868.12981.127.camel@chaos>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 09:11:08PM +0200, Thomas Gleixner wrote:
> On Sat, 2007-05-19 at 15:25 +0530, Anant Nitya wrote:
> > > No idea. I uploaded a debug patch against 2.6.22-rc1 to
> > >
> > > http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch
> > >
> > > Can you give it a try and report the output ?
> > Hi
> > Here it goes 
> > [  159.646196] NOHZ softirq pending 22 on CPU 0
> > [  159.646207] .... task state: 1 00000000
> 
> 1 == TASK_INTERRUPTIBLE, so we know that ksoftirqd was not woken up. At
> least it is not a scheduler problem.
> 
> I work out a more complex debug patch and pester you to test once I'm
> done.

I've also tons of 'NOHZ: local_softirq_pending 08' that disappear with
nohz=off. But I'm still running 2.6.21. Are there any patches that should
fix this?
Machine is a Lenovo T60p:

i686 Intel(R) Core(TM)2 CPU T7600  @ 2.33GHz GenuineIntel GNU/Linux

Besides that I get a lot of clock skews on 'make headers_check', but
these are unrelated to nohz:

  CHECK   include/asm/dasd.h
make[2]: warning:  Clock skew detected.  Your build may be incomplete.
make[2]: Warning: File `/dev/null' has modification time 5.1e+03 s in the future
