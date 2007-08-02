Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbXHBVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbXHBVWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbXHBVWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:22:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:60459 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXHBVWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:22:44 -0400
Date: Fri, 3 Aug 2007 01:23:07 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping (updated)
Message-ID: <20070802212307.GA521@tv-sign.ru>
References: <200708012328.23939.rjw@sisk.pl> <200708021938.37547.rjw@sisk.pl> <20070802184002.GA283@tv-sign.ru> <200708022313.32944.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708022313.32944.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Rafael J. Wysocki wrote:
>
> On Thursday, 2 August 2007 20:40, Oleg Nesterov wrote:
> > On 08/02, Rafael J. Wysocki wrote:
> > >
> > > @@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
> > >  
> > >  	end_time = jiffies + TIMEOUT;
> > >  	do {
> > > +		DEFINE_WAIT(wait);
> > > +
> > > +		add_wait_queue(&refrigerator_waitq, &wait);
> > 
> > Hmm. In that case I'd sugest to use prepare_to_wait(). This means that
> > multiple wakeups from refrigerator() won't do unnecessary work,
> 
> I'm not sure what you mean.
> 
> Do you mean that if we are TASK_UNINTERRUPTIBLE, then the first wake up
> should remove us from the queue?

No, not because we are TASK_UNINTERRUPTIBLE, but yes, first wake up will
remove us because DEFINE_WAIT() uses autoremove_wake_function().

Oleg.

