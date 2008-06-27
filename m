Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYF0Qka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYF0Qka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYF0QkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:40:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:45161 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYF0QkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:40:11 -0400
Date: Fri, 27 Jun 2008 20:42:23 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Paul Menage <menage@google.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Message-ID: <20080627164223.GC508@tv-sign.ru>
References: <48634BC1.8@google.com> <20080627032228.GA3419@in.ibm.com> <20080627032317.GB3419@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627032317.GB3419@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Gautham R Shenoy wrote:
>
> > Using a multithreaded workqueue(kevent here) for this is not such a
> > great idea this,since currently we cannot call
> > get_online_cpus() from a workitem executed by a multithreaded workqueue.
> > 
> > Can one use a single threaded workqueue here instead ?

Yes, this should help.

But I think you are right, we should just fix this annoying problem,

> > Or, better, I think we can ask Oleg to re-submit the patch he had to make
> > get_online_cpus() safe to be called from within the workqueue. It does
> > require a special post CPU_DEAD notification, but as it does work the
> > last time I checked.

OK, will do on Sunday.

Oleg.

