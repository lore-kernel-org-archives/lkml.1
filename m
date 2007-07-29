Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXG2DBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXG2DBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 23:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbXG2DBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 23:01:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118AbXG2DB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 23:01:29 -0400
Message-ID: <46AC02FA.8060303@redhat.com>
Date: Sat, 28 Jul 2007 23:01:14 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Tong Li <tong.n.li@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>  <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu>  <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com>  <20070725192442.GC4463@elte.hu>  <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>  <20070726213154.GA26569@elte.hu> <1185487225.3122.11.camel@tongli.jf.intel.com> <Pine.LNX.4.64.0707261806450.5321@tongli.jf.intel.com> <46AA287D.8070200@redhat.com> <Pine.LNX.4.64.0707271159420.12201@tongli.jf.intel.com> <46AA8171.2060400@redhat.com> <Pine.LNX.4.64.0707281121580.22772@tongli.jf.intel.com>
In-Reply-To: <Pine.LNX.4.64.0707281121580.22772@tongli.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tong Li wrote:
> Without the global locking, the global synchronization here is simply 
> ping-ponging a cache line once of while. This doesn't look expensive to 
> me, but if it does after benchmarking, adjusting sysctl_base_round_slice 
> can reduce the ping-pong frequency. There might also be a smart 
> implementation that can alleviate this problem.

Scaling it proportionally to migration cost and log2(cpus) should suffice.

> I don't understand why quantizing CPU time is a bad thing. Could you 
> educate me on this?

It depends on how precisely you do it.  We save a lot of power going 
tickless.  If round expiration is re-introducing ticks on idle CPUs, we 
could waste a lot of power.  Hardware is getting even more aggressive 
about power saving, to the point of allowing individual cores to be 
completely powered off when idle.  We need to make sure the scheduler 
doesn't interfere with power management.

	-- Chris
