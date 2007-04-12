Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXDLQpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXDLQpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965164AbXDLQpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:45:51 -0400
Received: from mx1.suse.de ([195.135.220.2]:60747 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXDLQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:45:51 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Date: Thu, 12 Apr 2007 18:45:39 +0200
User-Agent: KMail/1.9.6
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
References: <20070411162904.232696302@mvista.com> <200704121136.03098.ak@novell.com> <20070412092348.70a4de05.akpm@linux-foundation.org>
In-Reply-To: <20070412092348.70a4de05.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704121845.39961.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I was proposing that i386 and x86_64 be given a new, lockless,
> high-resolution printk_clock().  Presently x86 uses the default
> printk_clock(), which uses sched_clock().  Presumably copying the
> pre-x86_64-mm-sched-clock-share.patch version of sched_clock() into
> printk_clock() will suffice.

Ok. I think it's better to just fix sched_clock() again than to
add another one.  I can probably
eliminate the ktime_get() and use something based on jiffies. That will
be inaccurate for the instable case of course.

I will do that later today.

-Andi



