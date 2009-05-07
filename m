Return-Path: <linux-kernel-owner+w=401wt.eu-S1760882AbZEGMKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882AbZEGMKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 08:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZEGMKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 08:10:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231AbZEGMKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 08:10:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [linux-pm] [RFC][PATCH 1/5] PM/Freezer: Disable OOM killer whentasks are frozen
Date: Thu, 7 May 2009 14:09:44 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200905070040.08561.rjw@sisk.pl> <200905070041.04787.rjw@sisk.pl> <20090507003603.GD17680@us.ibm.com>
In-Reply-To: <20090507003603.GD17680@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905071409.45362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Matt Helsley wrote:
> On Thu, May 07, 2009 at 12:41:04AM +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > The OOM killer is not really going to work while tasks are frozen, so
> > we can just give up calling it in that case.
> > 
> > This will allow us to safely use memory allocations for decreasing
> > the number of saveable pages in the hibernation core code instead of
> > using any artificial memory shriking mechanisms for this purpose.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> 
> > ---
> >  include/linux/freezer.h |    2 ++
> >  kernel/power/process.c  |   12 ++++++++++++
> >  mm/page_alloc.c         |    5 +++++
> >  3 files changed, 19 insertions(+)
> > 
> > Index: linux-2.6/kernel/power/process.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/process.c
> > +++ linux-2.6/kernel/power/process.c
> > @@ -19,6 +19,8 @@
> >   */
> >  #define TIMEOUT	(20 * HZ)
> > 
> > +static bool tasks_frozen;
> > +
> >  static inline int freezeable(struct task_struct * p)
> >  {
> >  	if ((p == current) ||
> > @@ -120,6 +122,10 @@ int freeze_processes(void)
> >   Exit:
> >  	BUG_ON(in_atomic());
> >  	printk("\n");
> > +
> > +	if (!error)
> > +		tasks_frozen = true;
> > +
> 
> It's not really about whether some tasks are frozen -- that can 
> happen using the cgroup freezer too. The flag really indicates if
> all killable tasks are frozen. That can't happen using the cgroup
> freezer since the root cgroup can't be frozen. So I think some name changes 
> are in order but otherwise the patch looks fine.

Well, as I said in the [0/5] message, I'm not sure if the patch is really
necessary.  I'll change the names if it turns out to be.

Thanks,
Rafael
