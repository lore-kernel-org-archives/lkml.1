Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYFAOpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYFAOpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYFAOoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:44:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2201 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbYFAOoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:44:54 -0400
Date: Sat, 31 May 2008 23:27:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080531212709.GA6757@ucw.cz>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <483AF25B.6090806@linux.vnet.ibm.com> <20080526110040.5ddc4656@infradead.org> <483B0348.2000204@linux.vnet.ibm.com> <20080526115108.6a19e2c0@infradead.org> <483C059B.9040301@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483C059B.9040301@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > without knowing anything else than this, then yes that would be a
> > logical conclusion: the most likely cause would be because your cpu is
> > memory bound. In fact, you could then scale down your cpu
> > frequency/voltage to be lower, and save some power without losing
> > performance. 
> > It's a weird workload though, its probably a time based thing where you
> > alternate between idle and fully memory bound loads.
> > 
> > (which is another case where your patches would then expose idle time
> > even though your cpu is fully utilized for the 50% of the time it's
> > running)
> 
> We expect the end user to see 50% as scaled utilization and 100% as normal
> utilization. We don't intend to remove tsk->utime and tsk->stime. Our patches
> intend to provide the data and not impose what control action should be taken.

Aha, ok, forget about my regression comments.

Still, what you want to do seems hard. What if cpu is running at max
frequency but memory is not? What if cpu and memory is running at max
frequency but frontside bus is not?

You want some give_me_bogomips( cpu freq, mem freq, fsb freq ) function,
but that depends on workload, so it is impossible to do...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
