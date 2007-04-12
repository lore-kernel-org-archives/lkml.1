Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXDLR5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXDLR5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030636AbXDLR5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:57:14 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634AbXDLR5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:57:13 -0400
Date: Thu, 12 Apr 2007 10:55:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@novell.com>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH] i386 tsc: remove xtime_lock'ing around cpufreq notifier
Message-Id: <20070412105559.385789dd.akpm@linux-foundation.org>
In-Reply-To: <461E6FA7.5080605@goop.org>
References: <20070411162904.232696302@mvista.com>
	<200704121136.03098.ak@novell.com>
	<20070412092348.70a4de05.akpm@linux-foundation.org>
	<200704121845.39961.ak@novell.com>
	<20070412100039.00ace23f.akpm@linux-foundation.org>
	<461E6FA7.5080605@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007 10:43:03 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > hm.  People (ab)use sched_clock() for all sorts of things nowadays.  I wouldn't
> > do anything to degrade it just on behalf of printk-timestamping.
> >   
> 
> printk was the only non-scheduler-ish use I could find.  Are there others?
> 

blktrace.  I've seen a couple of trace/debug-style things which use
sched_clock for timestamping event collection. I think lttng does exotic
things with TSCs, performing private skew correction, although that might
have changed now.
