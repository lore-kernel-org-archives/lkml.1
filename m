Return-Path: <linux-kernel-owner+w=401wt.eu-S1752626AbZIASg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbZIASg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbZIASgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:36:55 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56866 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbZIASgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:36:55 -0400
Date: Tue, 1 Sep 2009 18:35:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Josh Triplett <josh@joshtriplett.org>
cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
       Tim Pepper <lnxninja@linux.vnet.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       John Stultz <johnstul@us.ibm.com>, Jamey Sharp <jamey@minilop.net>
Subject: Re: [RFC PATCH] Turn off the tick even when not idle
In-Reply-To: <20090901180825.GA3621@josh-work.beaverton.ibm.com>
Message-ID: <alpine.DEB.1.10.0909011831530.25607@V090114053VZO-1>
References: <20090901154327.GA10024@feather> <alpine.DEB.1.10.0909011554590.12112@V090114053VZO-1> <20090901180825.GA3621@josh-work.beaverton.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Josh Triplett wrote:

> Thanks; exactly what I hoped to demonstrate.  Actually making the timer
> interrupt go away will require finding a more appropriate place to run
> all the code that otherwise polls periodically, but this patch lets us
> cheat and see the result before that happens. :)

Well not necessarily. Since the process is not doing system calls some of
the checks can be skipped. In order to bring about a quiet state for the
VM one could fold the vm counters and dump the queues. Then maintenance is
unnecessary as long as no system activity occurs on a processor.

> I ran the benchmark at realtime priority, and affinitized to a single
> CPU.  I used ftrace to confirm that after the initial program setup
> (shared library loads, memory allocation, etc), no code runs in the
> kernel during the number-crunching; this makes sense, since I ran at
> higher priority than all the random affinitized kernel threads, and I
> pushed everything else (tasks and interrupts) onto another CPU.

Interesting.

> Long-term I'd like to solve the problem of those kernel threads, but
> realtime priority can mitigate those.  The new interrupt threading bits
> may help with other interrupts and avoid the need to set interrupt
> affinity.  The timer interrupt, though, represents the one and only
> thing I can't mitigate, hence why I'd like to make it go away.

Well it would be best if we can guarantee that there is no system activity
starting. What you have done is analyze all the causes for your particular
situation and mitigated them. Not everyone is a specialist able to figure
out these causes.

