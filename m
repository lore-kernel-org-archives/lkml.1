Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXBNUXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXBNUXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXBNUXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:23:46 -0500
Received: from mail.screens.ru ([213.234.233.54]:54498 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563AbXBNUXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:23:45 -0500
Date: Wed, 14 Feb 2007 23:23:16 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, akpm@osdl.org, paulmck@us.ibm.com,
       mingo@elte.hu, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [RFC PATCH(Experimental) 2/4] Revert changes to workqueue.c
Message-ID: <20070214202316.GD301@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <20070214144229.GA19789@in.ibm.com> <20070214144305.GB19789@in.ibm.com> <20070214152458.GA5200@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214152458.GA5200@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14, Srivatsa Vaddagiri wrote:
>
> On Wed, Feb 14, 2007 at 08:13:05PM +0530, Gautham R Shenoy wrote:
> > +	switch (action) {
> > +	case CPU_UP_PREPARE:
> > +		/* Create a new workqueue thread for it. */
> > +		list_for_each_entry(wq, &workqueues, list) {
> 
> Its probably safe to take the workqueue (spin) lock here (and other
> notifiers as well), before traversing the list.

We can't fork() under spin lock.

> 
> > +			cwq = per_cpu_ptr(wq->cpu_wq, hotcpu);
> > +			if (create_workqueue_thread(cwq, hotcpu)) {
> > +				printk("workqueue for %i failed\n", hotcpu);
> > +				return NOTIFY_BAD;
> > +			}
> > +		}
> > +		break;

Oleg.

