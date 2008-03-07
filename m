Return-Path: <linux-kernel-owner+w=401wt.eu-S1751851AbYCGXoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbYCGXoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbYCGXn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:43:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYCGXn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:43:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Date: Sat, 8 Mar 2008 00:43:15 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, dmitry.adamushko@gmail.com,
       ego@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, yi.y.yang@intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com> <20080307230126.GA15909@linux-os.sc.intel.com> <20080307152934.5c4052db.akpm@linux-foundation.org>
In-Reply-To: <20080307152934.5c4052db.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803080043.16817.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 8 of March 2008, Andrew Morton wrote:
> On Fri, 7 Mar 2008 15:01:26 -0800
> Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > 
> > Andrew, Please check if the appended patch fixes your power-off problem aswell.
> > ...
> >
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -5882,6 +5882,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		break;
> >  
> >  	case CPU_DOWN_PREPARE:
> > +	case CPU_DOWN_PREPARE_FROZEN:
> >  		/* Update our root-domain */
> >  		rq = cpu_rq(cpu);
> >  		spin_lock_irqsave(&rq->lock, flags);
> 
> No, it does not.

Well, this is a bug nevertheless.

In fact, the frozen bit should only be set during hibernation/suspend and not
during shutdown ...

So, it looks like disable_nonboot_cpus() needs an extra parameter.
