Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbYBNUYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbYBNUYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbYBNUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:24:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYBNUY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:24:27 -0500
Date: Thu, 14 Feb 2008 12:23:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Corey Minyard <minyard@acm.org>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
       kbaidarov@ru.mvista.com
Subject: Re: [PATCH 3/4] IPMI: convert locked counters to atomics
Message-Id: <20080214122333.397d83d1.akpm@linux-foundation.org>
In-Reply-To: <47B49776.7000802@acm.org>
References: <20080214183051.GC20148@minyard.local>
	<20080214111143.7e0937ea.akpm@linux-foundation.org>
	<47B49776.7000802@acm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 13:33:10 -0600
Corey Minyard <minyard@acm.org> wrote:

> Andrew Morton wrote:
> >> +	for (i = 0; i < IPMI_NUM_STATS; i++)
> >> +		atomic_set(&intf->stats[i], 0);
> >>     
> >
> > And this is why it would be very hard for any architecture to ever
> > implement atomic_t as
> >
> > struct atomic_t {
> > 	int counter;
> > 	spinlock_t lock;
> > };
> >
> > The interface assumes that atomic_set() fully initialises the atomic_t, and
> > that atomic_set() can be used agaisnt both an uninitialised atomic_t and
> > against an already-initialised atomic_t.  IOW, we don't have atomic_init().
> >
> > So would our hypothetical future architcture's atomic_set() do spin_lock(),
> > or would it do spin_lock_init()?  Either one is wrong in many atomic_set
> > callsites.
> >
> > Oh well.
> >   
> Yeah, I thought the same thing when I did this.  Do we start working
> on an atomic_init()?  It would be easy enough to set it to atomic_set()
> for current architectures.

I suppose we should, but I can't say I'm terribly excited by the prospect ;)
