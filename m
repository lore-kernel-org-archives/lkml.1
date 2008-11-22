Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYKVKJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYKVKJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 05:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYKVKJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 05:09:40 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:25149 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYKVKJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 05:09:39 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] sched: add locking when update the task_group's
 cfs_rq[] array.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Ken Chen <kenchen@google.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
In-Reply-To: <49248A35.4080401@nortel.com>
References: <b040c32a0811182248s1174c82avf44c720ae2d14804@mail.gmail.com>
	 <1227113662.29743.46.camel@lappy.programming.kicks-ass.net>
	 <b040c32a0811190921g557edc4dy4725fb86107c2c54@mail.gmail.com>
	 <1227128331.29743.61.camel@lappy.programming.kicks-ass.net>
	 <49248A35.4080401@nortel.com>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 11:09:35 +0100
Message-Id: <1227348575.7685.19024.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-19 at 15:50 -0600, Chris Friesen wrote:
> Peter Zijlstra wrote:
> 
> > Will it scale, half-way, I'd say. It races a little, but should
> > converge. The biggest issue is that we're running with 10 bit fixed
> > point math, and on large cpu machines you get into granularity problems.
> 
> Is there any way to get higher resolution math on 64-bit machines?  (I'm 
> assuming that most larger SMP boxes will be 64-bit capable.)

Yes, if we do the same thing we do for 64bit math on 32bit boxen to
obtain 128bit math on 64bit boxen.

Trouble seems to be gcc, which imho f*'ed up by not providing a long
long long (or whatever), there does seem to be something but all the gcc
people tell me its fragile and not to be used.

Anyway, I've been meaning to send a RFC to linux-arch about adding
something like this, which we'd then have to do our-selves with C
functions instead of nice integer types :/

