Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYJCPWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYJCPWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbYJCPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:22:38 -0400
Received: from mga05.intel.com ([192.55.52.89]:56061 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754025AbYJCPWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:22:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,357,1220252400"; 
   d="scan'208";a="623036574"
Message-ID: <48E638B5.9040204@linux.intel.com>
Date: Fri, 03 Oct 2008 08:22:29 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jan Kasprzak <kas@fi.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: IRQ balancing on a router
References: <20081003132117.GM16624@fi.muni.cz> <20081003063857.76b7b61a@linux.intel.com> <20081003145737.GQ16624@fi.muni.cz>
In-Reply-To: <20081003145737.GQ16624@fi.muni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak wrote:
> Arjan van de Ven wrote:
> : Jan Kasprzak <kas@fi.muni.cz> wrote:
> : > The result is
> : > that the CPU which receives IRQs for the uplink interface
> : > is 100 % busy (softirq mostly), while the other one is 90% idle.
> : 
> : one of the hard cases for irqbalance is that irqbalance doesn't have a
> : way to find out the actual cpu time spend in the handlers. For
> : networking it makes an estimate just based on the number of packets
> : (which is better than nothing)... but that breaks down if you have an
> : non-symmetry in CPU costs per packet like you have.
> : 
> : The good news is that irqthreads at least have the potential to solve
> : this "lack of information"; if not, we could consider doing a form of
> : microaccounting for irq handlers....
> 
> 	I am not sure whether this would help. In my case, the most of the
> in-kernel CPU time is not spend in the irq handler per se, but in softirq
> (i.e. checking the packet against iptables rules).

there is some consideration of making softirqs that are raised run as part of the irq thread.
or at least thoughts in that direction.
