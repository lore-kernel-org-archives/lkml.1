Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbXDWV0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbXDWV0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbXDWV0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:26:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34739 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265AbXDWV0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:26:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC][PATCH -mm 3/3] freezer: Fix problem with kthread_stop
Date: Mon, 23 Apr 2007 23:30:24 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
References: <20070419120131.GB13435@in.ibm.com> <20070423204637.GA441@tv-sign.ru> <20070423211616.GA27214@in.ibm.com>
In-Reply-To: <20070423211616.GA27214@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232330.25886.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 23 April 2007 23:16, Gautham R Shenoy wrote:
> On Tue, Apr 24, 2007 at 12:46:37AM +0400, Oleg Nesterov wrote:
> > On 04/23, Rafael J. Wysocki wrote:
> > >
> > > On Monday, 23 April 2007 14:35, Gautham R Shenoy wrote:
> > > > > +	if (!freezer_should_exempt(current)) {
> > > > 		task_lock(k);
> > > > > +		/* We are freezable, so we must make sure that the thread being
> > > > > +		 * stopped is not frozen and will not be frozen until it dies
> > > > > +		 */
> > > > > +		freezer_exempt(k);
> > > > > +		if (frozen(k))
> > > > > +			clear_frozen_flag(k);
> > > > 		task_unlock(k);
> > > > > +	}
> > > 
> > > Yes, that's correct.  We need to take task_lock() to avoid the race with
> > > refrigerator().
> > 
> > Even if we use thaw_task() ?
> 
> I don't think so. As you correctly pointed out, thaw_task() is race free
> w.r.t the refrigerator(). 

Agreed.

Rafael
