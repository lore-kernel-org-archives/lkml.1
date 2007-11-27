Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbXK2PG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbXK2PG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762393AbXK2PGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:06:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762400AbXK2PGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:06:47 -0500
Date: Tue, 27 Nov 2007 14:57:47 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Message-ID: <20071127145747.5f4d0aca@laptopd505.fenrus.org>
In-Reply-To: <1196155985.25646.31.camel@ymzhang>
References: <1196155985.25646.31.camel@ymzhang>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 17:33:05 +0800
"Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> If echo "1">/proc/sys/kernel/sched_compat_yield before starting
> volanoMark testing, the result is very good with kernel 2.6.24-rc3 on
> my 16-core tigerton.
> 
> 1) If /proc/sys/kernel/sched_compat_yield=1, comparing with 2.6.22,
> 2.6.24-rc3 has more than 70% improvement;
> 2) If /proc/sys/kernel/sched_compat_yield=0, comparing with 2.6.22,
> 2.6.24-rc3 has more than 80% regression;
> 
> On other machines, the volanoMark result also has much improvement if
> /proc/sys/kernel/sched_compat_yield=1.
> 
> Would you like to change function yield_task_fair to delete codes
> around sysctl_sched_compat_yield, or just initiate it to 1?
> 

sounds like a bad idea; volanomark (well, technically the jvm behind
it) is abusing sched_yield() by assuming it does something it really
doesn't do, and as it happens some of the earlier 2.6 schedulers
accidentally happened to behave in a way that was nice for this
benchmark. 

Todays kernel has a different behavior somewhat (and before people
scream "regression"; sched_yield() behavior isn't really specified and
doesn't make any sense at all, whatever you get is what you get....
it's pretty much an insane defacto behavior that is incredibly tied to
which decisions the scheduler makes how, and no app can depend on that
in any way. In fact, I've proposed to make sched_yield() just do an
msleep(1)... that'd be closer to what sched_yield is supposed to do
standard wise than any of the current behaviors .... ;_


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
