Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXCWCVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXCWCVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 22:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbXCWCVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 22:21:50 -0400
Received: from holomorphy.com ([66.93.40.71]:53219 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112AbXCWCVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 22:21:49 -0400
Date: Thu, 22 Mar 2007 19:21:40 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: RSDL 0.31 causes slowdown
Message-ID: <20070323022140.GO2986@holomorphy.com>
References: <1174598506.23795.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174598506.23795.62.camel@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 01:21:46PM -0800, Tim Chen wrote:
> I've tried running Volanomark and found a 80% regression
> with RSDL 0.31 scheduler on 2.6.21-rc4 on a 2 socket Core 2 quad cpu
> system (4 cpus per socket, 8 cpus for system). 
> The results are sensitive to rr_interval. Using Con's patch to increase
> rr_interval to a large value of 100, 
> the regression reduced to 30% instead of 80%.
> I ran Volanomark in loopback mode with 10 chatrooms 
> (20 clients per chatroom) configuration, with each client sending
> out 10000 messages. 
> http://www.volano.com/benchmarks.html
> There are significant differences in the vmstat runqueue profile 
> between the 2.6.21-rc4 and the one with RSDL.  
> There are a lot less runnable jobs (see col 2) with RSDL 0.31 
> (rr_interval=15) and higher idle time.

This would be yield() semantics. A flag or alternate syscall for "hard"
yield() semantics would resolve this (likely trapped into via LD_PRELOAD).
It may also be useful to have a few variants of yield_to() (a.k.a.
directed yields), such as ones donating timeslices by pid, by owner of
sysv semaphore, by owner of futex, and to other ends of pipes and UNIX
domain sockets if unique or otherwise able to be made sense of. It's
unclear how easily the latter could be utilized by userspace, though,
given the number of applications and libraries needing to be updated.


-- wli
