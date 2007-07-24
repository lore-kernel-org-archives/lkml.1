Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXGXSuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXGXSuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbXGXStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:49:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXGXStv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:49:51 -0400
Message-ID: <46A649CB.7080401@redhat.com>
Date: Tue, 24 Jul 2007 14:49:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Aaron Porter <atporter@primate.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: miserable performance of 2.6.21 under network load
References: <20070724172513.GB24543@primate.net>
In-Reply-To: <20070724172513.GB24543@primate.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Porter wrote:
> 	I'm in the process up upgrading a pool of apache servers from
> 2.6.17.8 to 2.6.21.5, and we're seeing a pretty major change in behavior.
> Under identical network load, 2.6.21 has a load average more than 3 times
> higher, cpu 0 spends well over 90% of its time in interrupts (vs ~30%
> under 2.6.17). When we hit 3k apache sessions, ksoftirqd eats 100% of cpu0
> and our network traffic drops off rapidly. The end result is that 2.6.17
> performs twice as well under this load.

Is it always CPU 0, or does it move?  Are you running irqbalance?  If you're 
running irqbalance, you can run a script that alternates between 'cat 
/proc/interrupts' and 'mpstat -P ALL 5 10' and watch the offending interrupt 
jump around between processors.  It's not as informative as oprofile, as Andi 
suggested, but it's really easy to set up.

	-- Chris
