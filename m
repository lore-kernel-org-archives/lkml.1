Return-Path: <linux-kernel-owner+w=401wt.eu-S934176AbXC0TPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176AbXC0TPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934193AbXC0TPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 15:15:45 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36961 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbXC0TPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 15:15:44 -0400
Date: Tue, 27 Mar 2007 21:15:42 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] fix setting of preempt_max_latency and preempt_thresh on 64 bit systems
Message-ID: <20070327191542.GA15514@rhlx01.hs-esslingen.de>
References: <1175015947.19634.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175015947.19634.6.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 27, 2007 at 01:19:07PM -0400, Steven Rostedt wrote:
> Ingo,
> 
> I wasn't able to turn on latency tracing on a x86_64 box. Using logdev
> to see what was happening, I found that echoing 0
> into /proc/sys/kernel/preempt_max_latency would only change the max from
> -1ULL to 0xffffffff00000000. Which would keep the max pretty high still.
> 
> The problem is in sysctl.c where preempt_max_latency can be modified. On
> systems where cycle_t is greater than the size of int (x86_64) we only
> write to the 4 LSB.

Maybe fix up all the other myriads of sysctl entries which use a rather
non-precise generic sizeof(int) as well?
Or doesn't that make sense?
Maybe this is because it's security relevant and you'd better make sure
to know *exactly* the number of integers a buffer's length is supposed to be?

Thanks,

Andreas Mohr
