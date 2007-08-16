Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbXHPWXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbXHPWXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbXHPWWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:22:51 -0400
Received: from ozlabs.org ([203.10.76.45]:57812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbXHPWWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:22:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18116.52784.132826.595409@cargo.ozlabs.ibm.com>
Date: Fri, 17 Aug 2007 08:22:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: Michael Neuling <mikey@neuling.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting
In-Reply-To: <20070816163850.GU4261@austin.ibm.com>
References: <20070816070922.37B5370074@localhost.localdomain>
	<20070816163850.GU4261@austin.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linas Vepstas writes:

> My gut impression (maybe wrong?) is that the scaled time is,
> in a certain sense, "more accurate" than the unscaled time.

The "unscaled" time is just time, as in "how many seconds did this
task spend on the CPU".  It's what all the tools (except a certain
proprietary workload manager) expect.  Top, ps, etc. get unhappy if
the times reported (user, system, hardirq, softirq, idle, stolen)
don't add up to elapsed wall-clock time.

The "scaled" time is really CPU cycles divided by some arbitrary
factor (the notional CPU frequency).  So yes it does give some
indication of how much progress the task should have made, in some
sense.

Both measures are useful.  Because the current user API is in terms of
real time rather than cycles, we have to continue reporting real time,
not scaled time, which is why the existing interfaces report unscaled
time, and the scaled time values are reported through a new extension
to the taskstats interface.

Paul.
