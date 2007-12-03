Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbXLCW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbXLCW26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXLCW2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:28:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXLCW2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:28:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
Date: Mon, 3 Dec 2007 23:47:36 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
       penberg@cs.helsinki.fi, lkml@astralstorm.puszkin.org,
       arjan@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <20071202165913.3eaebee6@laptopd505.fenrus.org> <200712031928.53659.rjw@sisk.pl> <20071203192426.GA8017@elte.hu>
In-Reply-To: <20071203192426.GA8017@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032347.37723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 of December 2007, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > > This feature will save one full reporter-developer round-trip during 
> > > investigation of a significant number of bug reports.
> > > 
> > > It might be more practical if it were to dump the traces for _all_ 
> > > D-state processes when it fires - basically an auto-triggered 
> > > sysrq-W.
> > 
> > Er, it won't play well if that happen when tasks are frozen for 
> > suspend.
> 
> right now any suspend attempt times out after 20 seconds:
> 
>   $ grep TIMEOUT kernel/power/process.c
>   #define TIMEOUT (20 * HZ)
>           end_time = jiffies + TIMEOUT;

This is the timeout for freezing tasks, but if the freezing succeeds, they
can stay in TASK_UNINTERRUPTIBLE for quite some more time, especially during
a hibernation (the tasks stay frozen until we power off the system after saving
the image).

> which should be well before the 120 seconds timeout that the detector 
> uses. But indeed you are right in that the refrigerator() works via 
> TASK_UNINTERRUPTIBLE too. I've updated the patch to exclude PF_FROZEN - 
> attached below. That should solve this particular issue, even if the 
> timeout increased to above 20 secs, right?

Sure.

Thanks,
Rafael
