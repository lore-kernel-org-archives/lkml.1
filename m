Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYIEHlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYIEHlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYIEHkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:40:52 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31915 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514AbYIEHkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:40:51 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] Return value from schedule()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Arjan van de Ven <arjan@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-pci@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080904120522.6d5fdf8d@extreme>
References: <20080827204626.4b65862f@extreme>
	 <20080828111323.GI7908@solarflare.com> <20080903155713.7fab2e19@extreme>
	 <20080904160739.GK2772@parisc-linux.org> <20080904161424.GA23042@elte.hu>
	 <20080904162111.GM2772@parisc-linux.org>
	 <20080904103049.01f748d9@infradead.org>
	 <20080904174845.GN2772@parisc-linux.org>  <20080904120522.6d5fdf8d@extreme>
Content-Type: text/plain
Date: Fri, 05 Sep 2008 09:40:40 +0200
Message-Id: <1220600440.7080.2.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 12:05 -0700, Stephen Hemminger wrote:
> On Thu, 4 Sep 2008 11:48:45 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > On Thu, Sep 04, 2008 at 10:30:49AM -0700, Arjan van de Ven wrote:
> > > use schedule_hrtimerout() for this (hopefully will be in 2.6.28);
> > > see this weeks LWN for an article describing it
> > 
> > OK, so something like:
> > 
> > 	struct timespec ts = { 0, 10 * 1000 };
> > 
> > 	set_task_state(TASK_INTERRUPTIBLE);
> > 	schedule_hrtimeout(&ts, HRTIMER_MODE_REL);
> > 	if (fatal_signal_pending())
> > 		return -EINTR;
> > 
> > should do the trick.
> > 
> 
> Never mind, I changed it to just yield() in revision.

Gah, not another yield in the network code we have to figure out wtf its
meant to do.



