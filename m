Return-Path: <linux-kernel-owner+w=401wt.eu-S1756555AbYBIH6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555AbYBIH6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYBIH6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:58:45 -0500
Received: from mail.gmx.net ([213.165.64.20]:45517 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752048AbYBIH6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:58:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0IbxBhAf0pUDgrPEXjlRdQOqZzyqBw4qinvGjAB
	kI3FJJmKXM0lL8
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
	threads
From: Mike Galbraith <efault@gmx.de>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080209000456.GA21021@lixom.net>
References: <20080209000456.GA21021@lixom.net>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 08:58:39 +0100
Message-Id: <1202543920.9578.3.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-08 at 18:04 -0600, Olof Johansson wrote:
> Hi,
> 
> I ended up with a customer benchmark in my lap this week that doesn't
> do well on recent kernels. :(
> 
> After cutting it down to a simple testcase/microbenchmark, it seems like
> recent kernels don't do as well with short-lived threads competing
> with the thread it's cloned off of. The CFS scheduler changes come to
> mind, but I suppose it could be caused by something else as well.
> 
> The pared-down testcase is included below. Reported runtime for the
> testcase has increased almost 3x between 2.6.22 and 2.6.24:
> 
> 2.6.22: 3332 ms
> 2.6.23: 4397 ms
> 2.6.24: 8953 ms
> 2.6.24-git19: 8986 ms

My 3GHz P4 shows disjointed results.

2.6.22.17-smp
time 798 ms
time 780 ms
time 702 ms

2.6.22.17-cfs-v24.1-smp
time 562 ms
time 551 ms
time 551 ms

2.6.23.15-smp
time 254 ms
time 254 ms
time 293 ms

2.6.23.15-cfs-v24-smp
time 764 ms
time 791 ms
time 780 ms

2.6.24.1-smp
time 815 ms
time 820 ms
time 771 ms

2.6.25-smp (git today)
time 29 ms
time 61 ms
time 72 ms


