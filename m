Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZIIRGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZIIRGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZIIRGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:06:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZIIRGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:06:51 -0400
Subject: Re: [tip:sched/core] sched: Keep kthreads at default priority
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090909172916.949DA526EC9@mailhub.coreip.homeip.net>
References: <1252486344.28645.18.camel@marge.simson.net>
	 <tip-61cbe54d9479ad98283b2dda686deae4c34b2d59@git.kernel.org>
	 <20090909172916.949DA526EC9@mailhub.coreip.homeip.net>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 19:06:41 +0200
Message-Id: <1252516001.22918.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:55 -0700, Dmitry Torokhov wrote:
> On Wed, Sep 09, 2009 at 03:37:34PM +0000, tip-bot for Mike Galbraith wrote:
> > 
> > diff --git a/kernel/kthread.c b/kernel/kthread.c
> > index eb8751a..5fe7099 100644
> > --- a/kernel/kthread.c
> > +++ b/kernel/kthread.c
> > @@ -16,8 +16,6 @@
> >  #include <linux/mutex.h>
> >  #include <trace/events/sched.h>
> >  
> > -#define KTHREAD_NICE_LEVEL (-5)
> > -
> 
> Why don't we just redefine it to 0? We may find out later that we'd
> still prefer to have kernel threads have boost.

Seems sensible, also the traditional reasoning behind this nice level is
that kernel threads do work on behalf of multiple tasks. Its a kind of
prio ceiling thing.

