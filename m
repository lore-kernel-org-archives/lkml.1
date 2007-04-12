Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXDLRBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXDLRBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030474AbXDLRBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:01:45 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49850 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030457AbXDLRBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:01:43 -0400
Date: Thu, 12 Apr 2007 10:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@novell.com>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070412100039.00ace23f.akpm@linux-foundation.org>
In-Reply-To: <200704121845.39961.ak@novell.com>
References: <20070411162904.232696302@mvista.com>
	<200704121136.03098.ak@novell.com>
	<20070412092348.70a4de05.akpm@linux-foundation.org>
	<200704121845.39961.ak@novell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 18:45:39 +0200 Andi Kleen <ak@novell.com> wrote:

> 
> > I was proposing that i386 and x86_64 be given a new, lockless,
> > high-resolution printk_clock().  Presently x86 uses the default
> > printk_clock(), which uses sched_clock().  Presumably copying the
> > pre-x86_64-mm-sched-clock-share.patch version of sched_clock() into
> > printk_clock() will suffice.
> 
> Ok. I think it's better to just fix sched_clock() again than to
> add another one.  I can probably
> eliminate the ktime_get() and use something based on jiffies. That will
> be inaccurate for the instable case of course.

hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
do anything to degrade it just on behalf of printk-timestamping.
