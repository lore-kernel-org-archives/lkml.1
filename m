Return-Path: <linux-kernel-owner+w=401wt.eu-S1030180AbXDKTdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030180AbXDKTdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030185AbXDKTdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:33:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030180AbXDKTdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:33:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] kthread: Don't depend on work queues
Date: Wed, 11 Apr 2007 21:37:21 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com
References: <20070410185133.GA104@tv-sign.ru> <20070411133139.GB10623@in.ibm.com> <20070411143626.GA125@tv-sign.ru>
In-Reply-To: <20070411143626.GA125@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704112137.22758.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 11 April 2007 16:36, Oleg Nesterov wrote:
> On 04/11, Gautham R Shenoy wrote:
> > On Wed, Apr 11, 2007 at 03:48:05PM +0400, Oleg Nesterov wrote:
> > > On 04/11, Gautham R Shenoy wrote:
> > > >
> > > > On Wed, Apr 11, 2007 at 12:13:34PM +0200, Rafael J. Wysocki wrote:
> > > > > 
> > > > > It should be calling try_to_freeze() somewhere anyway.  We may need to freeze
> > > > > all tasks in some cases.
> > > > 
> > > > How about
> > > > for (;;) {
> > > > 	try_to_freeze();
> > > > 
> > > > ?
> > > 
> > > Why?
> > 
> > If some event (defintely NOT cpu hotplug) needs this thread frozen.
> > 
> > > 
> > > > This change allows us to make all the worker threads freezeable by default.
> > > > >From cpu-hotplug perspective, helper_wq was the only singlethreaded
> > > > non-freezeable workqueue.
> > > 
> > > I think Eric's patch is what you need. We should _not_ freeze kthreadd(), we
> > > need kthread_create() after freezing. Now it doesn't depend on workqueues, we
> > > can freeze them all, single-thread or not.
> > > 
> > 
> > These were my exact thoughts. 
> 
> Sorry, I misunderstood your message.
> 
> Yes, we can freeze it with FE_HOTPLUG_CPU. In that case wait_event()
> should also check !freezing(), and try_to_freeze() should be called
> after case wait_event().
> 
> On the other hand, if "kthreadd" does not sleep on kthread_create_work,
> we have another unfrozen process waiting for kthread_create_info.done.
> So, is there any practical reason why kthreadd() should explicitely go
> to refrigerator?

Good question.  Right now, there probably is not any.

Greetings,
Rafael
