Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXDLRm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXDLRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbXDLRm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:42:28 -0400
Received: from gw.goop.org ([64.81.55.164]:53842 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXDLRm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:42:27 -0400
Message-ID: <461E6F5F.1030008@goop.org>
Date: Thu, 12 Apr 2007 10:41:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@novell.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
References: <20070411162904.232696302@mvista.com> <200704121136.03098.ak@novell.com> <20070412092348.70a4de05.akpm@linux-foundation.org> <200704121845.39961.ak@novell.com>
In-Reply-To: <200704121845.39961.ak@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Ok. I think it's better to just fix sched_clock() again than to
> add another one.  I can probably
> eliminate the ktime_get() and use something based on jiffies. That will
> be inaccurate for the instable case of course.
>
> I will do that later today.

sched_clock seems a bit weird to use.  In the pv_ops world, it only
counts unstolen time, and it is therefore inherently per-cpu.  The
timestamps should be at least system-wide monotonic.

    J
