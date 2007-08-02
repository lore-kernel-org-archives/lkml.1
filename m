Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbXHBVlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbXHBVlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbXHBVk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:40:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42690 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbXHBVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:40:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm 2/3] Freezer: Use wait queue instead of busy looping (updated)
Date: Thu, 2 Aug 2007 23:49:43 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708012328.23939.rjw@sisk.pl> <200708022313.32944.rjw@sisk.pl> <20070802212307.GA521@tv-sign.ru>
In-Reply-To: <20070802212307.GA521@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708022349.44778.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 2 August 2007 23:23, Oleg Nesterov wrote:
> On 08/02, Rafael J. Wysocki wrote:
> >
> > On Thursday, 2 August 2007 20:40, Oleg Nesterov wrote:
> > > On 08/02, Rafael J. Wysocki wrote:
> > > >
> > > > @@ -171,6 +186,10 @@ static int try_to_freeze_tasks(int freez
> > > >  
> > > >  	end_time = jiffies + TIMEOUT;
> > > >  	do {
> > > > +		DEFINE_WAIT(wait);
> > > > +
> > > > +		add_wait_queue(&refrigerator_waitq, &wait);
> > > 
> > > Hmm. In that case I'd sugest to use prepare_to_wait(). This means that
> > > multiple wakeups from refrigerator() won't do unnecessary work,
> > 
> > I'm not sure what you mean.
> > 
> > Do you mean that if we are TASK_UNINTERRUPTIBLE, then the first wake up
> > should remove us from the queue?
> 
> No, not because we are TASK_UNINTERRUPTIBLE, but yes, first wake up will
> remove us because DEFINE_WAIT() uses autoremove_wake_function().

Yes, it does, but the prepare_to_wait() version would only cause current to
become TASK_UNINTERRUPTIBLE before it sends freezing requests, the other
differences don't seem to matter.  I'm trying to understand why it would change
the behavior in the way you have described.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
