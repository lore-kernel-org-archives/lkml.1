Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXDLTob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXDLTob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 15:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDLTob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 15:44:31 -0400
Received: from gw.goop.org ([64.81.55.164]:45301 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbXDLTo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 15:44:29 -0400
Message-ID: <461E8BF9.5000402@goop.org>
Date: Thu, 12 Apr 2007 12:43:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@novell.com>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
References: <20070411162904.232696302@mvista.com>	<200704121136.03098.ak@novell.com>	<20070412092348.70a4de05.akpm@linux-foundation.org>	<200704121845.39961.ak@novell.com>	<20070412100039.00ace23f.akpm@linux-foundation.org>	<461E6FA7.5080605@goop.org> <20070412105559.385789dd.akpm@linux-foundation.org>
In-Reply-To: <20070412105559.385789dd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> blktrace.  I've seen a couple of trace/debug-style things which use
> sched_clock for timestamping event collection. I think lttng does exotic
> things with TSCs, performing private skew correction, although that might
> have changed now.
>   

I'm not worried about things using the tsc directly.  But since we hook
into sched_clock, anyone using it is going to get the pv_ops backend's
behaviour, which is targeted at making the scheduler work properly
rather than all these secondary uses.

    J
