Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbXBVJQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbXBVJQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbXBVJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:16:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:37451 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751514AbXBVJQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:16:39 -0500
X-Provags-ID: V01U2FsdGVkX1/DelQ9mJHDum65CHaCAzLWkVbDX/xRP7zzNEFMwD
	SNlg==
Subject: Re: [PATCH] Fix posix-cpu-timer breakage caused by stale
	p->last_ran value
From: Mike Galbraith <efault@gmx.de>
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Roman Zippel <zippel@linux-m68k.org>,
       Ken Chen <kenneth.w.chen@intel.com>, balducci@units.it,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <1172104409.25076.165.camel@localhost.localdomain>
References: <20070221104747.3cb0da32.akpm@linux-foundation.org>
	 <1172104409.25076.165.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 10:16:18 +0100
Message-Id: <1172135778.11226.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 01:33 +0100, Thomas Gleixner wrote:
> Problem description at:
> http://bugzilla.kernel.org/show_bug.cgi?id=8048
> 
> Commit b18ec80396834497933d77b81ec0918519f4e2a7 
>     [PATCH] sched: improve migration accuracy
> optimized the scheduler time calculations, but broke posix-cpu-timers.
> 
> The problem is that the p->last_ran value is not updated after a context
> switch. So a subsequent call to current_sched_time() calculates with a
> stale p->last_ran value, i.e. accounts the full time, which the task was
> scheduled away.

Oops, missed that.  You could also remove the prev->last_ran assignment
just above your addition, and turn this into a negative cost bugfix :)

	-Mike

